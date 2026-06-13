import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:skinsync_clinic_portal/models/requests/login_request_model.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/utils/validators.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';

import '../utils/assets.dart';
import '../utils/enums.dart';
import '../view_models/auth_view_model.dart';
import 'dashboard/home_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign-in-screen';

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyForgetPassword = GlobalKey<FormState>();
  final _formKeyVerifyOtp = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;
  final _formKeyCreateNewPassword = GlobalKey<FormState>();

  bool _obscurePassword = true;

  AuthScreen _currentScreen = AuthScreen.login;

  String? _otpError;

  String selectedValue = 'Doctor (Clinic Owner)';
  final List<String> roles = [
    'Doctor (Clinic Owner)',
    'Receptionist',
    'Assistant',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _goToForgetPassword() =>
      setState(() => _currentScreen = AuthScreen.forgetPassword);
  void _goToVerifyOtp() =>
      setState(() => _currentScreen = AuthScreen.verifyOtp);
  void _goToCreateNewPassword() =>
      setState(() => _currentScreen = AuthScreen.createNewPassword);

  void _goToLogin() {
    setState(() {
      _currentScreen = AuthScreen.login;
      _otpController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();
      _otpError = null;
    });
  }

  void _goBackToForgetPassword() {
    setState(() {
      _currentScreen = AuthScreen.forgetPassword;
      _otpController.clear();
      _otpError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Row(
        children: [
          // Left logo panel (landscape only)
          if (context.isLandscape)
            Expanded(
              child: Container(
                color: CustomColors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.w(200),
                        height: context.h(200),
                        child: Image.asset(
                          PngAssets.splashLogo,
                          height: context.h(100),
                          width: context.w(100),
                        ),
                      ),
                      SizedBox(height: context.h(30)),
                      Text(
                        "SkinSync AI",
                        style: context.fonts.black50w600.copyWith(
                          color: const Color(0xFF6B7BA8),
                          letterSpacing: 4,
                          fontSize: context.sp(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Container(width: 1, color: CustomColors.border),
          // Right content panel
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(50),
                vertical: context.h(50),
              ),
              child: Column(
                children: [
                  if (_currentScreen == AuthScreen.login)
                    Container(
                      height: context.h(64),
                      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                      decoration: BoxDecoration(
                        color: CustomColors.black,
                        borderRadius: BorderRadius.circular(context.r(12)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedValue,
                          items: roles
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: context.fonts.white14w600,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value!;
                            });
                          },

                          buttonStyleData: ButtonStyleData(
                            height: context.h(50),
                            padding: EdgeInsets.zero,
                          ),

                          style: context.fonts.black14w400,

                          // Icon
                          iconStyleData: IconStyleData(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: CustomColors.white,
                            ),
                            iconSize: context.sp(24),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(0, -2),
                            decoration: BoxDecoration(
                              color: CustomColors.black,
                              borderRadius: BorderRadius.circular(context.r(12)),
                            ),
                          ),

                          // MenuItem style
                          menuItemStyleData: MenuItemStyleData(
                            height: context.h(45),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: context.h(30)),
                  if (_currentScreen == AuthScreen.login) _loginWidget(),
                  if (_currentScreen == AuthScreen.forgetPassword)
                    _forgetPasswordWidget(),
                  if (_currentScreen == AuthScreen.verifyOtp)
                    _verifyOtpWidget(),
                  if (_currentScreen == AuthScreen.createNewPassword)
                    _createNewPasswordWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(VoidCallback onTap) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: context.w(36),
          height: context.w(36),
          decoration: const BoxDecoration(
            color: CustomColors.softGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            size: context.sp(18),
            color: CustomColors.black,
          ),
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(40),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(Radius.circular(context.r(12))),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              SvgAssets.stethoscope,
              height: context.h(60),
              width: context.w(60),
            ),
            SizedBox(height: context.h(8)),
            Text("Doctor (Clinic Owner)", style: context.fonts.black20w600),
            SizedBox(height: context.h(8)),
            Text(
              "Full administrative and clinical access",
              style: context.fonts.grey14w400,
            ),
            SizedBox(height: context.h(40)),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Email Address",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              decoration:
                  const InputDecoration(hintText: "Enter Your Email Address"),
            ),
            SizedBox(height: context.h(20)),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Password",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            TextFormField(
              controller: _passwordController,
              validator: Validators.password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: CustomColors.grey,
                    size: context.sp(20),
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _goToForgetPassword,
                child: Text(
                  "Forget Password",
                  style: context.fonts.purple16w600.copyWith(
                    fontSize: context.sp(12),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(30)),
            CustomPrimaryButton(
              onTap: () async {
                if (!_formKey.currentState!.validate()) return;
                final success = await ref
                    .read(authViewModelProvider.notifier)
                    .login(
                      loginReq: LoginRequestModel(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ),
                    );
                if (success && mounted) {
                  context.goNamed(HomeScreen.routeName);
                }
              },
              label: "Sign In",
              width: context.w(215),
              isLoading: ref.watch(authViewModelProvider).loading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgetPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(40),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(Radius.circular(context.r(12))),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKeyForgetPassword,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBackButton(_goToLogin),
            SizedBox(height: context.h(16)),
            SvgPicture.asset(
              SvgAssets.stethoscope,
              height: context.h(60),
              width: context.w(60),
            ),
            SizedBox(height: context.h(8)),
            Text("Forgot Password", style: context.fonts.black20w600),
            SizedBox(height: context.h(8)),
            Text(
              "Enter your email to receive a verification code",
              style: context.fonts.grey14w400,
            ),
            SizedBox(height: context.h(20)),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Email Address",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              decoration:
                  const InputDecoration(hintText: "Enter Your Email Address"),
            ),
            SizedBox(height: context.h(30)),
            CustomPrimaryButton(
              onTap: () {
                if (!_formKeyForgetPassword.currentState!.validate()) return;
                ref
                    .read(authViewModelProvider.notifier)
                    .forgetPassword(email: _emailController.text.trim())
                    .then((success) {
                  if (success && context.mounted) {
                    _goToVerifyOtp();
                  }
                });
              },
              label: "Send Code",
              width: context.w(215),
              isLoading: ref.watch(authViewModelProvider).loading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifyOtpWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(40),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(Radius.circular(context.r(12))),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKeyVerifyOtp,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBackButton(_goBackToForgetPassword),
            SizedBox(height: context.h(16)),
            SvgPicture.asset(
              SvgAssets.stethoscope,
              height: context.h(60),
              width: context.w(60),
            ),
            SizedBox(height: context.h(8)),
            Text("Verify Email", style: context.fonts.black20w600),
            SizedBox(height: context.h(8)),
            Text(
              "We just sent a 6-digit code to ${_emailController.text}, enter it below:",
              textAlign: TextAlign.center,
              style: context.fonts.grey14w400,
            ),
            SizedBox(height: context.h(20)),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Enter OTP",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            FormField<String>(
              validator: (_) {
                if (_otpController.text.isEmpty) return 'Please enter the OTP';
                if (_otpController.text.length < 6) {
                  return 'Please enter all 6 digits';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Pinput(
                      controller: _otpController,
                      mainAxisAlignment: MainAxisAlignment.center,
                      separatorBuilder: (index) => SizedBox(width: context.w(10)),
                      length: 6,
                      onChanged: (pin) {
                        if (field.hasError) field.didChange(pin);
                        if (_otpError != null) setState(() => _otpError = null);
                      },
                      onCompleted: (pin) => field.didChange(pin),
                      defaultPinTheme: PinTheme(
                        width: context.w(60),
                        height: context.h(48),
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          border: Border.all(
                            color: field.hasError
                                ? CustomColors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(context.r(15)),
                        ),
                        textStyle: context.fonts.black16w400,
                      ),
                      focusedPinTheme: PinTheme(
                        width: context.w(60.5),
                        height: context.h(48),
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          border: Border.all(
                            color: field.hasError
                                ? CustomColors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(context.r(15)),
                        ),
                        textStyle: context.fonts.black16w400,
                      ),
                      submittedPinTheme: PinTheme(
                        width: context.w(60.5),
                        height: context.h(48),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: field.hasError
                                ? CustomColors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(context.r(15)),
                        ),
                        textStyle: context.fonts.black16w400,
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: context.h(8)),
                        child: Text(
                          field.errorText!,
                          style: context.fonts.red11w600.copyWith(
                            fontSize: context.sp(12),
                          ),
                        ),
                      ),
                    if (_otpError != null)
                      Padding(
                        padding: EdgeInsets.only(top: context.h(8)),
                        child: Text(
                          _otpError!,
                          style: context.fonts.red11w600.copyWith(
                            fontSize: context.sp(12),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: context.h(30)),
            CustomPrimaryButton(
              onTap: () {
                if (!_formKeyVerifyOtp.currentState!.validate()) return;
                ref
                    .read(authViewModelProvider.notifier)
                    .verifyOtp(
                      email: _emailController.text.trim(),
                      otp: _otpController.text.trim(),
                    )
                    .then((success) {
                  if (success && context.mounted) {
                    _goToCreateNewPassword();
                  } else if (!success && context.mounted) {
                    setState(
                      () => _otpError = 'Invalid OTP. Please try again.',
                    );
                  }
                });
              },
              label: "Verify Email",
              width: context.w(215),
              isLoading: ref.watch(authViewModelProvider).loading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _createNewPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(40),
        vertical: context.h(40),
      ),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.all(Radius.circular(context.r(12))),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKeyCreateNewPassword,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBackButton(_goBackToForgetPassword),
            SizedBox(height: context.h(16)),
            SvgPicture.asset(
              SvgAssets.stethoscope,
              height: context.h(60),
              width: context.w(60),
            ),
            SizedBox(height: context.h(8)),
            Text("Create New Password", style: context.fonts.black20w600),
            SizedBox(height: context.h(8)),
            Text(
              "Your new password must be different from your previous password",
              textAlign: TextAlign.center,
              style: context.fonts.grey14w400,
            ),
            SizedBox(height: context.h(30)),

            // ✅ New Password Field
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "New Password",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNewPassword,
              validator: Validators.password,
              decoration: InputDecoration(
                hintText: "Enter new password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: CustomColors.grey,
                    size: context.sp(20),
                  ),
                  onPressed: () => setState(
                    () => _obscureNewPassword = !_obscureNewPassword,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(20)),

            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Confirm Password",
                  style: context.fonts.black14w600,
                  children: [
                    TextSpan(
                      text: " *",
                      style: context.fonts.red14w600,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(8)),
            TextFormField(
              controller: _confirmNewPasswordController,
              obscureText: _obscureConfirmNewPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "Confirm new password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmNewPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: CustomColors.grey,
                    size: context.sp(20),
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmNewPassword =
                        !_obscureConfirmNewPassword,
                  ),
                ),
              ),
            ),
            SizedBox(height: context.h(30)),

            CustomPrimaryButton(
              onTap: () {
                if (!_formKeyCreateNewPassword.currentState!.validate()) return;
                ref
                    .read(authViewModelProvider.notifier)
                    .createNewPassword(
                      email: _emailController.text.trim(),
                      newPassword: _newPasswordController.text.trim(),
                    )
                    .then((success) {
                  if (success && context.mounted) {
                    _goToLogin();
                  }
                });
              },
              label: "Save Password",
              width: context.w(215),
              isLoading: ref.watch(authViewModelProvider).loading,
            ),
          ],
        ),
      ),
    );
  }
}
