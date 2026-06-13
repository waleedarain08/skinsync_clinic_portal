import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../utils/responsive.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/header__with_back_btn.dart';

class CreateTreatmentScreen extends StatefulWidget {
  const CreateTreatmentScreen({super.key});
  static const String routeName = '/create-treatment';

  @override
  State<CreateTreatmentScreen> createState() => _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends State<CreateTreatmentScreen> {
  final TextEditingController _treatmentNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  // Dropdown values
  String? _selectedCategory;
  String? _selectedSubcategory;

  // Dropdown lists
  final List<String> _categories = [
    'Facial Treatments',
    'Body Treatments',
    'Skin Care',
    'Hair Treatments',
    'Massage Therapy',
    'Wellness',
  ];

  final List<String> _subcategories = [
    'Anti-Aging',
    'Hydration',
    'Acne Treatment',
    'Brightening',
    'Relaxation',
    'Deep Tissue',
  ];

  @override
  void dispose() {
    _treatmentNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Header with back button
              const BuildHeader(title: 'Create Treatment'),
              SizedBox(height: context.h(24)),
              // Main Form Container
              _buildFormContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(24)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment Details', style: context.fonts.black20w600),
          SizedBox(height: context.h(24)),
          // Treatment Name
          BuildTextField(
            label: 'Treatment Name',
            controller: _treatmentNameController,
            hintText: 'e.g., Botox, Dermal Fillers',
          ),
          SizedBox(height: context.h(20)),
          // Category Dropdown
          _buildDropdownField(
            label: 'Category',
            hintText: 'Select category',
            value: _selectedCategory,
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          SizedBox(height: context.h(20)),
          // Subcategory Dropdown
          _buildDropdownField(
            label: 'Subcategory',
            hintText: 'Select category',
            value: _selectedSubcategory,
            items: _subcategories,
            onChanged: (value) {
              setState(() {
                _selectedSubcategory = value;
              });
            },
          ),
          SizedBox(height: context.h(20)),
          // Description
          BuildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Describe the treatment and its benefits',
            maxLines: 5,
          ),
          SizedBox(height: context.h(20)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Price',
                  controller: _priceController,
                  hintText: 'AED 500',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: BuildTextField(
                  label: 'Discount',
                  controller: _discountController,
                  hintText: '30% Off',
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(32)),

          // Buttons Row
          _buildButtonsRow(),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.fonts.black13w500.copyWith(color: Colors.black87),
        ),
        SizedBox(height: context.h(8)),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: context.fonts.grey14w400.copyWith(color: CustomColors.grey),
            ),
            value: value,
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: context.fonts.black14w400.copyWith(color: Colors.black87),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: context.h(48),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(context.r(8)),
                border: Border.all(color: CustomColors.border, width: 1),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: CustomColors.grey,
                size: context.r(24),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: context.h(200),
              decoration: BoxDecoration(
                color: CustomColors.white,
                borderRadius: BorderRadius.circular(context.r(8)),
                boxShadow: [
                  BoxShadow(
                    color: CustomColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              offset: Offset(0, -context.h(4)),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(context.r(40)),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: context.h(44),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        // Create Treatment Button
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Treatment created successfully!'),
                  backgroundColor: CustomColors.green,
                ),
              );
            },
            label: 'Create Treatment',
          ),
        ),
        SizedBox(width: context.w(16)),
        // Cancel Button
        Expanded(
          child: CustomOutlinedButton(
            onTap: () {
              Navigator.pop(context);
            },
            label: 'Cancel',
          ),
        ),
      ],
    );
  }
}
