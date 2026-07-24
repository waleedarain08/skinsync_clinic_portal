import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/requests/register_practitioner_request.dart';
import '../models/responses/register_practitioner_response.dart';
import '../models/treatment_model.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/practitioner_view_model.dart';
import '../view_models/provider_view_model.dart';
import '../view_models/treatment_view_model.dart';
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
      _AddPractitionerScreenState();
}

class _AddPractitionerScreenState extends ConsumerState<AddPractitionerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Section 1: Basic Info
  final _imageNotifier = ValueNotifier<String?>(null);
  String? _selectedTitle;
  final _nameController = TextEditingController();
  String? _selectedRole;
  String? _selectedGender;
  final _dobController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final List<TextEditingController> _qualificationControllers = [];

  // Section 2: Contact Info
  final _emailController = TextEditingController();
  CountryCode? _selectedCountry;
  final _phoneController = TextEditingController();
  
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  CountryCode? _emergencyCountry;
  final _emergencyRelationshipController = TextEditingController();

  // Section 3: License Info
  final _licenseNumberController = TextEditingController();
  final _licenseExpiryController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  final _indemnityNumberController = TextEditingController();
  final _indemnityExpiryController = TextEditingController();
  final List<String> _documents = [];

  // Section 4: Clinic Access
  bool _canPerformConsultation = true;
  bool _canPerformTreatment = true;
  bool _isVirtualEnabled = false;
  bool _acceptsWalkIn = false;
  final List<String> _selectedBookingMethods = [];

  // Section 5: Availability (uses ViewModel state for the list)
  final _globalSlotDurationController = TextEditingController(text: '30');
  final _globalBufferTimeController = TextEditingController(text: '10');

  // Section 6: Financial Info
  final _consultationFeeController = TextEditingController();
  final _treatmentCommissionController = TextEditingController();
  String _commissionType = 'percentage';

  final List<String> _titles = ['Mr', 'Ms', 'Mrs', 'Dr', 'Prof'];
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _commissionTypes = ['percentage', 'fixed'];
  final List<String> _bookingMethods = ['online', 'walk_in', 'manual'];

  @override
  void initState() {
    super.initState();
    _qualificationControllers.add(TextEditingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerRoleViewModelProvider.notifier).fetchProviderRoles();
      ref.read(treatmentViewModelProvider.notifier).getTreatments();

      final practitioner = widget.practitioner;
      if (practitioner != null) {
        _populateExistingData(practitioner);
      }
    });
  }

  void _populateExistingData(Practitioner practitioner) {
    _nameController.text = practitioner.name ?? '';
    _specializationController.text = practitioner.specialization ?? '';
    _emailController.text = practitioner.email ?? '';
    _phoneController.text = practitioner.phone ?? '';
    _imageNotifier.value = practitioner.image;

    ref.read(practitionerProvider.notifier).changeRole(practitioner.role);
    if (practitioner.cc != null) {
       _selectedCountry = CountryCode.fromDialCode(practitioner.cc!);
       ref.read(practitionerProvider.notifier).setCountry(_selectedCountry!);
    }
    
    // Treatments mapping
    final convertedTreatments = practitioner.treatments?.map((t) {
      return TreatmentModel(
        id: t.treatmentId,
        name: t.treatmentName,
        sideAreas: t.sideAreas?.map((s) {
          return SideAreaModel(id: s.sideAreaId, name: s.sideAreaName);
        }).toList(),
      );
    }).toList() ?? [];

    ref.read(practitionerProvider.notifier).setInitialTreatments(convertedTreatments);
    ref.read(practitionerProvider.notifier).setInitialAvailability(practitioner.availability);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    for (var c in _qualificationControllers) {
      c.dispose();
    }
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationshipController.dispose();
    _licenseNumberController.dispose();
    _licenseExpiryController.dispose();
    _issuingAuthorityController.dispose();
    _indemnityNumberController.dispose();
    _indemnityExpiryController.dispose();
    _globalSlotDurationController.dispose();
    _globalBufferTimeController.dispose();
    _consultationFeeController.dispose();
    _treatmentCommissionController.dispose();
    super.dispose();
  }

  void _listener(PractitionerState? prev, PractitionerState next) {
    if (next.success) {
      ref.read(practitionerProvider.notifier).getPractitioner();
      Navigator.pop(context);
    }
  }

  Future<void> _onImageTap() async {
    final image = await ref.read(practitionerProvider.notifier).pickImage();
    if (image != null) {
      _imageNotifier.value = image;
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
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
              horizontal: context.isLandscape ? context.w(150) : context.w(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  SizedBox(height: context.h(24)),
                  _buildContactInfoSection(),
                  SizedBox(height: context.h(24)),
                  _buildLicenseInfoSection(),
                  SizedBox(height: context.h(24)),
                  _buildClinicAccessSection(),
                  SizedBox(height: context.h(24)),
                  _buildAvailabilitySection(),
                  SizedBox(height: context.h(24)),
                  _buildFinancialInfoSection(),
                  SizedBox(height: context.h(32)),
                  _buildButtonsRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
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
          Text(title, style: context.fonts.black20w600),
          SizedBox(height: context.h(20)),
          ...children,
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection(
      title: 'Basic Information',
      children: [
        Center(
          child: Badge(
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
                      child: Icon(Icons.person_outline, size: context.r(30), color: CustomColors.grey),
                    ),
                    fit: BoxFit.cover,
                    width: context.r(100),
                    height: context.r(100),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: context.h(24)),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildDropdownField<String>(
                label: 'Title',
                hintText: 'Select',
                value: _selectedTitle,
                items: _titles,
                onChanged: (val) => setState(() => _selectedTitle = val),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              flex: 3,
              child: BuildTextField(
                controller: _nameController,
                label: 'Full Name',
                hintText: 'Full Name',
                validator: Validators.empty,
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        Consumer(
          builder: (_, ref, __) {
            final role = ref.watch(practitionerProvider.select((s) => s.role));
            final providerRoles = ref.watch(providerRoleViewModelProvider.select((s) => s.providerRoles)) ?? [];
            return _buildDropdownField<String>(
              items: providerRoles.map((r) => r.name ?? "").toList(),
              value: role,
              onChanged: (selectedRole) {
                 ref.read(practitionerProvider.notifier).changeRole(selectedRole);
                 setState(() => _selectedRole = selectedRole);
              },
              label: 'Role',
              hintText: 'Select Role',
              builder: (r) => Text(r.capitalize),
            );
          },
        ),
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Gender',
                hintText: 'Select',
                value: _selectedGender,
                items: _genders,
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(context, _dobController),
                child: AbsorbPointer(
                  child: BuildTextField(
                    controller: _dobController,
                    label: 'Date of Birth',
                    hintText: 'YYYY-MM-DD',
                    validator: Validators.empty,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _specializationController,
                label: 'Specialization',
                hintText: 'Specialization',
                validator: Validators.empty,
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _experienceController,
                label: 'Years of Experience',
                hintText: 'Years',
                keyboardType: TextInputType.number,
                validator: Validators.empty,
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(24)),
        Text('Qualifications', style: context.fonts.black16w600),
        SizedBox(height: context.h(8)),
        ..._qualificationControllers.asMap().entries.map((entry) {
          int index = entry.key;
          var controller = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: context.h(8)),
            child: Row(
              children: [
                Expanded(
                  child: BuildTextField(
                    controller: controller,
                    label: '',
                    hintText: 'Qualification ${index + 1}',
                    validator: Validators.empty,
                  ),
                ),
                if (_qualificationControllers.length > 1)
                  IconButton(
                    onPressed: () => setState(() => _qualificationControllers.removeAt(index)),
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: () => setState(() => _qualificationControllers.add(TextEditingController())),
          icon: const Icon(Icons.add),
          label: const Text('Add Qualification'),
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection(
      title: 'Contact Information',
      children: [
        BuildTextField(
          controller: _emailController,
          label: 'Email',
          hintText: 'Email',
          validator: Validators.email,
          readOnly: widget.practitioner != null,
        ),
        SizedBox(height: context.h(16)),
        Align(alignment: Alignment.centerLeft, child: Text("Phone Number", style: context.fonts.black14w500)),
        SizedBox(height: context.h(8)),
        PhoneWidget(
          controller: _phoneController,
          initialCountryCode: _selectedCountry?.dialCode ?? ref.watch(practitionerProvider).country.dialCode,
          onCountryChanged: (country) {
            _selectedCountry = country;
            ref.read(practitionerProvider.notifier).setCountry(country);
          },
        ),
        SizedBox(height: context.h(24)),
        Container(
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            color: CustomColors.softGrey,
            borderRadius: BorderRadius.circular(context.r(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Emergency Contact', style: context.fonts.black16w600),
              SizedBox(height: context.h(16)),
              BuildTextField(
                controller: _emergencyNameController,
                label: 'Name',
                hintText: 'Name',
                validator: Validators.empty,
              ),
              SizedBox(height: context.h(16)),
              Align(alignment: Alignment.centerLeft, child: Text("Phone Number", style: context.fonts.black14w500)),
              SizedBox(height: context.h(8)),
              PhoneWidget(
                controller: _emergencyPhoneController,
                initialCountryCode: _emergencyCountry?.dialCode ?? ref.watch(practitionerProvider).country.dialCode,
                onCountryChanged: (country) => _emergencyCountry = country,
              ),
              SizedBox(height: context.h(16)),
              BuildTextField(
                controller: _emergencyRelationshipController,
                label: 'Relationship',
                hintText: 'Relationship',
                validator: Validators.empty,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseInfoSection() {
    return _buildSection(
      title: 'License Information',
      children: [
        BuildTextField(
          controller: _licenseNumberController,
          label: 'License Number',
          hintText: 'License Number',
          validator: Validators.empty,
        ),
        SizedBox(height: context.h(16)),
        GestureDetector(
          onTap: () => _selectDate(context, _licenseExpiryController),
          child: AbsorbPointer(
            child: BuildTextField(
              controller: _licenseExpiryController,
              label: 'License Expiry Date',
              hintText: 'YYYY-MM-DD',
              validator: Validators.empty,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        SizedBox(height: context.h(16)),
        BuildTextField(
          controller: _issuingAuthorityController,
          label: 'Issuing Authority',
          hintText: 'Issuing Authority',
          validator: Validators.empty,
        ),
        SizedBox(height: context.h(16)),
        BuildTextField(
          controller: _indemnityNumberController,
          label: 'Indemnity Insurance Number',
          hintText: 'Insurance Number',
          validator: Validators.empty,
        ),
        SizedBox(height: context.h(16)),
        GestureDetector(
          onTap: () => _selectDate(context, _indemnityExpiryController),
          child: AbsorbPointer(
            child: BuildTextField(
              controller: _indemnityExpiryController,
              label: 'Indemnity Expiry Date',
              hintText: 'YYYY-MM-DD',
              validator: Validators.empty,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
        ),
        SizedBox(height: context.h(24)),
        Text('Documents', style: context.fonts.black16w600),
        SizedBox(height: context.h(16)),
        Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: [
            ..._documents.asMap().entries.map((entry) {
              int index = entry.key;
              return Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(8)),
                    decoration: BoxDecoration(color: CustomColors.softGrey, borderRadius: BorderRadius.circular(context.r(8))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description, size: 20),
                        SizedBox(width: context.w(8)),
                        Text('Doc ${index + 1}'),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -5, right: -5,
                    child: GestureDetector(
                      onTap: () => setState(() => _documents.removeAt(index)),
                      child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                    ),
                  ),
                ],
              );
            }),
            GestureDetector(
              onTap: () async {
                // Simplified mock upload
                setState(() => _documents.add('https://example.com/doc_${_documents.length + 1}.pdf'));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(12), vertical: context.h(8)),
                decoration: BoxDecoration(border: Border.all(color: CustomColors.border, style: BorderStyle.solid), borderRadius: BorderRadius.circular(context.r(8))),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add, size: 20), Text(' Upload Doc')],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClinicAccessSection() {
    return _buildSection(
      title: 'Clinic Access',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Treatments', style: context.fonts.black16w600),
            CustomPrimaryButton(
              onTap: () => showDialog(context: context, builder: (context) => const SelectTreatmentDialog()),
              label: 'Select Treatments', icon: Icons.add, height: context.h(36),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        _buildTreatmentChips(),
        SizedBox(height: context.h(24)),
        Text('Permissions', style: context.fonts.black16w600),
        SwitchListTile(
          title: Text('Can Perform Consultation', style: context.fonts.black14w400),
          value: _canPerformConsultation,
          onChanged: (val) => setState(() => _canPerformConsultation = val),
        ),
        SwitchListTile(
          title: Text('Can Perform Treatment', style: context.fonts.black14w400),
          value: _canPerformTreatment,
          onChanged: (val) => setState(() => _canPerformTreatment = val),
        ),
        SwitchListTile(
          title: Text('Virtual Consultation Enabled', style: context.fonts.black14w400),
          value: _isVirtualEnabled,
          onChanged: (val) => setState(() => _isVirtualEnabled = val),
        ),
        SwitchListTile(
          title: Text('Accept Walk-in Patients', style: context.fonts.black14w400),
          value: _acceptsWalkIn,
          onChanged: (val) => setState(() => _acceptsWalkIn = val),
        ),
        SizedBox(height: context.h(24)),
        Text('Booking Methods', style: context.fonts.black16w600),
        SizedBox(height: context.h(8)),
        Wrap(
          spacing: context.w(16),
          children: _bookingMethods.map((method) {
            final isSelected = _selectedBookingMethods.contains(method);
            return FilterChip(
              label: Text(method.capitalize),
              selected: isSelected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedBookingMethods.add(method);
                  } else {
                    _selectedBookingMethods.remove(method);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return _buildSection(
      title: 'Availability Information',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Schedules', style: context.fonts.black16w600),
            CustomPrimaryButton(
              onTap: () async {
                final availability = await showDialog<Availability>(context: context, builder: (context) => const AddSlotDialog());
                if (availability != null) {
                  ref.read(practitionerProvider.notifier).setAvailability(availability);
                }
              },
              label: 'Add Schedule', icon: Icons.add, height: context.h(36),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        _buildAvailabilityList(),
        const Divider(height: 48),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _globalSlotDurationController,
                label: 'Global Slot Duration (Min)',
                hintText: '30', keyboardType: TextInputType.number,
                validator: Validators.empty,
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _globalBufferTimeController,
                label: 'Global Buffer Time (Min)',
                hintText: '10', keyboardType: TextInputType.number,
                validator: Validators.empty,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinancialInfoSection() {
    return _buildSection(
      title: 'Financial Information',
      children: [
        BuildTextField(
          controller: _consultationFeeController,
          label: 'Consultation Fee',
          hintText: '500', keyboardType: TextInputType.number,
          validator: Validators.empty,
        ),
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _treatmentCommissionController,
                label: 'Treatment Commission',
                hintText: '10.0', keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: Validators.empty,
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Commission Type',
                hintText: 'Select',
                value: _commissionType,
                items: _commissionTypes,
                onChanged: (val) => setState(() => _commissionType = val ?? 'percentage'),
                builder: (val) => Text(val.capitalize),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label, required String hintText,
    required T? value, required List<T> items,
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
            hint: Text(hintText, style: context.fonts.grey14w400.copyWith(color: CustomColors.lightGrey)),
            value: value,
            items: items.map((item) => DropdownMenuItem<T>(value: item, child: builder?.call(item) ?? Text(item.toString()))).toList(),
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: context.h(48), padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(context.r(8)), border: Border.all(color: CustomColors.border)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentChips() {
    return Consumer(
      builder: (_, ref, __) {
        final treatments = ref.watch(practitionerProvider.select((s) => s.treatments));
        if (treatments.isEmpty) return Text('No treatments selected', style: context.fonts.grey14w400);
        return Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: treatments.map((t) => Chip(
            label: Text(t.name ?? 'N/A'),
            onDeleted: () => ref.read(practitionerProvider.notifier).toggleSelectedTreatment(t),
            deleteIcon: const Icon(Icons.cancel, size: 18),
          )).toList(),
        );
      },
    );
  }

  Widget _buildAvailabilityList() {
    return Consumer(
      builder: (_, ref, __) {
        final availability = ref.watch(practitionerProvider.select((s) => s.availability));
        if (availability.isEmpty) return Text('No schedules added', style: context.fonts.grey14w400);
        return Column(
          children: availability.map((av) => Card(
            margin: EdgeInsets.only(bottom: context.h(12)),
            child: ListTile(
              title: Text(av.uiTimeRange(context), style: context.fonts.black14w600),
              subtitle: Text(av.days.join(', '), style: context.fonts.grey12w400),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => ref.read(practitionerProvider.notifier).deleteAvailability(av),
              ),
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        Expanded(
          child: CustomPrimaryButton(
            onTap: _submitForm,
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      log('Role not selected');
    }
    
    final state = ref.read(practitionerProvider);
    
    final basicInfo = BasicInfo(
      name: _nameController.text.trim(),
      role: state.role ?? '',
      title: _selectedTitle ?? '',
      image: _imageNotifier.value,
      gender: _selectedGender?.toLowerCase() ?? '',
      dateOfBirth: _dobController.text,
      specialization: _specializationController.text.trim(),
      yearsOfExperience: int.tryParse(_experienceController.text) ?? 0,
      qualifications: _qualificationControllers.map((c) => c.text.trim()).where((q) => q.isNotEmpty).toList(),
    );

    final contactInfo = ContactInfo(
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      cc: state.country.dialCode ?? '',
      country: state.country.name ?? '',
      emergencyContact: EmergencyContact(
        name: _emergencyNameController.text.trim(),
        phone: _emergencyPhoneController.text.trim(),
        cc: _emergencyCountry?.dialCode ?? state.country.dialCode ?? '',
        country: _emergencyCountry?.name ?? state.country.name ?? '',
        relationship: _emergencyRelationshipController.text.trim(),
      ),
    );

    final licenseInfo = LicenseInfo(
      licenseNumber: _licenseNumberController.text.trim(),
      licenseExpiryDate: _licenseExpiryController.text,
      issuingAuthority: _issuingAuthorityController.text.trim(),
      indemnityInsuranceNumber: _indemnityNumberController.text.trim(),
      indemnityExpiryDate: _indemnityExpiryController.text,
      documents: _documents,
    );

    final clinicAccess = ClinicAccess(
      treatmentIds: state.treatments.map((t) => t.id!).toList(),
      canPerformConsultation: _canPerformConsultation,
      canPerformTreatment: _canPerformTreatment,
      isVirtualEnabled: _isVirtualEnabled,
      acceptsWalkIn: _acceptsWalkIn,
      allowedBookingMethods: _selectedBookingMethods,
    );

    final availabilityInfo = AvailabilityInfo(
      availability: state.availability,
      slotDurationMinutes: int.tryParse(_globalSlotDurationController.text) ?? 30,
      bufferTimeMinutes: int.tryParse(_globalBufferTimeController.text) ?? 10,
    );

    final financialInfo = FinancialInfo(
      consultationFee: int.tryParse(_consultationFeeController.text) ?? 0,
      treatmentCommission: double.tryParse(_treatmentCommissionController.text) ?? 0,
      commissionType: _commissionType,
    );

    if (widget.practitioner != null) {
      // Handle Update
    } else {
      ref.read(practitionerProvider.notifier).registerPractitioner(
        basicInfo: basicInfo,
        contactInfo: contactInfo,
        licenseInfo: licenseInfo,
        clinicAccess: clinicAccess,
        availabilityInfo: availabilityInfo,
        financialInfo: financialInfo,
      );
    }
  }
}
