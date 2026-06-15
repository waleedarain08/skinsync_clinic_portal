import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/theme.dart';

import '../utils/responsive.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/header__with_back_btn.dart';
import 'business_info_screen.dart';

class CreateStaffScreen extends StatefulWidget {
  static const String routeName = '/create-staff';
  const CreateStaffScreen({super.key});

  @override
  State<CreateStaffScreen> createState() => _CreateStaffScreenState();
}

class _CreateStaffScreenState extends State<CreateStaffScreen> {
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

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: CustomColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.r(16))),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.w(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image',
                style: context.fonts.black18w600,
              ),
              SizedBox(height: context.h(20)),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    color: CustomColors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: CustomColors.blue,
                    size: context.r(24),
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: context.fonts.black14w500,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              SizedBox(height: context.h(8)),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    color: CustomColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: CustomColors.green,
                    size: context.r(24),
                  ),
                ),
                title: Text(
                  'Take a Photo',
                  style: context.fonts.black14w500,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              if (_selectedImage != null) ...[
                SizedBox(height: context.h(8)),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(context.w(10)),
                    decoration: BoxDecoration(
                      color: CustomColors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(context.r(8)),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: CustomColors.red,
                      size: context.r(24),
                    ),
                  ),
                  title: Text(
                    'Remove Photo',
                    style: context.fonts.black14w500.copyWith(color: CustomColors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
              SizedBox(height: context.h(16)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
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
              const BuildHeader(title: 'Create Staff'),
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
          // Profile Picture Section
          _buildProfilePictureSection(),
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
          SizedBox(height: context.h(32)),
          // Buttons Row
          _buildButtonsRow(),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Row(
      children: [
        // Profile Picture Circle with Dotted Border
        GestureDetector(
          onTap: _pickImage,
          child: CustomPaint(
            painter: DottedCircleBorderPainter(
              color: Colors.black87,
              strokeWidth: 1.5,
              dashLength: 6,
              gapLength: 4,
            ),
            child: Container(
              width: context.w(68),
              height: context.w(68),
              padding: EdgeInsets.all(context.w(2)),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.white,
                ),
                child: _selectedImage != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                width: context.w(64),
                                height: context.w(64),
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedImage!.path),
                                width: context.w(64),
                                height: context.w(64),
                                fit: BoxFit.cover,
                              ),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: context.r(24),
                          color: Colors.black87,
                        ),
                      ),
              ),
            ),
          ),
        ),
        SizedBox(width: context.w(16)),
        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Picture',
              style: context.fonts.black14w600,
            ),
            SizedBox(height: context.h(4)),
            Text(
              'Upload your profile picture',
              style: context.fonts.grey12w400,
            ),
          ],
        ),
      ],
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
        Text(label, style: context.fonts.black18w600),
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
                      style: context.fonts.black14w400,
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
        // Create Staff Button
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              // Handle create staff
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Staff created successfully!'),
                  backgroundColor: CustomColors.green,
                ),
              );
            },
            label: 'Create Staff',
          ),
        ),
        SizedBox(width: context.w(16)),
        // Cancel Button
        Expanded(
          child: CustomOutlinedButton(
            onTap: () {
              // Handle cancel
              Navigator.pop(context);
            },
            label: 'Cancel',
          ),
        ),
      ],
    );
  }
}
