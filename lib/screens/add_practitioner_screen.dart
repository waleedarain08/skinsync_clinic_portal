import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/requests/register_practitioner_request.dart';
import '../models/responses/register_practitioner_response.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../utils/validators.dart';
import '../view_models/practitioner_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dialog_box/add_slot_dialog_box.dart';
import '../widgets/dialog_box/select_treatment_dailog.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/borderd_container_widget.dart';

class AddPractitionerScreen extends ConsumerStatefulWidget {
  const AddPractitionerScreen({super.key, this.practitioner});
  static const String routeName = '/add-Provider';
  final Practitioner? practitioner;

  @override
  ConsumerState<AddPractitionerScreen> createState() =>
      _AddPractitionerScreenState();
}

class _AddPractitionerScreenState extends ConsumerState<AddPractitionerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Section 1: Basic Info
 // final _imageNotifier = ValueNotifier<String?>(null);
  // String? _selectedTitle;
  final _nameController = TextEditingController();
  //  String? _selectedGender;
  final _dobController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final List<TextEditingController> _qualificationControllers = [];

  // Section 2: Contact Info
  final _emailController = TextEditingController();
 // CountryCode? _selectedCountry;
  final _phoneController = TextEditingController();

  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  // CountryCode? _emergencyCountry;
  final _emergencyRelationshipController = TextEditingController();

  // Section 3: License Info
  final _licenseNumberController = TextEditingController();
  final _licenseExpiryController = TextEditingController();
  final _issuingAuthorityController = TextEditingController();
  final _indemnityNumberController = TextEditingController();
  final _indemnityExpiryController = TextEditingController();
  // final List<String> _documents = [];

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

  // final List<String> _titles = ['Mr', 'Ms', 'Mrs', 'Dr', 'Prof'];
  // final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _commissionTypes = ['percentage', 'fixed'];
  final List<String> _bookingMethods = ['online', 'walk_in', 'manual'];

  @override
  void initState() {
    super.initState();
    _qualificationControllers.add(TextEditingController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
    //  ref.read(providerRoleViewModelProvider.notifier).fetchProviderRoles();
      ref.read(treatmentViewModelProvider.notifier).getTreatments();

      final practitioner = widget.practitioner;
      if (practitioner != null) {
        _populateExistingData(practitioner);
      }
    });
  }

  void _populateExistingData(Practitioner practitioner) {
    // _nameController.text = practitioner.basicInfo?.name ?? '';
    // _specializationController.text =
    //     practitioner.basicInfo?.specialization ?? '';
    // _emailController.text = practitioner.contactInfo?.email ?? '';
    // _phoneController.text = practitioner.contactInfo?.phone ?? '';
    // _imageNotifier.value = practitioner.basicInfo?.image;

    // ref
    //     .read(practitionerProvider.notifier)
    //     .changeRole(practitioner.basicInfo?.role);
    // if (practitioner.contactInfo?.cc != null) {
    //   _selectedCountry = CountryCode.fromDialCode(practitioner.contactInfo!.cc);
    //   ref.read(practitionerProvider.notifier).setCountry(_selectedCountry!);
    // }

    // Treatments mapping
    // final convertedTreatments =
    //     practitioner.treatments?.map((t) {
    //       return TreatmentModel(
    //         id: t.treatmentId,
    //         name: t.treatmentName,
    //         sideAreas: t.sideAreas?.map((s) {
    //           return SideAreaModel(id: s.sideAreaId, name: s.sideAreaName);
    //         }).toList(),
    //       );
    //     }).toList() ??
    //     [];

    // ref
    //     .read(practitionerProvider.notifier)
    //     .setInitialTreatments(convertedTreatments);
    ref
        .read(practitionerProvider.notifier)
        .setInitialAvailability(practitioner.availabilityInfo?.availability);
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

  // Future<void> _onImageTap() async {
  //   final image = await ref.read(practitionerProvider.notifier).pickImage();
  //   if (image != null) {
  //     _imageNotifier.value = image;
  //   }
  // }

  // Future<void> _selectDate(
  //   BuildContext context,
  //   TextEditingController controller,
  // ) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null) {
  //     controller.text = DateFormat('yyyy-MM-dd').format(picked);
  //   }
  // }

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
            isEditing ? 'Update Provider' : 'Add Provider',
            style: context.fonts.black18w600,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            _buildHeaderPanel(),
            Expanded(
              child: SingleChildScrollView(
                padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  _buildBasicInfoSection(),
                      // SizedBox(height: context.h(24)),
                      // _buildContactInfoSection(),
                      // SizedBox(height: context.h(24)),
                      // _buildLicenseInfoSection(),
                      _buildDoctorEmailSection(),
                      SizedBox(height: context.h(24)),
                      _buildClinicAccessSection(),
                      SizedBox(height: context.h(24)),
                      _buildAvailabilitySection(),
                      SizedBox(height: context.h(24)),
                      _buildFinancialInfoSection(),
                      SizedBox(height: context.h(40)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderPanel() {
    final isEditing = widget.practitioner != null;
    return Padding(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        backgroundColor: CustomColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: CustomColors.purple,
                  ),
                ),
                context.horizontalSpace(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? 'Update Provider Profile'
                          : 'Provider Onboarding',
                      style: context.fonts.black16w600,
                    ),
                    Text(
                      'Configure Provider identity, licensing, and clinical availability.',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                CustomOutlinedButton(
                  onTap: () => context.pop(),
                  label: 'Cancel',
                  width: context.w(100),
                  height: context.h(40),
                ),
                context.horizontalSpace(12),
                CustomPrimaryButton(
                  onTap: _submitForm,
                  label: isEditing ? 'Update Provider' : 'Save Provider',
                  width: context.w(180),
                  height: context.h(40),
                  icon: isEditing
                      ? Icons.save_as_outlined
                      : Icons.check_circle_outline,
                  isLoading: ref.watch(practitionerProvider).loading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    Widget? trailing,
  }) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.fonts.black18w600),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          ...children,
        ],
      ),
    );
  }

  // Widget _buildBasicInfoSection() {
  //   return _buildSection(
  //     title: 'Basic Information',
  //     children: [
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildImagePicker(),
  //           context.horizontalSpace(24),
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: _buildDropdownField<String>(
  //                         label: 'Title',
  //                         hintText: 'Select',
  //                         value: _selectedTitle,
  //                         items: _titles,
  //                         onChanged: (val) =>
  //                             setState(() => _selectedTitle = val),
  //                       ),
  //                     ),
  //                     context.horizontalSpace(16),
  //                     Expanded(
  //                       child: Consumer(
  //                         builder: (_, ref, _) {
  //                           final role = ref.watch(
  //                             practitionerProvider.select((s) => s.role),
  //                           );
  //                           final providerRoles =
  //                               ref.watch(
  //                                 providerRoleViewModelProvider.select(
  //                                   (s) => s.providerRoles,
  //                                 ),
  //                               ) ??
  //                               [];
  //                           return _buildDropdownField<String>(
  //                             items: providerRoles
  //                                 .map((r) => r.name ?? "")
  //                                 .toList(),
  //                             value: role,
  //                             onChanged: (selectedRole) {
  //                               ref
  //                                   .read(practitionerProvider.notifier)
  //                                   .changeRole(selectedRole);
  //                             },
  //                             label: 'Role',
  //                             hintText: 'Select Role',
  //                             builder: (r) => Text(r.capitalize),
  //                           );
  //                         },
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 context.verticalSpace(16),
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: _buildDropdownField<String>(
  //                         label: 'Gender',
  //                         hintText: 'Select',
  //                         value: _selectedGender,
  //                         items: _genders,
  //                         onChanged: (val) =>
  //                             setState(() => _selectedGender = val),
  //                       ),
  //                     ),
  //                     context.horizontalSpace(16),
  //                     Expanded(
  //                       child: GestureDetector(
  //                         onTap: () => _selectDate(context, _dobController),
  //                         child: AbsorbPointer(
  //                           child: BuildTextField(
  //                             controller: _dobController,
  //                             label: 'Date of Birth',
  //                             hintText: 'YYYY-MM-DD',
  //                             validator: Validators.empty,
  //                             suffixIcon: const Icon(Icons.calendar_today),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: context.h(24)),
  //       BuildTextField(
  //         controller: _nameController,
  //         label: 'Full Name',
  //         hintText: 'Full Name',
  //         validator: Validators.empty,
  //       ),
  //       SizedBox(height: context.h(24)),
  //       BuildTextField(
  //         controller: _specializationController,
  //         label: 'Specialization',
  //         hintText: 'Specialization',
  //         validator: Validators.empty,
  //       ),
  //       SizedBox(height: context.h(24)),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: BuildTextField(
  //               controller: _experienceController,
  //               label: 'Years of Experience',
  //               hintText: 'Years',
  //               keyboardType: TextInputType.number,
  //               validator: Validators.empty,
  //             ),
  //           ),
  //           context.horizontalSpace(16),
  //           const Spacer(),
  //         ],
  //       ),
  //       SizedBox(height: context.h(32)),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('Qualifications', style: context.fonts.black16w600),
  //           TextButton.icon(
  //             onPressed: () => setState(
  //               () => _qualificationControllers.add(TextEditingController()),
  //             ),
  //             icon: const Icon(Icons.add, size: 18),
  //             label: const Text('Add Qualification'),
  //             style: TextButton.styleFrom(padding: EdgeInsets.zero),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: context.h(12)),
  //       ..._qualificationControllers.asMap().entries.map((entry) {
  //         int index = entry.key;
  //         var controller = entry.value;
  //         return Padding(
  //           padding: EdgeInsets.only(bottom: context.h(12)),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: BuildTextField(
  //                   controller: controller,
  //                   label: '',
  //                   hintText: 'e.g. MBBS, Diploma in Aesthetic Medicine...',
  //                   validator: Validators.empty,
  //                 ),
  //               ),
  //               if (_qualificationControllers.length > 1)
  //                 IconButton(
  //                   onPressed: () => setState(
  //                     () => _qualificationControllers.removeAt(index),
  //                   ),
  //                   icon: const Icon(
  //                     Icons.remove_circle_outline,
  //                     color: Colors.red,
  //                   ),
  //                   padding: EdgeInsets.zero,
  //                 ),
  //             ],
  //           ),
  //         );
  //       }),
  //     ],
  //   );
  // }

  // Widget _buildImagePicker() {
  //   return ValueListenableBuilder(
  //     valueListenable: _imageNotifier,
  //     builder: (_, image, _) {
  //       final hasImage = image != null || widget.practitioner?.basicInfo?.image != null;
  //       final imageUrl = image ?? widget.practitioner?.basicInfo?.image ?? '';

  //       return GestureDetector(
  //         onTap: _onImageTap,
  //         child: Column(
  //           children: [
  //             Container(
  //               width: context.r(120),
  //               height: context.r(120),
  //               decoration: BoxDecoration(
  //                 color: CustomColors.whiteGrey,
  //                 borderRadius: BorderRadius.circular(context.r(12)),
  //                 border: Border.all(color: CustomColors.border),
  //               ),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(context.r(12)),
  //                 child: hasImage
  //                     ? CachedNetworkImage(
  //                         imageUrl: imageUrl,
  //                         fit: BoxFit.cover,
  //                         placeholder: (_, _) =>
  //                             const Center(child: CircularProgressIndicator()),
  //                         errorWidget: (_, _, _) => _buildImagePlaceholder(),
  //                       )
  //                     : _buildImagePlaceholder(),
  //               ),
  //             ),
  //             context.verticalSpace(8),
  //             Text('Profile Image', style: context.fonts.grey11w600ls12),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildImagePlaceholder() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       const Icon(
  //         Icons.add_a_photo_outlined,
  //         color: CustomColors.purple,
  //         size: 32,
  //       ),
  //       context.verticalSpace(4),
  //       Text('UPLOAD', style: context.fonts.purple9w800ls1),
  //     ],
  //   );
  // }

  // Widget _buildContactInfoSection() {
  //   return _buildSection(
  //     title: 'Contact Information',
  //     children: [
  //       BuildTextField(
  //         controller: _emailController,
  //         label: 'Official Email',
  //         hintText: 'Email',
  //         validator: Validators.email,
  //         readOnly: widget.practitioner != null,
  //       ),
  //       SizedBox(height: context.h(24)),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Phone Number", style: context.fonts.black14w600),
  //                 SizedBox(height: context.h(8)),
  //                 PhoneWidget(
  //                   controller: _phoneController,
  //                   initialCountryCode:
  //                       _selectedCountry?.dialCode ??
  //                       ref.watch(practitionerProvider).country.dialCode,
  //                   onCountryChanged: (country) {
  //                     _selectedCountry = country;
  //                     ref
  //                         .read(practitionerProvider.notifier)
  //                         .setCountry(country);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //           context.horizontalSpace(16),
  //           const Spacer(),
  //         ],
  //       ),
  //       SizedBox(height: context.h(32)),
  //       Text('Emergency Contact Details', style: context.fonts.black16w600),
  //       SizedBox(height: context.h(16)),
  //       BorderdContainerWidget(
  //         padding: context.appEdgeInsets(all: 16),
  //         backgroundColor: CustomColors.whiteGrey,
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: BuildTextField(
  //                     controller: _emergencyNameController,
  //                     label: 'Name',
  //                     hintText: 'Full Name',
  //                     validator: Validators.empty,
  //                   ),
  //                 ),
  //                 SizedBox(width: context.w(16)),
  //                 Expanded(
  //                   child: BuildTextField(
  //                     controller: _emergencyRelationshipController,
  //                     label: 'Relationship',
  //                     hintText: 'e.g. Spouse, Parent...',
  //                     validator: Validators.empty,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: context.h(16)),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text("Phone Number", style: context.fonts.black14w600),
  //                       SizedBox(height: context.h(8)),
  //                       PhoneWidget(
  //                         controller: _emergencyPhoneController,
  //                         initialCountryCode:
  //                             _emergencyCountry?.dialCode ??
  //                             ref.watch(practitionerProvider).country.dialCode,
  //                         onCountryChanged: (country) =>
  //                             _emergencyCountry = country,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 context.horizontalSpace(16),
  //                 const Spacer(),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLicenseInfoSection() {
  //   return _buildSection(
  //     title: 'Professional License & Indemnity',
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: BuildTextField(
  //               controller: _licenseNumberController,
  //               label: 'License Number',
  //               hintText: 'e.g. PMC-12345',
  //               validator: Validators.empty,
  //             ),
  //           ),
  //           SizedBox(width: context.w(16)),
  //           Expanded(
  //             child: GestureDetector(
  //               onTap: () => _selectDate(context, _licenseExpiryController),
  //               child: AbsorbPointer(
  //                 child: BuildTextField(
  //                   controller: _licenseExpiryController,
  //                   label: 'License Expiry Date',
  //                   hintText: 'YYYY-MM-DD',
  //                   validator: Validators.empty,
  //                   suffixIcon: const Icon(Icons.calendar_today),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: context.h(16)),
  //       BuildTextField(
  //         controller: _issuingAuthorityController,
  //         label: 'Issuing Authority',
  //         hintText: 'e.g. Pakistan Medical Commission',
  //         validator: Validators.empty,
  //       ),
  //       SizedBox(height: context.h(16)),
  //       Row(
  //         children: [
  //           Expanded(
  //             child: BuildTextField(
  //               controller: _indemnityNumberController,
  //               label: 'Indemnity Insurance Number',
  //               hintText: 'Insurance Number',
  //               validator: Validators.empty,
  //             ),
  //           ),
  //           SizedBox(width: context.w(16)),
  //           Expanded(
  //             child: GestureDetector(
  //               onTap: () => _selectDate(context, _indemnityExpiryController),
  //               child: AbsorbPointer(
  //                 child: BuildTextField(
  //                   controller: _indemnityExpiryController,
  //                   label: 'Indemnity Expiry Date',
  //                   hintText: 'YYYY-MM-DD',
  //                   validator: Validators.empty,
  //                   suffixIcon: const Icon(Icons.calendar_today),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: context.h(32)),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text('Verification Documents', style: context.fonts.black16w600),
  //           TextButton.icon(
  //             onPressed: () async {
  //               await ref
  //                   .read(practitionerProvider.notifier)
  //                   .pickAndUploadDocument();
  //             },
  //             icon: const Icon(Icons.upload_file_outlined, size: 18),
  //             label: const Text('Upload Document'),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: context.h(12)),
  //       Consumer(
  //         builder: (context, ref, _) {
  //           final practitionerState = ref.watch(practitionerProvider);

  //           final documents = practitionerState.documents;
  //           if (documents.isEmpty) {
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(vertical: 8),
  //               child: Text(
  //                 'No documents uploaded yet.',
  //                 style: context.fonts.grey12w400,
  //               ),
  //             );
  //           } else {
  //             return Wrap(
  //               spacing: context.w(12),
  //               runSpacing: context.h(12),
  //               children: documents.asMap().entries.map((entry) {
  //                 int index = entry.key;
  //                 return Stack(
  //                   clipBehavior: Clip.none,
  //                   children: [
  //                     Container(
  //                       padding: EdgeInsets.symmetric(
  //                         horizontal: context.w(12),
  //                         vertical: context.h(10),
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: CustomColors.whiteGrey,
  //                         borderRadius: BorderRadius.circular(context.r(8)),
  //                         border: Border.all(color: CustomColors.border),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           const Icon(
  //                             Icons.description_outlined,
  //                             size: 20,
  //                             color: CustomColors.purple,
  //                           ),
  //                           SizedBox(width: context.w(8)),
  //                           Text(
  //                             'Verification Doc ${index + 1}',
  //                             style: context.fonts.black12w600,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Positioned(
  //                       top: -8,
  //                       right: -8,
  //                       child: GestureDetector(
  //                         onTap: () {
  //                           ref
  //                               .read(practitionerProvider.notifier)
  //                               .removeDocument(documents[index]);
  //                         },
  //                         child: Container(
  //                           padding: const EdgeInsets.all(2),
  //                           decoration: const BoxDecoration(
  //                             color: Colors.red,
  //                             shape: BoxShape.circle,
  //                           ),
  //                           child: const Icon(
  //                             Icons.close,
  //                             color: Colors.white,
  //                             size: 14,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 );
  //               }).toList(),
  //             );
  //           }
  //         },
  //       ),
  //     ],
  //   );
  // }

  Widget _buildDoctorEmailSection() {
    return _buildSection(
      title: 'Add Doctor',
      children: [
        BuildTextField(
          label: 'Doctor Email',
          controller: _emailController,
          hintText: 'Enter doctor email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
          validator: Validators.email,
        ),
      ],
    );
  }

  Widget _buildClinicAccessSection() {
    return _buildSection(
      title: 'Clinic Access & Operations',
      trailing: CustomPrimaryButton(
        onTap: () => showDialog(
          context: context,
          builder: (context) => const SelectTreatmentDialog(),
        ),
        label: 'Assign Treatments',
        icon: Icons.add,
        height: context.h(32),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      children: [
        Text('Assigned Treatments', style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
        _buildTreatmentChips(),
        SizedBox(height: context.h(32)),
        Text('Permissions & Flags', style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(8)),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Can Perform Consultation',
                  style: context.fonts.black14w400,
                ),
                value: _canPerformConsultation,
                onChanged: (val) =>
                    setState(() => _canPerformConsultation = val),
              ),
            ),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Can Perform Treatment',
                  style: context.fonts.black14w400,
                ),
                value: _canPerformTreatment,
                onChanged: (val) => setState(() => _canPerformTreatment = val),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Virtual Enabled',
                  style: context.fonts.black14w400,
                ),
                value: _isVirtualEnabled,
                onChanged: (val) => setState(() => _isVirtualEnabled = val),
              ),
            ),
            Expanded(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Accepts Walk-in',
                  style: context.fonts.black14w400,
                ),
                value: _acceptsWalkIn,
                onChanged: (val) => setState(() => _acceptsWalkIn = val),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(32)),
        Text('Allowed Booking Methods', style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
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
              selectedColor: CustomColors.purple.withValues(alpha: 0.2),
              checkmarkColor: CustomColors.purple,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return _buildSection(
      title: 'Clinical Availability',
      trailing: CustomPrimaryButton(
        onTap: () async {
          final availability = await showDialog<Availability>(
            context: context,
            builder: (context) => const AddSlotDialog(),
          );
          if (availability != null) {
            ref
                .read(practitionerProvider.notifier)
                .setAvailability(availability);
          }
        },
        label: 'Add Schedule',
        icon: Icons.calendar_month_outlined,
        height: context.h(32),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      children: [
        _buildAvailabilityList(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Divider(color: CustomColors.border),
        ),
        Text('Global Scheduling Rules', style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(16)),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _globalSlotDurationController,
                label: 'Slot Duration (Min)',
                hintText: '30',
                keyboardType: TextInputType.number,
                validator: Validators.empty,
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _globalBufferTimeController,
                label: 'Buffer Time (Min)',
                hintText: '10',
                keyboardType: TextInputType.number,
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
      title: 'Financial Configuration',
      children: [
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _consultationFeeController,
                label: 'Consultation Fee',
                hintText: '500',
                keyboardType: TextInputType.number,
                validator: Validators.empty,
                prefixIcon: const Icon(Icons.attach_money, size: 18),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _treatmentCommissionController,
                label: 'Treatment Commission',
                hintText: '10.0',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
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
                onChanged: (val) =>
                    setState(() => _commissionType = val ?? 'percentage'),
                builder: (val) => Text(val.capitalize),
              ),
            ),
          ],
        ),
      ],
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
        Text(label, style: context.fonts.black14w600),
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
              height: context.h(52),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
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
          practitionerProvider.select((s) => s.treatments),
        );
        if (treatments.isEmpty) {
          return Text(
            'No treatments assigned yet.',
            style: context.fonts.grey14w400,
          );
        }
        return Wrap(
          spacing: context.w(8),
          runSpacing: context.h(8),
          children: treatments
              .map(
                (t) => Chip(
                  backgroundColor: CustomColors.purple.withValues(alpha: 0.1),
                  side: BorderSide(
                    color: CustomColors.purple.withValues(alpha: 0.2),
                  ),
                  label: Text(
                    t.name ?? 'N/A',
                    style: context.fonts.purple11w600,
                  ),
                  onDeleted: () => ref
                      .read(practitionerProvider.notifier)
                      .toggleSelectedTreatment(t),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 14,
                    color: CustomColors.purple,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildAvailabilityList() {
    return Consumer(
      builder: (_, ref, _) {
        final availability = ref.watch(
          practitionerProvider.select((s) => s.availability),
        );
        if (availability.isEmpty) {
          return Text(
            'No schedules added yet.',
            style: context.fonts.grey14w400,
          );
        }
        return Column(
          children: availability
              .map(
                (av) => BorderdContainerWidget(
                  margin: EdgeInsets.only(bottom: context.h(12)),
                  padding: context.appEdgeInsets(horizontal: 16, vertical: 8),
                  backgroundColor: CustomColors.whiteGrey,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.access_time_outlined,
                      color: CustomColors.purple,
                    ),
                    title: Text(
                      av.uiTimeRange(context),
                      style: context.fonts.black14w600,
                    ),
                    subtitle: Text(
                      av.days.join(', '),
                      style: context.fonts.grey12w400,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => ref
                          .read(practitionerProvider.notifier)
                          .deleteAvailability(av),
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(practitionerProvider);

    // final basicInfo = BasicInfo(
    //   name: _nameController.text.trim(),
    //   role: state.role ?? '',
    //   title: _selectedTitle ?? '',
    //   image: _imageNotifier.value,
    //   gender: _selectedGender?.toLowerCase() ?? '',
    //   dateOfBirth: _dobController.text,
    //   specialization: _specializationController.text.trim(),
    //   yearsOfExperience: int.tryParse(_experienceController.text) ?? 0,
    //   qualifications: _qualificationControllers
    //       .map((c) => c.text.trim())
    //       .where((q) => q.isNotEmpty)
    //       .toList(),
    // );

    // final contactInfo = ContactInfo(
    //   email: _emailController.text.trim(),
    //   phone: _phoneController.text.trim(),
    //   cc: state.country.dialCode ?? '',
    //   country: state.country.name ?? '',
    //   emergencyContact: EmergencyContact(
    //     name: _emergencyNameController.text.trim(),
    //     phone: _emergencyPhoneController.text.trim(),
    //     cc: _emergencyCountry?.dialCode ?? state.country.dialCode ?? '',
    //     country: _emergencyCountry?.name ?? state.country.name ?? '',
    //     relationship: _emergencyRelationshipController.text.trim(),
    //   ),
    // );

    // final licenseInfo = LicenseInfo(
    //   licenseNumber: _licenseNumberController.text.trim(),
    //   licenseExpiryDate: _licenseExpiryController.text,
    //   issuingAuthority: _issuingAuthorityController.text.trim(),
    //   indemnityInsuranceNumber: _indemnityNumberController.text.trim(),
    //   indemnityExpiryDate: _indemnityExpiryController.text,
    //   documents: ref.read(practitionerProvider).documents,
    // );

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
      slotDurationMinutes:
          int.tryParse(_globalSlotDurationController.text) ?? 30,
      bufferTimeMinutes: int.tryParse(_globalBufferTimeController.text) ?? 10,
    );

    final financialInfo = FinancialInfo(
      consultationFee: int.tryParse(_consultationFeeController.text) ?? 0,
      treatmentCommission:
          double.tryParse(_treatmentCommissionController.text) ?? 0,
      commissionType: _commissionType,
    );

    if (widget.practitioner != null) {
      // Handle Update
    } else {
      ref
          .read(practitionerProvider.notifier)
          .registerPractitioner(
            // basicInfo: basicInfo,
            // contactInfo: contactInfo,
            // licenseInfo: licenseInfo,
            clinicAccess: clinicAccess,
            availabilityInfo: availabilityInfo,
            financialInfo: financialInfo,
          );
    }
  }
}
