import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_duration_picker/material_duration_picker.dart';
import 'package:skinsync_clinic_portal/models/requests/register_doctor_request.dart';
import 'package:skinsync_clinic_portal/models/responses/register_doctor_response.dart';
import 'package:skinsync_clinic_portal/models/treatment_model.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/utils/validators.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/add_slot_dailogBox.dart';
import 'package:skinsync_clinic_portal/widgets/dailog%20box/select_treatment_dailog.dart';
import 'package:skinsync_clinic_portal/widgets/phone_widget.dart';

import '../utils/enums.dart';
import '../utils/string_utils.dart';
import '../view_models/doctor_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/build_textfield.dart';
import '../widgets/header__with_back_btn.dart';

class AddDoctorInjectorScreen extends ConsumerStatefulWidget {
  const AddDoctorInjectorScreen({super.key, this.doctor});
  static const String routeName = '/add-doctor-injector';
  final Doctor? doctor;

  @override
  ConsumerState<AddDoctorInjectorScreen> createState() =>
      _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends ConsumerState<AddDoctorInjectorScreen> {
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageNotifier = ValueNotifier<XFile?>(null);
  final _feeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments();

      final doctor = widget.doctor;

      if (doctor != null) {
        _nameController.text = doctor.name ?? '';
        _specializationController.text = doctor.specialization ?? '';
        _emailController.text = doctor.email ?? '';
        _phoneController.text = doctor.phone ?? '';

        ref.read(doctorProvider.notifier).changeRole(doctor.role);

        // ✅ Convert properly
        final convertedTreatments =
            doctor.treatments?.map((t) {
              return TreatmentModel(
                id: t.treatmentId,
                name: t.treatmentName,
                sideAreas: t.sideAreas?.map((s) {
                  return SideAreaModel(id: s.sideAreaId, name: s.sideAreaName);
                }).toList(),
              );
            }).toList() ??
            [];

        ref
            .read(doctorProvider.notifier)
            .setInitialTreatments(convertedTreatments);
        ref
            .read(doctorProvider.notifier)
            .setInitialAvailability(widget.doctor?.availability);
      }
    });
  }

  void _listener(DoctorState? prev, DoctorState next) {
    if (next.success) {
      log('SUCCESS -> Popping');
      ref.read(doctorProvider.notifier).getDoctors();
      Navigator.pop(context);
    }
  }

  Future<void> _onImageTap() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      log('PATH: ${image.path}');
      _imageNotifier.value = image;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(doctorProvider, _listener);
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, _) =>
          ref.read(doctorProvider.notifier).clearData(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 250.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildHeader(title: 'Add Doctor / Injector'),
                SizedBox(height: 24.h),
                _buildFormContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    final loading = ref.watch(
      treatmentViewModelProvider.select((state) => state.loading),
    );
    final isEditing = widget.doctor != null;
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
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Details', style: CustomFonts.black20w600),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SelectTreatmentDialog(),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Icons.add, color: Colors.white, size: 20.r),
                        label: Text(
                          'Add Treatment',
                          style: CustomFonts.white14w600,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final availability = await showDialog<Availability>(
                            context: context,
                            builder: (context) => const AddSlotDialog(),
                          );
                          ref
                              .read(doctorProvider.notifier)
                              .setAvailability(availability);
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          elevation: 0,
                        ),
                        icon: Icon(Icons.add, color: Colors.white, size: 20.r),
                        label: Text('Add Slot', style: CustomFonts.white14w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Badge(
                    offset: Offset(-10.w, 10.h),
                    backgroundColor: Colors.transparent,
                    label: IconButton(
                      onPressed: _onImageTap,
                      icon: Icon(Icons.edit, size: 20.sp),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _imageNotifier,
                      builder: (_, image, _) {
                        return ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(50.r),
                          child: CachedNetworkImage(
                            imageUrl: image?.path ?? widget.doctor?.image ?? '',
                            errorWidget: (_, _, _) => CircleAvatar(
                              radius: 50.r,
                              child: Icon(
                                Icons.person_outline,
                                size: 30.sp,
                                color: CustomColors.white,
                              ),
                            ),
                            fit: BoxFit.cover,
                            width: 100.r,
                            height: 100.r,
                          ),
                        );
                      },
                    ),
                  ),

                  Consumer(
                    builder: (_, ref, _) {
                      final role = ref.watch(
                        doctorProvider.select((state) => state.role),
                      );
                      final list = List.of(DoctorRole.values);
                      list.remove(DoctorRole.owner);
                      return IgnorePointer(
                        ignoring: isEditing,
                        child: _buildDropdownField(
                          items: list,
                          value: role,
                          onChanged: (role) => ref
                              .read(doctorProvider.notifier)
                              .changeRole(role),
                          label: 'Select Role',
                          hintText: 'Select Role',
                          builder: (role) => Text(role.name.capitalize),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  BuildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hintText: 'Name',
                    validator: Validators.empty,
                  ),
                  SizedBox(height: 16.h),
                  BuildTextField(
                    controller: _specializationController,
                    label: 'Specialization',
                    hintText: 'Specialization',
                    validator: Validators.empty,
                  ),
                  SizedBox(height: 16.h),
                  BuildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Email',
                    validator: Validators.email,
                    readOnly: isEditing,
                  ),
                  SizedBox(height: 16.h),
                  Text("Phone Number", style: CustomFonts.black14w500),
                  SizedBox(height: 8.h),
                  PhoneWidget(
                    controller: _phoneController,
                    initialCountryCode:
                        widget.doctor?.country ??
                        ref.watch(doctorProvider).countryCode,
                    onCountryChanged: (country) {
                      ref.read(doctorProvider.notifier).setCountry(country);
                    },
                  ),
                  SizedBox(height: 16.h),

                  BuildTextField(
                    label: "Consultation Fee",
                    hintText: "Consultation Fee",
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    validator: Validators.empty,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  SizedBox(height: 16.h),
                  _buildTreatmentChips(),
                  SizedBox(height: 16.h),
                  _buildAvailability(),
                  SizedBox(height: 32.h),
                  _buildButtonsRow(),
                ],
              ),
            ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hintText,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    Widget Function(T)? builder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: CustomFonts.black14w500),
        SizedBox(height: 8.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint: Text(hintText, style: TextStyle(color: Colors.grey[400])),
            value: value,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: builder?.call(item) ?? Text(item.toString()),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentChips() {
    return Consumer(
      builder: (_, ref, _) {
        final treatments = ref.watch(
          doctorProvider.select((state) => state.treatments),
        );
        return Align(
          alignment: .centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [
              if (treatments.isNotEmpty)
                Text('Selected Treatments', style: CustomFonts.black14w600),
              for (final treatment in treatments)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChoiceChip(
                      label: Text(treatment.name ?? 'N/A'),
                      selected: true,
                      selectedColor: Colors.black,
                      showCheckmark: false,
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: CustomColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      onSelected: (selected) {},
                    ),
                    if (treatment.sideAreas!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: treatment.sideAreas!.map((sideArea) {
                            return ChoiceChip(
                              label: Text(sideArea.name ?? 'N/A'),
                              selected: false,
                              selectedColor: Colors.blue,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (_) {},
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvailability() {
    return Consumer(
      builder: (_, ref, _) {
        final availability = ref.watch(
          doctorProvider.select((state) => state.availability),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.h,
          children: [
            if (availability.isNotEmpty)
              Text('Availability', style: CustomFonts.black14w600),
            for (final availability in availability)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10.w,
                    children: [
                      ChoiceChip(
                        label: Text(
                          '${availability.startTime.format(context)} - ${availability.endTime.format(context)}',
                        ),
                        selected: true,
                        selectedColor: Colors.black,
                        showCheckmark: false,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: CustomColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        onSelected: (selected) {},
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(doctorProvider.notifier)
                              .deleteAvailability(availability);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: availability.days.map((day) {
                        return ChoiceChip(
                          label: Text(day),
                          selected: false,
                          selectedColor: Colors.blue,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          onSelected: (_) {},
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (widget.doctor != null) {
                ref
                    .read(doctorProvider.notifier)
                    .updateDoctorTreatment(
                      email: widget.doctor!.email!,
                      clinicUserId: widget.doctor!.id!,
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      specialization: _specializationController.text.trim(),
                      image: _imageNotifier.value,
                    );
              } else {
                ref
                    .read(doctorProvider.notifier)
                    .registerDoctor(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      specialization: _specializationController.text.trim(),
                      image: _imageNotifier.value,
                      consultationFee: int.parse(_feeController.text),
                    );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              // padding: EdgeInsets.symmetric(vertical: 20.h),
            ),
            child: Text(
              widget.doctor == null ? 'Create' : 'Update',
              style: CustomFonts.white14w600,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: CustomFonts.black14w500),
          ),
        ),
      ],
    );
  }
}
