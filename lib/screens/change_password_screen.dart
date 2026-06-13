import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import '../utils/responsive.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
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

    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BuildHeader(title: 'Password & Security'),
              SizedBox(height: context.h(24)),
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
      padding: EdgeInsets.all(context.w(24)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: context.r(10),
            offset: Offset(0, context.h(2)),
          ),
        ],
      ),
      child: Form(
        key: viewModel.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChangePasswordHeader(context),
            SizedBox(height: context.h(24)),
            _buildPasswordField(
              context: context,
              label: 'Current Password',
              controller: viewModel.currentPasswordController,
              obscureText: authState.obscureCurrent,
              onToggle: viewModel.toggleObscureCurrent,
              validator: Validators.password,
            ),
            SizedBox(height: context.h(20)),
            _buildPasswordField(
              context: context,
              label: 'New Password',
              controller: viewModel.newPasswordController,
              obscureText: authState.obscureNew,
              onToggle: viewModel.toggleObscureNew,
              validator: Validators.password,
            ),
            SizedBox(height: context.h(20)),
            _buildPasswordField(
              context: context,
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
            SizedBox(height: context.h(32)),
            _buildButtonsRow(context, ref, authState.loading),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.w(44),
          height: context.w(44),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.lock_outline_rounded,
              size: context.sp(22),
              color: CustomColors.purple,
            ),
          ),
        ),
        SizedBox(width: context.w(14)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password', style: context.fonts.black16w600),
              SizedBox(height: context.h(4)),
              Text(
                'Keep your account secure with a strong password',
                style: context.fonts.grey16w400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black18w600),
        SizedBox(height: context.h(8)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          style: context.fonts.black14w400.copyWith(color: CustomColors.black.withValues(alpha: 0.87)),
          decoration: InputDecoration(
            filled: true,
            fillColor: CustomColors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(14),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: BorderSide(color: CustomColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: BorderSide(color: CustomColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: BorderSide(color: CustomColors.purple, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: BorderSide(color: CustomColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.r(8)),
              borderSide: BorderSide(color: CustomColors.red, width: 1),
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: CustomColors.grey,
                size: context.sp(20),
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
          child: CustomPrimaryButton(
            onTap: () => _onUpdatePassword(context, ref),
            label: 'Update Password',
            isLoading: isLoading,
          ),
        ),
        SizedBox(width: context.w(16)),
        Expanded(
          child: CustomOutlinedButton(
            onTap: () => Navigator.pop(context),
            label: 'Cancel',
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}
