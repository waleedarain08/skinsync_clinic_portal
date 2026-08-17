import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/responses/clinic_model.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/auth_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/phone_widget.dart';

class BusinessInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/business-info';
  final bool onBoardClinic;

  const BusinessInformationScreen({super.key, this.onBoardClinic = false});

  @override
  ConsumerState<BusinessInformationScreen> createState() =>
      _BusinessInformationScreenState();
}

class _BusinessInformationScreenState
    extends ConsumerState<BusinessInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _clinicEmailController = TextEditingController();
  final TextEditingController _clinicPhoneController = TextEditingController();
  final TextEditingController _clinicAddressController =
      TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerEmailController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _consultationFeeController =
      TextEditingController();
  final TextEditingController _initialDepositController =
      TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedLogo;
  XFile? _selectedBanner;

  final List<AvailabilityEntry> _availabilityEntries = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final clinic = ref.read(authViewModelProvider).user?.clinic;
    if (clinic != null) {
      _clinicNameController.text = clinic.name ?? '';
      _clinicEmailController.text = clinic.email ?? '';
      _clinicPhoneController.text = clinic.phone ?? '';
      _clinicAddressController.text = clinic.address ?? '';
      _latController.text = clinic.latitude?.toString() ?? '';
      _longController.text = clinic.longitude?.toString() ?? '';
      _websiteController.text = clinic.website ?? '';
      _descriptionController.text = clinic.description ?? '';
      _consultationFeeController.text =
          clinic.consultationFee?.toString() ?? '';
      _initialDepositController.text = clinic.initialDeposit?.toString() ?? '';

      if (clinic.availability != null && clinic.availability!.isNotEmpty) {
        _availabilityEntries.clear();
        for (var availability in clinic.availability!) {
          final entry = AvailabilityEntry();
          if (availability.openTime != null) {
            final parts = availability.openTime!.split(':');
            entry.openTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
          if (availability.closeTime != null) {
            final parts = availability.closeTime!.split(':');
            entry.closeTime = TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
          entry.selectedDays = Set<String>.from(availability.days ?? []);
          _availabilityEntries.add(entry);
        }
      } else {
        _availabilityEntries.add(AvailabilityEntry());
      }
      setState(() {});
    } else {
      _availabilityEntries.add(AvailabilityEntry());
    }
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    _clinicEmailController.dispose();
    _clinicPhoneController.dispose();
    _clinicAddressController.dispose();
    _ownerNameController.dispose();
    _ownerEmailController.dispose();
    _latController.dispose();
    _longController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _consultationFeeController.dispose();
    _initialDepositController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) setState(() => _selectedLogo = image);
  }

  Future<void> _pickBanner() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) setState(() => _selectedBanner = image);
  }

  void _addAvailability() {
    setState(() {
      _availabilityEntries.add(AvailabilityEntry());
    });
  }

  void _removeAvailability(int index) {
    if (_availabilityEntries.length > 1) {
      setState(() {
        _availabilityEntries.removeAt(index);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final currentClinic = ref.read(authViewModelProvider).user?.clinic;

      final List<AvailabilityModel> availability = _availabilityEntries.map((
        e,
      ) {
        String formatTime(TimeOfDay? tod) {
          if (tod == null) return '00:00';
          return '${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}';
        }

        return AvailabilityModel(
          openTime: formatTime(e.openTime),
          closeTime: formatTime(e.closeTime),
          days: e.selectedDays.toList(),
        );
      }).toList();

      final updatedClinic = (currentClinic ?? Clinic()).copyWith(
        name: _clinicNameController.text.trim(),
        phone: _clinicPhoneController.text.trim(),
        address: _clinicAddressController.text.trim(),
        logo: _selectedLogo?.path,
        latitude: double.tryParse(_latController.text),
        longitude: double.tryParse(_longController.text),
        consultationFee: num.tryParse(_consultationFeeController.text),
        initialDeposit: num.tryParse(_initialDepositController.text),
        description: _descriptionController.text.trim(),
        website: _websiteController.text.trim(),
        banner: _selectedBanner?.path,
        cc:
            ref.read(authViewModelProvider).country?.dialCode ??
            currentClinic?.cc,
        country:
            ref.read(authViewModelProvider).country?.code ??
            currentClinic?.country,
        availability: availability,
      );

      final success = await ref
          .read(authViewModelProvider.notifier)
          .updateClinicProfile(updateReq: updatedClinic);
      if (success && mounted) {
        // Handle logic after success if needed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Business Information', style: context.fonts.black20w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1000.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerAndLogoSection(),
                  SizedBox(height: 32.h),
                  _buildSectionCard(
                    title: 'Clinic Details',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Clinic Name',
                              controller: _clinicNameController,
                              hintText: 'e.g. Skin Sync Aesthetics',
                              validator: Validators.empty,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Clinic Email',
                              controller: _clinicEmailController,
                              hintText: 'clinic@example.com',
                              validator: Validators.email,
                              readOnly: true, // Usually email is not editable
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text('Phone Number', style: context.fonts.black14w600),
                      SizedBox(height: 10.h),
                      PhoneWidget(
                        controller: _clinicPhoneController,
                        filled: false,
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Clinic Address',
                        controller: _clinicAddressController,
                        hintText: '123 Medical Plaza, Suite 100',
                        validator: Validators.empty,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Consultation Fees',
                              controller: _consultationFeeController,
                              hintText: '100',
                              validator: Validators.empty,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Initial Deposit',
                              controller: _initialDepositController,
                              hintText: '10',
                              validator: Validators.empty,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Website',
                        controller: _websiteController,
                        hintText: 'https://skinsyncclinic.com',
                      ),
                      SizedBox(height: 24.h),
                      BuildTextField(
                        label: 'Description',
                        controller: _descriptionController,
                        hintText:
                            'Premier aesthetic clinic specializing in non-surgical facial treatments',
                        maxLines: 3,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Latitude',
                              controller: _latController,
                              hintText: 'e.g. 34.0522',
                              validator: Validators.empty,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                                color: CustomColors.grey,
                              ),
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Longitude',
                              controller: _longController,
                              hintText: 'e.g. -118.2437',
                              validator: Validators.empty,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              prefixIcon: const Icon(
                                Icons.location_on_outlined,
                                color: CustomColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildSectionCard(
                    title: 'Owner Information',
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: BuildTextField(
                              label: 'Owner Name',
                              controller: _ownerNameController,
                              hintText: 'e.g. Dr. Jane Smith',
                              validator: Validators.empty,
                            ),
                          ),
                          SizedBox(width: 24.w),
                          Expanded(
                            child: BuildTextField(
                              label: 'Owner Email',
                              controller: _ownerEmailController,
                              hintText: 'owner@example.com',
                              validator: Validators.email,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  _buildAvailabilitySection(),
                  SizedBox(height: 48.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomOutlinedButton(
                        onTap: () => Navigator.pop(context),
                        label: 'Cancel',
                        width: 160.w,
                        height: 56.h,
                        textColor: CustomColors.grey,
                        color: CustomColors.border,
                      ),
                      SizedBox(width: 24.w),
                      Consumer(
                        builder: (context, ref, child) {
                          final isLoading = ref.watch(
                            authViewModelProvider.select((s) => s.loading),
                          );
                          return SizedBox(
                            width: 240.w,
                            height: 56.h,
                            child: isLoading
                                ? const AppLoader(size: 40)
                                : CustomPrimaryButton(
                                    onTap: _submit,
                                    label: 'Save Changes',
                                    height: 56.h,
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerAndLogoSection() {
    final clinic = ref.watch(authViewModelProvider).user?.clinic;
    return Container(
      width: double.infinity,
      height: 250.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        image: _selectedBanner != null
            ? DecorationImage(
                image: kIsWeb
                    ? NetworkImage(_selectedBanner!.path)
                    : FileImage(File(_selectedBanner!.path)) as ImageProvider,
                fit: BoxFit.cover,
              )
            : (clinic?.banner != null && clinic!.banner!.isNotEmpty)
            ? DecorationImage(
                image: NetworkImage(clinic.banner!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 16.w,
            top: 16.h,
            child: InkWell(
              onTap: _pickBanner,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: CustomColors.purple,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: _pickLogo,
              borderRadius: BorderRadius.circular(60.r),
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal, width: 2),
                ),
                child: _selectedLogo != null
                    ? ClipOval(
                        child: kIsWeb
                            ? Image.network(
                                _selectedLogo!.path,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_selectedLogo!.path),
                                fit: BoxFit.cover,
                              ),
                      )
                    : (clinic?.logo != null && clinic!.logo!.isNotEmpty)
                    ? ClipOval(
                        child: Image.network(clinic.logo!, fit: BoxFit.cover),
                      )
                    : Icon(
                        Icons.camera_alt_outlined,
                        size: 40.sp,
                        color: CustomColors.purple,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black20w600),
          SizedBox(height: 32.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Clinic Availability', style: context.fonts.black20w600),
              CustomPrimaryButton(
                onTap: _addAvailability,
                icon: Icons.add_circle_outline,
                label: 'Add Timing Slot',
                width: 220.w,
              ),
            ],
          ),
          SizedBox(height: 24.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _availabilityEntries.length,
            separatorBuilder: (_, __) => Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(color: CustomColors.grey.withValues(alpha: 0.1)),
            ),
            itemBuilder: (context, index) => _buildAvailabilityRow(index),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityRow(int index) {
    final entry = _availabilityEntries[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Timing Slot ${index + 1}', style: context.fonts.purple16w600),
            if (_availabilityEntries.length > 1)
              TextButton.icon(
                onPressed: () => _removeAvailability(index),
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: const Text('Remove'),
                style: TextButton.styleFrom(foregroundColor: CustomColors.red),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildTimePicker(
                label: 'Open Time',
                time: entry.openTime,
                onChanged: (time) => setState(() => entry.openTime = time),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              child: _buildTimePicker(
                label: 'Close Time',
                time: entry.closeTime,
                onChanged: (time) => setState(() => entry.closeTime = time),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Text('Active Days', style: context.fonts.black14w600),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children:
              [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday',
              ].map((day) {
                final isSelected = entry.selectedDays.contains(day);
                return FilterChip(
                  label: Text(day),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        entry.selectedDays.add(day);
                      } else {
                        entry.selectedDays.remove(day);
                      }
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: CustomColors.purple.withValues(alpha: 0.1),
                  checkmarkColor: CustomColors.purple,
                  labelStyle: isSelected
                      ? context.fonts.purple13w700
                      : context.fonts.grey13w500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    side: BorderSide(
                      color: isSelected
                          ? CustomColors.purple
                          : CustomColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required Function(TimeOfDay) onChanged,
  }) {
    final controller = TextEditingController(text: time?.format(context) ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.grey13w500),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: time ?? const TimeOfDay(hour: 9, minute: 0),
            );
            if (picked != null) {
              onChanged(picked);
              controller.text = picked.format(context);
            }
          },
          child: IgnorePointer(
            child: BuildTextField(
              label: '',
              controller: controller,
              hintText: 'Select Time',
              readOnly: true,
              suffixIcon: const Icon(
                Icons.access_time_rounded,
                size: 20,
                color: CustomColors.purple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AvailabilityEntry {
  TimeOfDay? openTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay? closeTime = const TimeOfDay(hour: 17, minute: 0);
  Set<String> selectedDays = {};
}

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
