import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/requests/register_doctor_request.dart';
import '../models/responses/register_doctor_response.dart';
import '../models/treatment_model.dart';
import '../utils/enums.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/doctor_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dialog_box/add_slot_dialog_box.dart';
import '../widgets/dialog_box/select_treatment_dailog.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/header__with_back_btn.dart';
import '../widgets/phone_widget.dart';

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
      child: GradientScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: context.h(20),
              horizontal: context.isLandscape ? context.w(250) : context.w(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BuildHeader(title: 'Add Doctor / Injector'),
                SizedBox(height: context.h(24)),
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
      child: loading
          ? const Center(child: AppLoader())
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Details', style: context.fonts.black20w600),
                      const Spacer(),
                      CustomPrimaryButton(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const SelectTreatmentDialog(),
                          );
                        },
                        label: 'Add Treatment',
                        icon: Icons.add,
                        height: context.h(42),
                      ),
                      SizedBox(width: context.w(10)),
                      CustomPrimaryButton(
                        onTap: () async {
                          final availability = await showDialog<Availability>(
                            context: context,
                            builder: (context) => const AddSlotDialog(),
                          );
                          ref
                              .read(doctorProvider.notifier)
                              .setAvailability(availability);
                        },
                        label: 'Add Slot',
                        icon: Icons.add,
                        height: context.h(42),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(24)),
                  Badge(
                    offset: Offset(-context.w(10), context.h(10)),
                    backgroundColor: Colors.transparent,
                    label: IconButton(
                      onPressed: _onImageTap,
                      icon: Icon(Icons.edit, size: context.r(20)),
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _imageNotifier,
                      builder: (_, image, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(context.r(50)),
                          child: CachedNetworkImage(
                            imageUrl: image?.path ?? widget.doctor?.image ?? '',
                            errorWidget: (_, _, _) => CircleAvatar(
                              radius: context.r(50),
                              backgroundColor: CustomColors.softGrey,
                              child: Icon(
                                Icons.person_outline,
                                size: context.r(30),
                                color: CustomColors.grey,
                              ),
                            ),
                            fit: BoxFit.cover,
                            width: context.r(100),
                            height: context.r(100),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: context.h(24)),
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
                  SizedBox(height: context.h(16)),
                  BuildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hintText: 'Name',
                    validator: Validators.empty,
                  ),
                  SizedBox(height: context.h(16)),
                  BuildTextField(
                    controller: _specializationController,
                    label: 'Specialization',
                    hintText: 'Specialization',
                    validator: Validators.empty,
                  ),
                  SizedBox(height: context.h(16)),
                  BuildTextField(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Email',
                    validator: Validators.email,
                    readOnly: isEditing,
                  ),
                  SizedBox(height: context.h(16)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone Number",
                      style: context.fonts.black14w500,
                    ),
                  ),
                  SizedBox(height: context.h(8)),
                  PhoneWidget(
                    controller: _phoneController,
                    initialCountryCode:
                        widget.doctor?.country ??
                        ref.watch(doctorProvider).countryCode,
                    onCountryChanged: (country) {
                      ref.read(doctorProvider.notifier).setCountry(country);
                    },
                  ),
                  SizedBox(height: context.h(16)),
                  BuildTextField(
                    label: "Consultation Fee",
                    hintText: "Consultation Fee",
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    validator: Validators.empty,
                 
                  ),
                  SizedBox(height: context.h(16)),
                  _buildTreatmentChips(),
                  SizedBox(height: context.h(16)),
                  _buildAvailability(),
                  SizedBox(height: context.h(32)),
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
        Text(label, style: context.fonts.black14w500),
        SizedBox(height: context.h(8)),
        DropdownButtonHideUnderline(
          child: DropdownButton2<T>(
            isExpanded: true,
            hint: Text(
              hintText,
              style: context.fonts.grey14w400.copyWith(
                color: CustomColors.lightGrey,
              ),
            ),
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
              height: context.h(48),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(8)),
                border: Border.all(color: CustomColors.border),
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
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (treatments.isNotEmpty) ...[
                Text('Selected Treatments', style: context.fonts.black14w600),
                SizedBox(height: context.h(10)),
              ],
              for (final treatment in treatments)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChoiceChip(
                      label: Text(treatment.name ?? 'N/A'),
                      selected: true,
                      selectedColor: CustomColors.black,
                      showCheckmark: false,
                      checkmarkColor: CustomColors.white,
                      labelStyle: context.fonts.white14w600,
                      onSelected: (selected) {},
                    ),
                    if (treatment.sideAreas != null &&
                        treatment.sideAreas!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          top: context.h(10),
                          bottom: context.h(10),
                        ),
                        child: Wrap(
                          spacing: context.w(8),
                          runSpacing: context.h(8),
                          children: treatment.sideAreas!.map((sideArea) {
                            return ChoiceChip(
                              label: Text(sideArea.name ?? 'N/A'),
                              selected: false,
                              selectedColor: CustomColors.blue,
                              checkmarkColor: CustomColors.white,
                              labelStyle: context.fonts.black14w400,
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
          children: [
            if (availability.isNotEmpty) ...[
              Text('Availability', style: context.fonts.black14w600),
              SizedBox(height: context.h(10)),
            ],
            for (final av in availability)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ChoiceChip(
                        label: Text(
                          '${av.startTime.format(context)} - ${av.endTime.format(context)}',
                        ),
                        selected: true,
                        selectedColor: CustomColors.black,
                        showCheckmark: false,
                        checkmarkColor: CustomColors.white,
                        labelStyle: context.fonts.white14w600,
                        onSelected: (selected) {},
                      ),
                      SizedBox(width: context.w(10)),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(doctorProvider.notifier)
                              .deleteAvailability(av);
                        },
                        icon: const Icon(Icons.delete, color: CustomColors.red),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.h(10),
                      bottom: context.h(10),
                    ),
                    child: Wrap(
                      spacing: context.w(8),
                      runSpacing: context.h(8),
                      children: av.days.map((day) {
                        return ChoiceChip(
                          label: Text(day),
                          selected: false,
                          selectedColor: CustomColors.blue,
                          checkmarkColor: CustomColors.white,
                          labelStyle: context.fonts.black14w400,
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
          child: CustomPrimaryButton(
            onTap: () {
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
            label: widget.doctor == null ? 'Create' : 'Update',
            isLoading: ref.watch(doctorProvider).loading,
          ),
        ),
        SizedBox(width: context.w(16)),
        Expanded(
          child: CustomOutlinedButton(
            onTap: () => Navigator.pop(context),
            label: 'Cancel',
          ),
        ),
      ],
    );
  }
}
