import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../utils/assets.dart';
import '../widgets/phone_widget.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-up-screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _hasLowercase = false;
  bool _hasUniqueChar = false;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    setState(() {
      _hasLowercase = _passwordController.text.contains(RegExp(r'[a-z]'));
      _hasUniqueChar = _passwordController.text.contains(
        RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
      );
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: Row(
        children: [
          // Left Side - Branding
          Expanded(
            child: Container(
              color: CustomColors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: context.w(200),
                      height: context.h(200),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF9BA7D4), Color(0xFF7DD3D3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Image.asset(
                        PngAssets.splashLogo,
                        height: context.w(100),
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

          // Vertical Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.h(100)),
            child: Container(width: 1, color: CustomColors.border),
          ),

          // Right Side - Sign Up Form
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: context.w(140),
                right: context.w(50),
                top: context.h(50),
              ),
              child: Container(
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(60),
                    vertical: context.h(40),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
                          style: context.fonts.black32w700,
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          "Create an account to continue",
                          style: context.fonts.grey14w400,
                        ),
                        SizedBox(height: context.h(40)),

                        // Full Name Field
                        _buildTextField(
                          label: "Full Name",
                          hintText: "Enter full name",
                          controller: _fullNameController,
                          isRequired: true,
                        ),
                        SizedBox(height: context.h(20)),
                        // Email Field
                        _buildTextField(
                          label: "Email Address",
                          hintText: "Enter Your Email Address",
                          controller: _emailController,
                          isRequired: true,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: context.h(20)),

                        // Phone Number Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: context.fonts.black14w400,
                            ),
                            SizedBox(height: context.h(8)),
                            PhoneWidget(controller: _phoneController),
                          ],
                        ),
                        SizedBox(height: context.h(20)),

                        // Password Field
                        _buildPasswordField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onToggle: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        SizedBox(height: context.h(20)),

                        // Confirm Password Field
                        _buildPasswordField(
                          label: "Confirm Password",
                          hintText: "Confirm your password",
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          onToggle: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                        SizedBox(height: context.h(16)),

                        // Password Requirements
                        _buildPasswordRequirement(
                          text: "At least one lowercase letter",
                          isValid: _hasLowercase,
                        ),
                        SizedBox(height: context.h(8)),
                        _buildPasswordRequirement(
                          text: "At least one unique character",
                          isValid: _hasUniqueChar,
                        ),

                        SizedBox(height: context.h(24)),
                        _rowWidget(),
                        SizedBox(height: context.h(30)),

                        // Create Account Button
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // Perform signup
                            }
                          },
                          child: Container(
                            width: context.w(215),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(20),
                              vertical: context.h(14),
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.black,
                              borderRadius: BorderRadius.all(
                                Radius.circular(context.r(30)),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create Account",
                                  style: context.fonts.white16w400,
                                ),
                                SizedBox(width: context.w(8)),
                                Icon(
                                  Icons.arrow_forward,
                                  color: CustomColors.white,
                                  size: context.sp(20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: context.h(20)),

                        // Sign In Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account already? ",
                              style: context.fonts.black14w400.copyWith(color: Colors.black87),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Sign In",
                                style: context.fonts.black14w600.copyWith(
                                  color: const Color(0xFF5B9FD8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: context.fonts.black14w600,
            children: [
              if (isRequired)
                TextSpan(
                  text: " *",
                  style: context.fonts.red14w600,
                ),
            ],
          ),
        ),
        SizedBox(height: context.h(8)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: context.fonts.black14w600,
            children: [
              TextSpan(
                text: " *",
                style: context.fonts.red14w600,
              ),
            ],
          ),
        ),
        SizedBox(height: context.h(8)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: CustomColors.grey,
                size: context.sp(20),
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.w(20),
          height: context.h(20),
          child: Checkbox(
            value: _acceptTerms,
            onChanged: (value) {
              setState(() {
                _acceptTerms = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.r(4)),
            ),
          ),
        ),
        SizedBox(width: context.w(10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: "I accept the ",
                style: context.fonts.black13w400.copyWith(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: context.fonts.black13w600,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(2)),
            Text(
              "Secured with Profile Verification API",
              style: context.fonts.grey11w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPasswordRequirement({
    required String text,
    required bool isValid,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          size: context.sp(18),
          color: isValid ? CustomColors.green : CustomColors.lightGrey,
        ),
        SizedBox(width: context.w(8)),
        Text(
          text,
          style: context.fonts.black13w400.copyWith(
            color: isValid ? CustomColors.green : CustomColors.grey,
          ),
        ),
      ],
    );
  }
}
