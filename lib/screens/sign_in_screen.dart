import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:skinsync_clinic_portal/models/requests/login_request_model.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/utils/validators.dart';

import '../utils/assets.dart';
import '../utils/color_constant.dart';
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
    return Scaffold(
      body: Row(
        children: [
          // Left logo panel (landscape only)
          if (context.isLandscape)
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.w,
                        height: 200.h,
                        child: Image.asset(
                          PngAssets.splashLogo,
                          height: 100.w,
                          width: 100.w,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Text(
                        "SkinSync AI",
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7BA8),
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Container(width: 1.w, color: Colors.grey.shade300),
          // Right content panel
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
              child: Column(
                children: [
                  if (_currentScreen == AuthScreen.login)
                    Container(
                      height: 64.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.r),
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
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
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
                            height: 50.h,
                            padding: EdgeInsets.zero,
                          ),

                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),

                          // Icon
                          iconStyleData: IconStyleData(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            iconSize: 24.sp,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(0, -2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),

                          // Menu item style
                          menuItemStyleData: MenuItemStyleData(
                            height: 45.h,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 30.h),
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
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: CustomColors.softGrey,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, size: 18.sp, color: Colors.black),
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(SvgAssets.stethoscope, height: 60.h, width: 60.w),
            SizedBox(height: 8.h),
            Text(
              "Doctor (Clinic Owner)",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Full administrative and clinical access",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Email Address",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(height: 0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              decoration: InputDecoration(hintText: "Enter Your Email Address"),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Password",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
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
                    color: Colors.grey.shade600,
                    size: 20.sp,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: _goToForgetPassword,
                child: Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF2881F5),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
              onTap: () {
                if (!_formKey.currentState!.validate()) return;
                ref
                    .read(authViewModelProvider.notifier)
                    .login(
                      loginReq: LoginRequestModel(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ),
                    )
                    .then((success) {
                      if (success && context.mounted) {
                        context.goNamed(HomeScreen.routeName);
                      }
                    });
              },
              child: Container(
                width: 215.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forgetPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
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
            SizedBox(height: 16.h),
            SvgPicture.asset(SvgAssets.stethoscope, height: 60.h, width: 60.w),
            SizedBox(height: 8.h),
            Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Enter your email to receive a verification code",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Email Address",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(height: 0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
              decoration: InputDecoration(hintText: "Enter Your Email Address"),
            ),
            SizedBox(height: 30.h),
            GestureDetector(
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
              child: Container(
                width: 215.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Send Code",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _verifyOtpWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
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
            SizedBox(height: 16.h),
            SvgPicture.asset(SvgAssets.stethoscope, height: 60.h, width: 60.w),
            SizedBox(height: 8.h),
            Text(
              "Verify Email",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "We just sent a 6-digit code to ${_emailController.text}, enter it below:",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Enter OTP",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(height: 0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
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
                      separatorBuilder: (index) => SizedBox(width: 10.w),
                      length: 6,
                      onChanged: (pin) {
                        if (field.hasError) field.didChange(pin);
                        if (_otpError != null) setState(() => _otpError = null);
                      },
                      onCompleted: (pin) => field.didChange(pin),
                      defaultPinTheme: PinTheme(
                        width: 60.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          border: Border.all(
                            color: field.hasError
                                ? Colors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        textStyle: TextStyle(fontSize: 16.sp),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 60.5.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: CustomColors.softGrey,
                          border: Border.all(
                            color: field.hasError
                                ? Colors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        textStyle: TextStyle(fontSize: 16.sp),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 60.5.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          border: Border.all(
                            color: field.hasError
                                ? Colors.red
                                : CustomColors.border,
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        textStyle: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    if (_otpError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          _otpError!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 30.h),
            GestureDetector(
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
              child: Container(
                width: 215.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verify Email",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createNewPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
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
            SizedBox(height: 16.h),
            SvgPicture.asset(SvgAssets.stethoscope, height: 60.h, width: 60.w),
            SizedBox(height: 8.h),
            Text(
              "Create New Password",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Your new password must be different from your previous password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 30.h),

            // ✅ New Password Field
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "New Password",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(height: 0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
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
                    color: Colors.grey.shade600,
                    size: 20.sp,
                  ),
                  onPressed: () => setState(
                    () => _obscureNewPassword = !_obscureNewPassword,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Confirm Password",
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(height: 0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8.h),
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
                    color: Colors.grey.shade600,
                    size: 20.sp,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmNewPassword =
                        !_obscureConfirmNewPassword,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            GestureDetector(
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
              child: Container(
                width: 215.w,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(30.r)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save Password",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
