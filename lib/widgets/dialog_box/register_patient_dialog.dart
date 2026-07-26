import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';
import '../../view_models/appointment_creation_view_model.dart';
import '../build_textfield.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class RegisterPatientDialog extends ConsumerStatefulWidget {
  const RegisterPatientDialog({super.key});

  @override
  ConsumerState<RegisterPatientDialog> createState() => _RegisterPatientDialogState();

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const RegisterPatientDialog(),
    );
  }
}

class _RegisterPatientDialogState extends ConsumerState<RegisterPatientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Register New Patient",
      width: 500.w,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildTextField(
              label: 'Full Name',
              controller: _nameController,
              hintText: 'Enter patient full name',
              validator: Validators.empty,
            ),
            context.verticalSpace(16),
            BuildTextField(
              label: 'Email Address',
              controller: _emailController,
              hintText: 'Enter patient email address',
              validator: Validators.email,
            ),
            context.verticalSpace(16),
            BuildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              hintText: 'Enter patient phone number',
              validator: Validators.phone,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'Cancel',
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () {
            if (_formKey.currentState?.validate() ?? false) {
              ref.read(appointmentCreationProvider.notifier).registerNewPatient(
                    name: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    phone: _phoneController.text.trim(),
                  );
              Navigator.of(context).pop();
            }
          },
          label: 'Save Patient',
          width: 150.w,
        ),
      ],
    );
  }
}
