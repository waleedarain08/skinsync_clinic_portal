import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skinsync_clinic_portal/widgets/header__with_back_btn.dart';

import '../utils/custom_fonts.dart';
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
      // backgroundColor: const Color(0xFFBDBDBD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 20.h,
            horizontal: context.isLandscape ? 250.w : 20.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              BuildHeader(title: "Report a Problem"),
              SizedBox(height: 16.h),
              Divider(height: 1.h, thickness: 1, color: Colors.grey.shade200),
              SizedBox(height: 16.h),

              // Main Content Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
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
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4ED),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              color: const Color(0xFFFF6B35),
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Report a Problem',
                                  style: CustomFonts.black16w600,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Report any issues or bugs you encounter',
                                  style: CustomFonts.grey16w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Problem Category
                      _buildLabel('Problem Category'),
                      SizedBox(height: 8.h),
                      _buildDropdown(),

                      SizedBox(height: 20.h),

                      // Subject
                      _buildLabel('Subject'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: subjectController,
                        hintText: 'Brief description of the issue',
                      ),

                      SizedBox(height: 20.h),

                      // Description
                      _buildLabel('Description'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: descriptionController,
                        hintText:
                            'Please provide detailed information about the problem...',
                        maxLines: 5,
                      ),

                      SizedBox(height: 20.h),

                      // Contact Email
                      _buildLabel('Contact Email'),
                      SizedBox(height: 8.h),
                      _buildTextField(
                        controller: emailController,
                        hintText: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "We'll use this to follow up on your report.",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      SizedBox(height: 32.h),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Submit Report',
                                style: CustomFonts.white16w400,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: CustomFonts.black18w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
    return Text(text, style: CustomFonts.black18w600);
  }

  Widget _buildDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: selectedCategory,
        isExpanded: true,
        hint: Text(
          'Select category',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade500,
          ),
        ),
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(
              category,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          iconSize: 24.sp,
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
          padding: EdgeInsets.symmetric(horizontal: 12.w),
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
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade500,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
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

    // TODO: Implement report submission logic
    _showSnackBar('Report submitted successfully!');
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
