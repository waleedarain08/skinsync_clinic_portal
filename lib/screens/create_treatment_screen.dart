import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';

import '../utils/responsive.dart';
import '../widgets/build_textfield.dart';
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

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFBDBDBD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: context.isLandscape ? 250.w : 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              BuildHeader(title: 'Create Treatment'),
              SizedBox(height: 24.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture Section
          Text('Treatment Details', style: CustomFonts.black20w600),
          SizedBox(height: 24.h),
          // Treatment Name
          BuildTextField(
            label: 'Treatment Name',
            controller: _treatmentNameController,
            hintText: 'e.g., Botox, Dermal Fillers',
          ),
          SizedBox(height: 20.h),
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
          SizedBox(height: 20.h),
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
          SizedBox(height: 20.h),
          // Description
          BuildTextField(
            label: 'Description',
            controller: _descriptionController,
            hintText: 'Describe the treatment and its benefits',
            maxLines: 5,
          ),
          SizedBox(height: 20.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BuildTextField(
                  label: 'Price',
                  controller: _treatmentNameController,
                  hintText: '\$500',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: BuildTextField(
                  label: 'Discount',
                  controller: _treatmentNameController,
                  hintText: '%30 Off',
                ),
              ),
            ],
          ),

          SizedBox(height: 32.h),

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
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            ),
            value: value,
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey[500],
                size: 24.sp,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              offset: Offset(0, -4.h),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(40.r),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        // Create Staff Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Handle create staff
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Staff created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text('Create Treatment', style: CustomFonts.white14w600),
          ),
        ),
        SizedBox(width: 16.w),
        // Cancel Button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Handle cancel
              // context.pop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 20.h),
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

// Custom Painter for Dotted Circle Border
