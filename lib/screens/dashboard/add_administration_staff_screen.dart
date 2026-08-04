import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';
import '../../widgets/build_textfield.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/borderd_container_widget.dart';

class AddAdministrationStaffScreen extends ConsumerStatefulWidget {
  const AddAdministrationStaffScreen({super.key});
  static const String routeName = '/add-administration-staff';

  @override
  ConsumerState<AddAdministrationStaffScreen> createState() =>
      _AddAdministrationStaffScreenState();
}

class _AddAdministrationStaffScreenState
    extends ConsumerState<AddAdministrationStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['Receptionist', 'Manager', 'Accountant', 'Admin'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          'Add Administration Staff',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderPanel(),
          Expanded(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSection(),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPanel() {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        backgroundColor: CustomColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: CustomColors.purple,
                  ),
                ),
                context.horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Staff Onboarding',
                      style: context.fonts.black16w600,
                    ),
                    Text(
                      'Configure staff identity and administrative roles.',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                CustomOutlinedButton(
                  onTap: () => context.pop(),
                  label: 'Cancel',
                  width: context.w(100),
                  height: context.h(40),
                ),
                context.horizontalSpace(12),
                CustomPrimaryButton(
                  onTap: _submitForm,
                  label: 'Save Staff',
                  width: context.w(180),
                  height: context.h(40),
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Information', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          BuildTextField(
            controller: _nameController,
            label: 'Full Name',
            hintText: 'Enter full name',
            validator: Validators.empty,
          ),
          SizedBox(height: context.h(24)),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hintText: 'Enter email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: BuildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  validator: Validators.empty,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(24)),
          _buildRoleDropdown(),
        ],
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Administrative Role', style: context.fonts.black14w600),
        SizedBox(height: context.h(8)),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'Select Role',
              style: context.fonts.grey14w400.copyWith(
                color: CustomColors.lightGrey,
              ),
            ),
            value: _selectedRole,
            items: _roles
                .map(
                  (role) => DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  ),
                )
                .toList(),
            onChanged: (val) => setState(() => _selectedRole = val),
            buttonStyleData: ButtonStyleData(
              height: context.h(52),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: CustomColors.border),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    // In a real app, we would call the view model to save the staff member.
    // For now, we'll just show a success message and go back.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Administration staff added successfully!')),
    );
    context.pop();
  }
}
