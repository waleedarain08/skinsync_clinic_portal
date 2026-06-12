import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/header__with_back_btn.dart';

import '../utils/responsive.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  String? selectedCategory;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final List<String> categories = [
    'Bug/Error',
    'Feature Request',
    'Performance Issue',
    'UI/UX Issue',
    'Other',
  ];

  @override
  void dispose() {
    subjectController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const BuildHeader(title: "Report a Problem"),
              SizedBox(height: context.h(16)),
              const Divider(height: 1, thickness: 1, color: CustomColors.border),
              SizedBox(height: context.h(16)),

              // Main Content Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.r(20)),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(12)),
                    border: Border.all(color: CustomColors.border, width: 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Report Header with Icon
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.w(8)),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFF4ED),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline,
                                color: const Color(0xFFFF6B35),
                                size: context.r(20),
                              ),
                            ),
                            SizedBox(width: context.w(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Report a Problem',
                                    style: context.fonts.black16w600,
                                  ),
                                  SizedBox(height: context.h(4)),
                                  Text(
                                    'Report any issues or bugs you encounter',
                                    style: context.fonts.grey16w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: context.h(24)),

                        // Problem Category
                        _buildLabel('Problem Category'),
                        SizedBox(height: context.h(8)),
                        _buildDropdown(),

                        SizedBox(height: context.h(20)),

                        // Subject
                        _buildLabel('Subject'),
                        SizedBox(height: context.h(8)),
                        _buildTextField(
                          controller: subjectController,
                          hintText: 'Brief description of the issue',
                        ),

                        SizedBox(height: context.h(20)),

                        // Description
                        _buildLabel('Description'),
                        SizedBox(height: context.h(8)),
                        _buildTextField(
                          controller: descriptionController,
                          hintText:
                              'Please provide detailed information about the problem...',
                          maxLines: 5,
                        ),

                        SizedBox(height: context.h(20)),

                        // Contact Email
                        _buildLabel('Contact Email'),
                        SizedBox(height: context.h(8)),
                        _buildTextField(
                          controller: emailController,
                          hintText: 'your@email.com',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          "We'll use this to follow up on your report.",
                          style: context.fonts.black12w400.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),

                        SizedBox(height: context.h(32)),
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: CustomPrimaryButton(
                                onTap: _submitReport,
                                label: 'Submit Report',
                              ),
                            ),
                            SizedBox(width: context.w(12)),
                            Expanded(
                              child: CustomOutlinedButton(
                                onTap: () => Navigator.pop(context),
                                label: 'Cancel',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: context.fonts.black18w600);
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: selectedCategory,
        isExpanded: true,
        hint: Text(
          'Select category',
          style: context.fonts.black14w400.copyWith(color: CustomColors.grey),
        ),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: context.fonts.black14w400,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: context.h(70),
          padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(12)),
          decoration: BoxDecoration(
            color: CustomColors.white,
            borderRadius: BorderRadius.circular(context.r(8)),
            border: Border.all(color: CustomColors.border, width: 1),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(Icons.keyboard_arrow_down, color: CustomColors.grey),
          iconSize: context.r(24),
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
          padding: EdgeInsets.symmetric(horizontal: context.w(12)),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: context.fonts.black14w400,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.fonts.black14w400.copyWith(color: CustomColors.grey),
      ),
    );
  }

  void _submitReport() {
    // Validate fields
    if (selectedCategory == null) {
      _showSnackBar('Please select a problem category');
      return;
    }
    if (subjectController.text.trim().isEmpty) {
      _showSnackBar('Please enter a subject');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showSnackBar('Please enter a description');
      return;
    }
    if (emailController.text.trim().isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }

    _showSnackBar('Report submitted successfully!');
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(8))),
      ),
    );
  }
}
