import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/custom_fonts.dart';
import '../utils/responsive.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/header__with_back_btn.dart';

class ChangePasswordScreen extends ConsumerWidget {
  const ChangePasswordScreen({super.key});
  static const String routeName = '/change-password';

  void _onUpdatePassword(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(authViewModelProvider.notifier);
    if (!viewModel.formKey.currentState!.validate()) return;
    final success = await viewModel.changePassword();
    if (!context.mounted) return;

    if (success) {
      viewModel.resetPasswordChanged();
      EasyLoading.showSuccess('Password updated successfully');
      Navigator.pop(context);
    } else {
      final error = ref.read(authViewModelProvider).error;
      EasyLoading.showSuccess('Error :$error');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final viewModel = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: context.isLandscape ? 250.w : 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(title: 'Password & Security'),
              SizedBox(height: 24.h),
              _buildCardContainer(context, ref, authState, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
    AuthViewModel viewModel,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChangePasswordHeader(),
            SizedBox(height: 24.h),
            _buildPasswordField(
              label: 'Current Password',
              controller: viewModel.currentPasswordController,
              obscureText: authState.obscureCurrent,
              onToggle: viewModel.toggleObscureCurrent,
              validator: Validators.password,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(
              label: 'New Password',
              controller: viewModel.newPasswordController,
              obscureText: authState.obscureNew,
              onToggle: viewModel.toggleObscureNew,
              validator: Validators.password,
            ),
            SizedBox(height: 20.h),
            _buildPasswordField(
              label: 'Confirm New Password',
              controller: viewModel.confirmPasswordController,
              obscureText: authState.obscureConfirm,
              onToggle: viewModel.toggleObscureConfirm,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != viewModel.newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 32.h),
            _buildButtonsRow(context, ref, authState.loading),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordHeader() {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: Color(0xFFEEEBFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.lock_outline_rounded,
              size: 22.sp,
              color: const Color(0xFF6B5DD3),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password', style: CustomFonts.black16w600),
              SizedBox(height: 4.h),
              Text(
                'Keep your account secure with a strong password',
                style: CustomFonts.grey16w400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black18w600),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow(BuildContext context, WidgetRef ref, bool isLoading) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _onUpdatePassword(context, ref),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Update Password', style: CustomFonts.white14w600),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              side: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            child: Text('Cancel', style: CustomFonts.black14w500),
          ),
        ),
      ],
    );
  }
}
