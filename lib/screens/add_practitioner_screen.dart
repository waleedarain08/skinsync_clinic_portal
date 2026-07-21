import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/register_practitioner_request.dart';
import '../models/responses/register_practitioner_response.dart';
import '../models/treatment_model.dart';
import '../utils/list_utils.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/practitioner_view_model.dart';
import '../view_models/provider_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dialog_box/add_slot_dialog_box.dart';
import '../widgets/dialog_box/select_treatment_dailog.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/phone_widget.dart';

class AddPractitionerScreen extends ConsumerStatefulWidget {
  const AddPractitionerScreen({super.key, this.practitioner});
  static const String routeName = '/add-practitioner';
  final Practitioner? practitioner;

  @override
  ConsumerState<AddPractitionerScreen> createState() =>
      _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends ConsumerState<AddPractitionerScreen> {
  final _nameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageNotifier = ValueNotifier<String?>(null);
  final _feeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerRoleViewModelProvider.notifier).fetchProviderRoles();
      ref.read(treatmentViewModelProvider.notifier).getTreatments();

      final practitioner = widget.practitioner;

      if (practitioner != null) {
        _nameController.text = practitioner.name ?? '';
        _specializationController.text = practitioner.specialization ?? '';
        _emailController.text = practitioner.email ?? '';
        _phoneController.text = practitioner.phone ?? '';

        ref.read(practitionerProvider.notifier).changeRole(practitioner.role);
        ref
            .read(practitionerProvider.notifier)
            .setCountry(CountryCode.fromDialCode(practitioner.cc!));
        // ✅ Convert properly
        final convertedTreatments =
            practitioner.treatments?.map((t) {
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
            .read(practitionerProvider.notifier)
            .setInitialTreatments(convertedTreatments);
        ref
            .read(practitionerProvider.notifier)
            .setInitialAvailability(widget.practitioner?.availability);
      }
    });
  }

  void _listener(PractitionerState? prev, PractitionerState next) {
    if (next.success) {
      log('SUCCESS -> Popping');
      ref.read(practitionerProvider.notifier).getPractitioner();
      Navigator.pop(context);
    }
  }

  Future<void> _onImageTap() async {
    final image = await ref.read(practitionerProvider.notifier).pickImage();
    if (image != null) {
      log('PATH: ${image}');
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
    ref.listen(practitionerProvider, _listener);
    final isEditing = widget.practitioner != null;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (_, _) =>
          ref.read(practitionerProvider.notifier).clearData(),
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          title: Text(
            isEditing ? 'Update Practitioner' : 'Add Practitioner',
            style: context.fonts.black18w600,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: context.h(24),
              horizontal: context.isLandscape ? context.w(250) : context.w(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildFormContainer()],
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
    final isEditing = widget.practitioner != null;
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
                              .read(practitionerProvider.notifier)
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
                            imageUrl: image ?? widget.practitioner?.image ?? '',
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
                        practitionerProvider.select((state) => state.role),
                      );
                      final providerRoles =
                          ref.watch(
                            providerRoleViewModelProvider.select(
                              (state) => state.providerRoles,
                            ),
                          ) ??
                          [];

                      return IgnorePointer(
                        ignoring: isEditing,
                        child: _buildDropdownField(
                          items: providerRoles,
                          value: providerRoles.firstWhereOrNull(
                            (r) => r.name == role,
                          ),
                          onChanged: (selectedRole) => ref
                              .read(practitionerProvider.notifier)
                              .changeRole(selectedRole?.name ?? ""),
                          label: 'Select Role',
                          hintText: 'Select Role',
                          builder: (r) => Text(r.name?.capitalize ?? ""),
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
                        widget.practitioner?.cc ??
                        ref.watch(practitionerProvider).country.dialCode,
                    onCountryChanged: (country) {
                      ref.read(practitionerProvider.notifier).setCountry(country);
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
          practitionerProvider.select((state) => state.treatments),
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
          practitionerProvider.select((state) => state.availability),
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
                              .read(practitionerProvider.notifier)
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
              if (widget.practitioner != null) {
                ref
                    .read(practitionerProvider.notifier)
                    .updatePractitionerTreatment(
                      email: widget.practitioner!.email!,
                      clinicUserId: widget.practitioner!.id!,
                      name: _nameController.text.trim(),
                      phone: _phoneController.text.trim(),
                      specialization: _specializationController.text.trim(),
                      image: _imageNotifier.value,
                    );
              } else {
                ref
                    .read(practitionerProvider.notifier)
                    .registerPractitioner(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      phone: _phoneController.text.trim(),
                      specialization: _specializationController.text.trim(),
                      image: _imageNotifier.value,
                      consultationFee: int.parse(_feeController.text),
                    );
              }
            },
            label: widget.practitioner == null ? 'Create' : 'Update',
            isLoading: ref.watch(practitionerProvider).loading,
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
