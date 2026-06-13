import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../utils/responsive.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/header__with_back_btn.dart';
import '../widgets/phone_widget.dart';

class BusinessInformationScreen extends StatefulWidget {
  const BusinessInformationScreen({super.key});
  static const String routeName = '/business_information';

  @override
  State<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _streetAddressController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _operatingHoursController =
      TextEditingController();
  final TextEditingController _clinicDescriptionController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  @override
  void dispose() {
    _clinicNameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneNumberController.dispose();
    _emailAddressController.dispose();
    _operatingHoursController.dispose();
    _clinicDescriptionController.dispose();
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
                    style: context.fonts.black14w500.copyWith(
                      color: CustomColors.red,
                    ),
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
              const BuildHeader(title: 'Business Information'),
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
          // Clinic Name
          _buildFormTextField(
            label: 'Clinic Name',
            controller: _clinicNameController,
            hintText: 'Skin Sync Aesthetics',
          ),
          SizedBox(height: context.h(20)),
          // Street Address
          _buildFormTextField(
            label: 'Street Address',
            controller: _streetAddressController,
            hintText: '123 Medical Plaza, Suite 100',
          ),
          SizedBox(height: context.h(20)),
          // City, State, ZIP Code Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildFormTextField(
                  label: 'City',
                  controller: _cityController,
                  hintText: 'Los Angeles',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                flex: 2,
                child: _buildFormTextField(
                  label: 'State',
                  controller: _stateController,
                  hintText: 'CA',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                flex: 2,
                child: _buildFormTextField(
                  label: 'ZIP Code',
                  controller: _zipCodeController,
                  hintText: '90001',
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          // Phone Number, Email Address Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone Number", style: context.fonts.black18w600),
                    SizedBox(height: context.h(8)),
                    PhoneWidget(controller: _phoneNumberController),
                  ],
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: _buildFormTextField(
                  label: 'Email Address',
                  controller: _emailAddressController,
                  hintText: 'info@skinsyncclinic.com',
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(20)),
          // Operating Hours
          _buildFormTextField(
            label: 'Operating Hours',
            controller: _operatingHoursController,
            hintText: 'Mon-Fri: 9AM-6PM, Sat: 10AM-4PM',
          ),
          SizedBox(height: context.h(20)),
          // Clinic Description
          _buildFormTextField(
            label: 'Clinic Description',
            controller: _clinicDescriptionController,
            hintText:
                'Premier aesthetic clinic specializing in non-surgical facial treatments',
            maxLines: 4,
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

  Widget _buildFormTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black18w600),
        SizedBox(height: context.h(8)),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: context.fonts.black14w400,
          decoration: InputDecoration(
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        // Save Changes Button
        Expanded(
          child: CustomPrimaryButton(
            onTap: () {
              // Handle save changes
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Changes saved successfully!'),
                  backgroundColor: CustomColors.green,
                ),
              );
            },
            label: 'Save Changes',
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

// Custom Painter for Dotted Circle Border
class DottedCircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;

  DottedCircleBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.gapLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final circumference = 2 * pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashLength + gapLength)) / radius;
      final sweepAngle = dashLength / radius;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
