import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../utils/assets.dart';
import '../utils/enums.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import 'dashboard/home_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const String routeName = '/sign-in-screen';

  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  AuthScreen _currentScreen = AuthScreen.login;
  String? _otpError;

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
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  void setCurrentScreen(AuthScreen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _goToForgetPassword() => setCurrentScreen(AuthScreen.forgetPassword);
  void _goToVerifyOtp() => setCurrentScreen(AuthScreen.verifyOtp);
  void _goToCreateNewPassword() =>
      setCurrentScreen(AuthScreen.createNewPassword);

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
      body: Stack(
        children: [
          Positioned(
            top: context.h(-100),
            right: context.w(-100),
            child: Container(
              width: context.w(400),
              height: context.w(400),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.green.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: context.h(-150),
            left: context.w(-150),
            child: Container(
              width: context.w(500),
              height: context.w(500),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CustomColors.purple.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBranding(context),
                  context.verticalSpace(40),
                  _buildAuthCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          PngAssets.splashLogo,
          height: context.w(100),
          width: context.w(100),
          fit: BoxFit.contain,
        ),
        context.verticalSpace(32),
        Text("SkinSync AI", style: context.fonts.black40w700),
        context.verticalSpace(2),
        Text(
          "CLINIC PORTAL",
          style: TextStyle(
            fontSize: context.sp(14),
            fontWeight: FontWeight.w800,
            color: CustomColors.purple,
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthCard(BuildContext context) {
    return Container(
      width: context.w(450),
      padding: context.appEdgeInsets(all: 40),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: context.borderRadius(all: 20),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.lg(context),
      ),
      child: Form(
        key: _formKey,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _getCurrentForm(context),
        ),
      ),
    );
  }

  Widget _getCurrentForm(BuildContext context) {
    switch (_currentScreen) {
      case AuthScreen.login:
        return _loginForm(context);
      case AuthScreen.forgetPassword:
        return _forgetPasswordForm(context);
      case AuthScreen.verifyOtp:
        return _verifyOtpForm(context);
      case AuthScreen.createNewPassword:
        return _createNewPasswordForm(context);
    }
  }

  Widget _loginForm(BuildContext context) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Back", style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "Enter your credentials to access the clinic portal.",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        BuildTextField(
          label: "Email Address",
          hintText: "Enter Your Email Address",
          controller: _emailController,
          validator: Validators.email,
          prefixIcon: Icon(
            Icons.alternate_email_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
        ),
        context.verticalSpace(24),
        BuildTextField(
          label: "Password",
          hintText: "Enter your password",
          controller: _passwordController,
          obscureText: _obscurePassword,
          validator: Validators.password,
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
          suffixIcon: IconButton(
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
          ),
        ),
        context.verticalSpace(16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _goToForgetPassword,
            child: Text("Forgot Password?", style: context.fonts.purple14w600),
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton("Sign In", _handleLogin),
      ],
    );
  }

  Widget _forgetPasswordForm(BuildContext context) {
    return Column(
      key: const ValueKey('forgot'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: _goToLogin,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: CustomColors.softGrey),
        ),
        context.verticalSpace(24),
        Text("Reset Password", style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "Enter your email and we'll send you an OTP code.",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        BuildTextField(
          label: "Registered Email",
          hintText: "Enter Your Email Address",
          controller: _emailController,
          validator: Validators.email,
          prefixIcon: Icon(
            Icons.alternate_email_rounded,
            size: context.sp(20),
            color: CustomColors.lightGrey,
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton("Send Reset Code", _handleForgotPassword),
      ],
    );
  }

  Widget _verifyOtpForm(BuildContext context) {
    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: _goBackToForgetPassword,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: CustomColors.softGrey),
        ),
        context.verticalSpace(24),
        Text("Verify Email", style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "We just sent a 6-digit code to ${_emailController.text}, enter it below:",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
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
                  length: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (pin) {
                    if (field.hasError) field.didChange(pin);
                    if (_otpError != null) setState(() => _otpError = null);
                  },
                  onCompleted: (pin) => field.didChange(pin),
                  defaultPinTheme: PinTheme(
                    width: context.w(56),
                    height: context.w(56),
                    textStyle: context.fonts.black18w600,
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: context.borderRadius(all: 12),
                      border: Border.all(
                        color: field.hasError || _otpError != null
                            ? CustomColors.red
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: context.w(56),
                    height: context.w(56),
                    textStyle: context.fonts.black18w600,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: context.borderRadius(all: 12),
                      border: Border.all(
                        color: field.hasError || _otpError != null
                            ? CustomColors.red
                            : CustomColors.purple,
                        width: 2,
                      ),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: context.w(56),
                    height: context.w(56),
                    textStyle: context.fonts.black18w600,
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: context.borderRadius(all: 12),
                      border: Border.all(
                        color: field.hasError || _otpError != null
                            ? CustomColors.red
                            : CustomColors.purple,
                      ),
                    ),
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
        context.verticalSpace(32),
        _buildSubmitButton("Verify Email", _handleVerifyOtp),
        context.verticalSpace(16),
        TextButton(
          onPressed: _handleForgotPassword,
          child: Text(
            "Didn't receive code? Resend",
            style: context.fonts.purple14w600,
          ),
        ),
      ],
    );
  }

  Widget _createNewPasswordForm(BuildContext context) {
    return Column(
      key: const ValueKey('reset'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: _goBackToForgetPassword,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(backgroundColor: CustomColors.softGrey),
        ),
        context.verticalSpace(24),
        Text("Create New Password", style: context.fonts.black20w600),
        context.verticalSpace(8),
        Text(
          "Your new password must be different from your previous password",
          style: context.fonts.grey13w500,
        ),
        context.verticalSpace(32),
        ValueListenableBuilder(
          valueListenable: _obscureNewPassword,
          builder: (context, val, child) => BuildTextField(
            label: "New Password",
            hintText: "Enter new password",
            controller: _newPasswordController,
            obscureText: val,
            validator: Validators.password,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
            suffixIcon: IconButton(
              onPressed: () => _obscureNewPassword.value = !val,
              icon: Icon(
                val ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: context.sp(20),
                color: CustomColors.lightGrey,
              ),
            ),
          ),
        ),
        context.verticalSpace(24),
        ValueListenableBuilder(
          valueListenable: _obscureConfirmPassword,
          builder: (context, val, child) => BuildTextField(
            label: "Confirm Password",
            hintText: "Confirm new password",
            controller: _confirmNewPasswordController,
            obscureText: val,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            prefixIcon: Icon(
              Icons.lock_reset_rounded,
              size: context.sp(20),
              color: CustomColors.lightGrey,
            ),
            suffixIcon: IconButton(
              onPressed: () => _obscureConfirmPassword.value = !val,
              icon: Icon(
                val ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                size: context.sp(20),
                color: CustomColors.lightGrey,
              ),
            ),
          ),
        ),
        context.verticalSpace(32),
        _buildSubmitButton("Save Password", _handleCreateNewPassword),
      ],
    );
  }

  Widget _buildSubmitButton(String label, VoidCallback onPressed) {
    return CustomPrimaryButton(
      label: label,
      onTap: onPressed,
      width: double.infinity,
      isLoading: ref.watch(authViewModelProvider).loading,
    );
  }

  // Handlers (existing clinic portal functionality preserved)
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .login(
         
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          
        );
    if (success && mounted) {
      context.goNamed(HomeScreen.routeName);
    }
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .forgetPassword(email: _emailController.text.trim());
    if (success && mounted) {
      _goToVerifyOtp();
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .verifyOtp(
          email: _emailController.text.trim(),
          otp: _otpController.text.trim(),
        );
    if (success && mounted) {
      _goToCreateNewPassword();
    } else if (!success && mounted) {
      setState(() => _otpError = 'Invalid OTP. Please try again.');
    }
  }

  Future<void> _handleCreateNewPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref
        .read(authViewModelProvider.notifier)
        .createNewPassword(
          email: _emailController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );
    if (success && mounted) {
      _goToLogin();
    }
  }
}
