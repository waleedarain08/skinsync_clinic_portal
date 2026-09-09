import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/patient_model.dart';
import '../models/requests/create_appointment_request.dart';
import '../models/responses/filters_response.dart';
import '../models/responses/practitioner_list_response.dart';
import '../models/treatment_model.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/appointment_creation_view_model.dart';
import '../view_models/appointment_view_model.dart';
import '../view_models/patient_view_model.dart';
import '../view_models/practitioner_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../models/responses/area_list_response.dart';
import '../view_models/area_view_model.dart';
import 'dashboard/patient_management_detail.dart';
import '../widgets/app_loader.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/phone_widget.dart';
import '../widgets/treatment_container.dart';
import '../models/responses/login_response_model.dart';

class CreateAppointmentScreen extends ConsumerStatefulWidget {
  const CreateAppointmentScreen({super.key});

  static const String routeName = '/create-appointment';

  @override
  ConsumerState<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState
    extends ConsumerState<CreateAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Section 1: Patient Search / Info
  final _patientNameController = TextEditingController();
  final _patientEmailController = TextEditingController();
  final _patientPhoneController = TextEditingController();
  String _selectedCountryCode = '+1';

  // Section 2: Treatment & Services
  Filters? _selectedAppointmentTypeFilter;
  TreatmentModel? _selectedDropdownTreatment;

  final List<TreatmentModel> _selectedTreatments = [];
  final Map<int, List<AreaModel>> _fetchedAreasMap = {};
  bool _isFetchingAreas = false;

  // Section 3: Practitioners & Clinical Schedule (Paginated & Searchable via fetchPractitioner API)
  final _practitionerSearchController = TextEditingController();
  PractitionerListItem? _selectedPractitionerItem;

  final List<_AssignedPractitioner> _assignedPractitioners = [];

  final _dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  String _selectedTimeSlot = '10:00 AM';
  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:30 AM',
    '01:30 PM',
    '03:00 PM',
    '04:30 PM',
  ];

  // Section 4: Notes & Booking Config
  String _bookingMethod = 'online';
  final List<String> _bookingMethods = ['online', 'walk_in', 'manual'];
  final _notesController = TextEditingController();

  // Section 5: Financials & Payment Details
  final _amountController = TextEditingController(text: '250');
  String _paymentType = 'cash';
  final List<String> _paymentTypes = ['cash', 'card', 'stripe'];
  String _paymentStatus = 'pending';
  final List<String> _paymentStatuses = ['pending', 'completed'];
  String _discountType = 'flat';
  final List<String> _discountTypes = ['flat', 'percentage'];
  final _discountController = TextEditingController(text: '0');
  final _amountPaidController = TextEditingController(text: '12');

  // Section 6: Simulations (Optional)
  bool _showSimulationsSection = false;
  final _frontImageBeforeController = TextEditingController();
  final _frontImageAfterController = TextEditingController();
  final _rightImageBeforeController = TextEditingController();
  final _rightImageAfterController = TextEditingController();
  final _leftImageBeforeController = TextEditingController();
  final _leftImageAfterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practitionerProvider.notifier).getPractitioner(page: 1);
      ref.read(appointmentProvider.notifier).getAppointmentsTypes();
      ref.read(treatmentViewModelProvider.notifier).getTreatments(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientEmailController.dispose();
    _patientPhoneController.dispose();
    _practitionerSearchController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _discountController.dispose();
    _amountPaidController.dispose();
    _frontImageBeforeController.dispose();
    _frontImageAfterController.dispose();
    _rightImageBeforeController.dispose();
    _rightImageAfterController.dispose();
    _leftImageBeforeController.dispose();
    _leftImageAfterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentCreationProvider);
    final viewModel = ref.read(appointmentCreationProvider.notifier);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('New Appointment', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          _buildHeaderPanel(state, viewModel),
          Expanded(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPatientSection(state, viewModel),
                    SizedBox(height: context.h(24)),
                    _buildTreatmentSection(),
                    SizedBox(height: context.h(24)),
                    _buildPractitionerScheduleSection(),
                    SizedBox(height: context.h(24)),
                    _buildNotesFinancialsSection(),
                    SizedBox(height: context.h(24)),
                    _buildPaymentSection(),
                    SizedBox(height: context.h(24)),
                    _buildSimulationsSection(),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderPanel(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        backgroundColor: CustomColors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AdaptiveLayoutRowColumn(
              expandedWidget: false,
              alignment: MainAxisAlignment.spaceBetween,
              crossAlignment: CrossAxisAlignment.center,
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
                        Icons.calendar_month_outlined,
                        color: CustomColors.purple,
                      ),
                    ),
                    context.horizontalSpace(12),
                    SizedBox(
                      width: constraints.maxWidth * 0.55,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Appointment Creation',
                            style: context.fonts.black16w600,
                          ),
                          Text(
                            'Configure appointment patient details, selected treatments, practitioner, schedule, & payment details.',
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomOutlinedButton(
                      onTap: () => context.pop(),
                      label: 'Cancel',
                      height: context.h(40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    context.horizontalSpace(12),
                    CustomPrimaryButton(
                      onTap: () => _submitForm(state, viewModel),
                      label: 'Save Appointment',
                      height: context.h(40),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      icon: Icons.check_circle_outline,
                    ),
                  ],
                ),
              ],
            );
          },
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
          AdaptiveLayoutRowColumn(
            expandedWidget: false,
            alignment: MainAxisAlignment.spaceBetween,
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

  // Section 1: Patient Selection & Registration
  Widget _buildPatientSection(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    return _buildSection(
      title: 'Patient Selection',
      children: [
        BuildTextField(
          controller: _patientNameController,
          label: 'Full Name',
          hintText: 'Enter patient full name',
          prefixIcon: const Icon(Icons.person_outline, color: CustomColors.grey),
          onChanged: (val) => viewModel.searchPatients(val ?? ''),
        ),
        SizedBox(height: context.h(16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BuildTextField(
                controller: _patientEmailController,
                label: 'Email Address',
                hintText: 'Enter patient email address',
                prefixIcon: const Icon(Icons.email_outlined, color: CustomColors.grey),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number', style: context.fonts.black14w600),
                  context.verticalSpace(8),
                  PhoneWidget(
                    allowCountrySelection: true,
                    controller: _patientPhoneController,
                    filled: false,
                    onCountryChanged: (code) {
                      setState(() {
                        _selectedCountryCode = code.dialCode ?? '+1';
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(16)),
        Align(
          alignment: Alignment.centerRight,
          child: CustomPrimaryButton(
            onTap: () async {
              final email = _patientEmailController.text.trim();
              final phone = _patientPhoneController.text.trim();
              final userName = _patientNameController.text.trim();
              if (email.isEmpty && phone.isEmpty && userName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter patient details first.'),
                  ),
                );
                return;
              }
              final data = await viewModel.registerOrFetchPatient(
                email: email,
                phone: phone,
                userName: userName,
                cc: _selectedCountryCode,
              );
              if (data != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Patient details fetched successfully!',
                    ),
                  ),
                );
              }
            },
            label: 'Register or Fetch Detail',
            icon: Icons.person_add_alt_1_outlined,
            height: context.h(36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        if (state.selectedPatient != null) ...[
          SizedBox(height: context.h(16)),
          Text('Selected Patient', style: context.fonts.grey11w600ls12),
          SizedBox(height: context.h(10)),
          _buildPatientCard(state.selectedPatient!, true, viewModel, state),
        ],
        if (state.searchResults.isNotEmpty) ...[
          SizedBox(height: context.h(12)),
          Text('Search Results', style: context.fonts.grey11w600ls12),
          SizedBox(height: context.h(10)),
          ...state.searchResults
              .where((p) => p.id != state.selectedPatient?.id)
              .map((p) => _buildPatientCard(p, false, viewModel, state)),
        ],
      ],
    );
  }

  Widget _buildPatientCard(
    PatientModel patient,
    bool isSelected,
    AppointmentCreationViewModel viewModel,
    AppointmentCreationState state,
  ) {
    final bool showViewDetail = isSelected &&
        state.registeredPatientData != null &&
        state.registeredPatientData!.id == patient.id &&
        state.registeredPatientData!.detailAvailable == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          viewModel.selectPatient(patient);
          _patientNameController.text = patient.name;
          _patientEmailController.text = patient.email;
          _patientPhoneController.text = patient.phone;
        },
        borderRadius: BorderRadius.circular(context.r(12)),
        child: BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 14),
          borderColor: isSelected ? CustomColors.purple : CustomColors.border,
          borderWidth: isSelected ? 2 : 1,
          backgroundColor: isSelected
              ? CustomColors.purple.withValues(alpha: 0.04)
              : CustomColors.whiteGrey,
          child: Row(
            children: [
              CircleAvatar(
                radius: context.r(20),
                backgroundColor: CustomColors.palePurple,
                child: Text(
                  patient.name.isNotEmpty
                      ? patient.name[0].toUpperCase()
                      : 'P',
                  style: context.fonts.purple16w700,
                ),
              ),
              context.horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name.capitalize,
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(2),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: context.sp(14),
                          color: CustomColors.grey,
                        ),
                        context.horizontalSpace(4),
                        Text(patient.email, style: context.fonts.grey12w400),
                        context.horizontalSpace(14),
                        Icon(
                          Icons.phone_outlined,
                          size: context.sp(14),
                          color: CustomColors.grey,
                        ),
                        context.horizontalSpace(4),
                        Text(patient.phone, style: context.fonts.grey12w400),
                      ],
                    ),
                  ],
                ),
              ),
              if (showViewDetail) ...[
                CustomOutlinedButton(
                  onTap: () async {
                    final patientId = patient.id!;
                    final success = await ref
                        .read(patientProvider.notifier)
                        .getPatientDetail(patientId: patientId);
                    if (success && context.mounted) {
                      context.push(
                        PatientManagementDetailScreen.routeName,
                        extra: patientId,
                      );
                    }
                  },
                  label: 'View Detail',
                  height: context.h(36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                context.horizontalSpace(10),
              ],
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: CustomColors.purple)
              else
                Text('Select', style: context.fonts.purple12w700),
            ],
          ),
        ),
      ),
    );
  }

  // Section 2: Treatment & Services
  Widget _buildTreatmentSection() {
    final appointmentState = ref.watch(appointmentProvider);
    final rawAppointmentTypes = appointmentState.appointmentTypes ?? [];
    final uniqueFiltersMap = <int, Filters>{};
    for (final f in rawAppointmentTypes) {
      if (f.id != null) uniqueFiltersMap[f.id!] = f;
    }
    final appointmentTypes = uniqueFiltersMap.values.toList();

    Filters? selectedAppointmentType;
    if (appointmentTypes.isNotEmpty) {
      if (_selectedAppointmentTypeFilter != null) {
        selectedAppointmentType = appointmentTypes.firstWhere(
          (f) => f.id == _selectedAppointmentTypeFilter!.id,
          orElse: () => appointmentTypes.first,
        );
      } else {
        selectedAppointmentType = appointmentTypes.first;
      }
    }

    final treatmentState = ref.watch(treatmentViewModelProvider);
    final treatments = treatmentState.treatments;

    return _buildSection(
      title: 'Treatment & Services',
      children: [
        // Select Treatment Horizontal List
        Text('Select Treatment', style: context.fonts.black14w600),
        SizedBox(height: context.h(10)),
        if (treatmentState.loading && treatments.isEmpty)
          const Center(child: AppLoader())
        else if (treatments.isEmpty)
          Text('No treatments available.', style: context.fonts.grey14w400)
        else
          SizedBox(
            height: context.h(220),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: treatments.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: context.w(16)),
              itemBuilder: (context, index) {
                final treatment = treatments[index];
                final bool isSelected =
                    _selectedTreatments.any((t) => t.id == treatment.id);

                final dashboardTreatment = DashboardTreatmentModel(
                  id: treatment.id,
                  name: treatment.name,
                  shortDescription: treatment.shortDescription ??
                      treatment.description ??
                      '',
                  image: treatment.image,
                  icon: treatment.icon,
                  sku: treatment.globalSku,
                );

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(20)),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.purple
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: CustomColors.purple.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: TreatmentContainer(
                    onTap: () async {
                      final bool willBeSelected = !isSelected;
                      setState(() {
                        if (isSelected) {
                          _selectedTreatments.removeWhere(
                            (t) => t.id == treatment.id,
                          );
                          if (_selectedDropdownTreatment?.id == treatment.id) {
                            _selectedDropdownTreatment = null;
                          }
                        } else {
                          final existingAreas = _fetchedAreasMap[treatment.id]
                                  ?.map((a) => SideAreaModel(id: a.id, name: a.name))
                                  .toList() ??
                              (treatment.sideAreas ?? []);
                          final newTx = treatment.copyWith(sideAreas: existingAreas);
                          _selectedTreatments.add(newTx);
                          _selectedDropdownTreatment = newTx;
                        }
                      });

                      if (willBeSelected && treatment.id != null) {
                        if (!_fetchedAreasMap.containsKey(treatment.id)) {
                          setState(() {
                            _isFetchingAreas = true;
                          });
                          try {
                            final fetchedAreas = await ref
                                .read(areaViewModelProvider.notifier)
                                .fetchClinicAreas(
                                  treatmentId: treatment.id!,
                                  showLoading: false,
                                );
                            if (mounted) {
                              setState(() {
                                _fetchedAreasMap[treatment.id!] = fetchedAreas;
                                _isFetchingAreas = false;
                              });
                            }
                          } catch (_) {
                            if (mounted) {
                              setState(() {
                                _isFetchingAreas = false;
                              });
                            }
                          }
                        }
                      }
                    },
                    treatment: dashboardTreatment,
                    width: context.w(280),
                    imageHeight: context.h(220),
                  ),
                );
              },
            ),
          ),
        if (_selectedDropdownTreatment != null && _selectedDropdownTreatment!.id != null) ...[
          SizedBox(height: context.h(16)),
          Text(
            'Select Areas for ${_selectedDropdownTreatment!.name ?? ''}',
            style: context.fonts.black14w600,
          ),
          SizedBox(height: context.h(8)),
          if (_isFetchingAreas &&
              !_fetchedAreasMap.containsKey(_selectedDropdownTreatment!.id)) ...[
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: context.w(10)),
                Text('Fetching treatment areas...', style: context.fonts.grey12w400),
              ],
            ),
          ] else ...[
            Builder(
              builder: (context) {
                final currentTreatmentId = _selectedDropdownTreatment!.id!;
                final areasList = _fetchedAreasMap[currentTreatmentId] ??
                    (_selectedDropdownTreatment!.sideAreas
                            ?.map((sa) => AreaModel(
                                  id: sa.id ?? 0,
                                  name: sa.name ?? '',
                                  globalSku: '',
                                  icon: '',
                                  image: '',
                                ))
                            .toList() ??
                        []);

                if (areasList.isEmpty) {
                  return Text('No specific areas found for this treatment.',
                      style: context.fonts.grey12w400);
                }

                final currentTxIndex = _selectedTreatments.indexWhere(
                  (t) => t.id == currentTreatmentId,
                );
                final currentTx = currentTxIndex != -1
                    ? _selectedTreatments[currentTxIndex]
                    : null;

                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: areasList.map((area) {
                    final isAreaSelected = currentTx?.sideAreas?.any(
                          (a) => a.id == area.id,
                        ) ??
                        false;

                    return ChoiceChip(
                      label: Text(area.name.capitalize),
                      selected: isAreaSelected,
                      selectedColor: CustomColors.purple,
                      checkmarkColor: CustomColors.white,
                      labelStyle: context.fonts.black14w500.copyWith(
                        color:
                            isAreaSelected ? CustomColors.white : CustomColors.black,
                      ),
                      backgroundColor: CustomColors.whiteGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: context.appBorderRadius(all: 8),
                        side: BorderSide(
                          color: isAreaSelected
                              ? CustomColors.purple
                              : CustomColors.border,
                        ),
                      ),
                      onSelected: (selected) {
                        if (currentTxIndex == -1) return;
                        setState(() {
                          final currentAreas = List<SideAreaModel>.from(
                            _selectedTreatments[currentTxIndex].sideAreas ?? [],
                          );
                          if (selected) {
                            if (!currentAreas.any((a) => a.id == area.id)) {
                              currentAreas.add(
                                SideAreaModel(id: area.id, name: area.name),
                              );
                            }
                          } else {
                            currentAreas.removeWhere((a) => a.id == area.id);
                          }
                          _selectedTreatments[currentTxIndex] =
                              _selectedTreatments[currentTxIndex].copyWith(
                            sideAreas: currentAreas,
                          );
                        });
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
        SizedBox(height: context.h(20)),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<Filters>(
                label: 'Appointment Type',
                hintText: 'Select Type',
                value: selectedAppointmentType,
                items: appointmentTypes,
                onTap: () {
                  ref
                      .read(appointmentProvider.notifier)
                      .getAppointmentsTypes();
                },
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedAppointmentTypeFilter = val);
                  }
                },
                builder: (val) => Text(val.name ?? 'Type ${val.id}'),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _amountController,
                label: 'Treatment Total (\$)',
                hintText: '250.00',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, size: 18),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
        Text('Selected Treatments & Anatomical Areas',
            style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
        if (_selectedTreatments.isEmpty)
          Text('No treatments selected yet.', style: context.fonts.grey14w400)
        else
          SizedBox(
            height: context.h(220),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedTreatments.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: context.w(16)),
              itemBuilder: (context, index) {
                final treatment = _selectedTreatments[index];
                final areaNames = treatment.sideAreas != null &&
                        treatment.sideAreas!.isNotEmpty
                    ? treatment.sideAreas!
                        .map((a) => a.name ?? '')
                        .where((n) => n.isNotEmpty)
                        .join(', ')
                    : '';
                final shortDesc = areaNames.isNotEmpty
                    ? 'Areas: $areaNames'
                    : (treatment.shortDescription ??
                        treatment.description ??
                        '');

                final dashboardTreatment = DashboardTreatmentModel(
                  id: treatment.id,
                  name: treatment.name,
                  shortDescription: shortDesc,
                  image: treatment.image,
                  icon: treatment.icon,
                  sku: treatment.globalSku,
                );

                return Stack(
                  children: [
                    TreatmentContainer(
                      treatment: dashboardTreatment,
                      width: context.w(280),
                      imageHeight: context.h(220),
                    ),
                    Positioned(
                      top: context.h(8),
                      right: context.w(8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTreatments.removeAt(index);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  // Section 3: Practitioners & Clinical Schedule (Paginated & Searchable via fetchPractitioner API)
  Widget _buildPractitionerScheduleSection() {
    final practitionerState = ref.watch(practitionerProvider);
    final rawDoctors = practitionerState.doctors;
    final uniqueDoctorsMap = <int, PractitionerListItem>{};
    for (final d in rawDoctors) {
      uniqueDoctorsMap[d.id] = d;
    }
    final doctors = uniqueDoctorsMap.values.toList();

    PractitionerListItem? selectedDoctor;
    if (doctors.isNotEmpty) {
      if (_selectedPractitionerItem != null) {
        selectedDoctor = doctors.firstWhere(
          (doc) => doc.id == _selectedPractitionerItem!.id,
          orElse: () => doctors.first,
        );
      } else {
        selectedDoctor = doctors.first;
      }
    }

    return _buildSection(
      title: 'Practitioners & Clinical Schedule',
      trailing: CustomPrimaryButton(
        onTap: () {
          final targetDoc = selectedDoctor ?? _selectedPractitionerItem;
          if (targetDoc == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a practitioner first.'),
              ),
            );
            return;
          }
          final exists = _assignedPractitioners.any(
            (p) => p.id == targetDoc.id,
          );
          if (!exists) {
            setState(() {
              _assignedPractitioners.add(
                _AssignedPractitioner(
                  id: targetDoc.id,
                  name: targetDoc.name,
                  role: targetDoc.role?.isNotEmpty == true
                      ? targetDoc.role!
                      : 'doctor',
                ),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Practitioner already assigned to this appointment.'),
              ),
            );
          }
        },
        label: 'Add Practitioner',
        icon: Icons.person_add_alt_outlined,
        height: context.h(36),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSearchableDropdownField<PractitionerListItem>(
                label: 'Assigned Practitioner',
                hintText: 'Search or Select Practitioner',
                value: selectedDoctor,
                items: doctors,
                searchController: _practitionerSearchController,
                onSearchChanged: (query) {
                  ref.read(practitionerProvider.notifier).setSearchQuery(query);
                },
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPractitionerItem = val;
                    });
                  }
                },
                builder: (val) => Text(
                  val.name.isNotEmpty
                      ? '${val.name} (${val.email})'
                      : 'Practitioner ID: ${val.id}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: context.fonts.black14w400,
                ),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                child: IgnorePointer(
                  child: BuildTextField(
                    controller: _dateController,
                    label: 'Appointment Date',
                    hintText: 'YYYY-MM-DD',
                    readOnly: true,
                    prefixIcon:
                        const Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(12)),
        // Pagination & Search Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Page ${practitionerState.currentPage} of ${practitionerState.totalPages}',
              style: context.fonts.grey12w400,
            ),
            Row(
              children: [
                if (practitionerState.currentPage > 1)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(practitionerProvider.notifier).getPractitioner(
                            page: practitionerState.currentPage - 1,
                          );
                    },
                    icon: const Icon(Icons.arrow_back_ios, size: 12),
                    label: const Text('Prev Page'),
                  ),
                if (practitionerState.currentPage < practitionerState.totalPages)
                  TextButton.icon(
                    onPressed: () {
                      ref.read(practitionerProvider.notifier).getPractitioner(
                            page: practitionerState.currentPage + 1,
                          );
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 12),
                    label: const Text('Next Page'),
                  ),
              ],
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
        Text('Assigned Practitioners (${_assignedPractitioners.length})',
            style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
        if (_assignedPractitioners.isEmpty)
          Text('No practitioners assigned yet.',
              style: context.fonts.grey14w400)
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: _assignedPractitioners.map((practitioner) {
              return Container(
                padding: context.appEdgeInsets(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: CustomColors.lightPurple,
                  borderRadius: BorderRadius.circular(context.r(12)),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: context.sp(16),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(8),
                    Text(
                      '${practitioner.name} (${practitioner.role.capitalize})',
                      style: context.fonts.purple13w700,
                    ),
                    context.horizontalSpace(8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _assignedPractitioners.removeWhere(
                            (p) => p.id == practitioner.id,
                          );
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: CustomColors.purple,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        SizedBox(height: context.h(20)),
        Text('Available Time Slots', style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
        Wrap(
          spacing: context.w(12),
          runSpacing: context.h(12),
          children: _timeSlots.map((slot) {
            final isSelected = _selectedTimeSlot == slot;
            return FilterChip(
              label: Text(slot),
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  setState(() => _selectedTimeSlot = slot);
                }
              },
              selectedColor: CustomColors.purple,
              labelStyle: isSelected
                  ? context.fonts.white12w700
                  : context.fonts.black12w600,
              checkmarkColor: Colors.white,
              padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.r(20)),
                side: BorderSide(
                  color: isSelected
                      ? CustomColors.purple
                      : CustomColors.border,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Section 4: Notes & Booking Config
  Widget _buildNotesFinancialsSection() {
    return _buildSection(
      title: 'Booking Configuration & Clinical Notes',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Allowed Booking Method',
                hintText: 'Select Method',
                value: _bookingMethod,
                items: _bookingMethods,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _bookingMethod = val);
                  }
                },
                builder: (val) => Text(val.capitalize),
              ),
            ),
            SizedBox(width: context.w(16)),
            const Spacer(),
          ],
        ),
        SizedBox(height: context.h(20)),
        BuildTextField(
          controller: _notesController,
          label: 'Special Clinical Notes & Instructions',
          hintText:
              'Enter patient instructions, contraindications, or preparation notes...',
          maxLines: 3,
        ),
      ],
    );
  }

  // Section 5: Payment & Financial Details
  Widget _buildPaymentSection() {
    return _buildSection(
      title: 'Payment & Financial Details',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Payment Method',
                hintText: 'Select Payment Type',
                value: _paymentType,
                items: _paymentTypes,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _paymentType = val);
                  }
                },
                builder: (val) => Text(val.capitalize),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Payment Status',
                hintText: 'Select Status',
                value: _paymentStatus,
                items: _paymentStatuses,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _paymentStatus = val);
                  }
                },
                builder: (val) => Text(val.capitalize),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Discount Type',
                hintText: 'Select Discount Type',
                value: _discountType,
                items: _discountTypes,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _discountType = val);
                  }
                },
                builder: (val) => Text(val.capitalize),
              ),
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
        Row(
          children: [
            Expanded(
              child: BuildTextField(
                controller: _discountController,
                label: 'Discount Amount',
                hintText: '0',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.money_off, size: 18),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: BuildTextField(
                controller: _amountPaidController,
                label: 'Amount Paid (\$)',
                hintText: '12',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, size: 18),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Remaining Payable', style: context.fonts.black14w600),
                  SizedBox(height: context.h(8)),
                  Container(
                    height: context.h(52),
                    padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: BorderRadius.circular(context.r(12)),
                      border: Border.all(color: CustomColors.border),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Builder(
                      builder: (context) {
                        final total = double.tryParse(_amountController.text) ?? 250.0;
                        final disc = double.tryParse(_discountController.text) ?? 0.0;
                        final paid = double.tryParse(_amountPaidController.text) ?? 0.0;
                        final payable = (total - disc - paid).clamp(0.0, double.infinity);
                        return Text(
                          '\$${payable.toStringAsFixed(2)}',
                          style: context.fonts.purple14w700,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Section 6: Simulations (Optional)
  Widget _buildSimulationsSection() {
    return _buildSection(
      title: 'Simulations & Image Attachments',
      trailing: TextButton.icon(
        onPressed: () {
          setState(() {
            _showSimulationsSection = !_showSimulationsSection;
          });
        },
        icon: Icon(
          _showSimulationsSection
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
          color: CustomColors.purple,
        ),
        label: Text(
          _showSimulationsSection ? 'Hide Images' : 'Attach Image URLs',
          style: context.fonts.purple12w700,
        ),
      ),
      children: [
        if (!_showSimulationsSection)
          Text(
            'Click "Attach Image URLs" to optionally include simulation before/after image links.',
            style: context.fonts.grey14w400,
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  controller: _frontImageBeforeController,
                  label: 'Front Image Before URL',
                  hintText: 'https://...',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: BuildTextField(
                  controller: _frontImageAfterController,
                  label: 'Front Image After URL',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  controller: _rightImageBeforeController,
                  label: 'Right Image Before URL',
                  hintText: 'https://...',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: BuildTextField(
                  controller: _rightImageAfterController,
                  label: 'Right Image After URL',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          Row(
            children: [
              Expanded(
                child: BuildTextField(
                  controller: _leftImageBeforeController,
                  label: 'Left Image Before URL',
                  hintText: 'https://...',
                ),
              ),
              SizedBox(width: context.w(16)),
              Expanded(
                child: BuildTextField(
                  controller: _leftImageAfterController,
                  label: 'Left Image After URL',
                  hintText: 'https://...',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSearchableDropdownField<T>({
    required String label,
    required String hintText,
    required T? value,
    required List<T> items,
    required TextEditingController searchController,
    required ValueChanged<String> onSearchChanged,
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
            selectedItemBuilder: builder != null
                ? (context) => items
                    .map(
                      (item) => Align(
                        alignment: Alignment.centerLeft,
                        child: builder(item),
                      ),
                    )
                    .toList()
                : null,
            onChanged: onChanged,
            buttonStyleData: ButtonStyleData(
              height: context.h(52),
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(12)),
                border: Border.all(color: CustomColors.border),
              ),
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: searchController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Type to search practitioner...',
                    hintStyle: context.fonts.grey12w400,
                    prefixIcon: const Icon(Icons.search, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
              searchMatchFn: (item, searchValue) {
                if (item.value is PractitionerListItem) {
                  final doc = item.value as PractitionerListItem;
                  final query = searchValue.toLowerCase();
                  return doc.name.toLowerCase().contains(query) ||
                      doc.email.toLowerCase().contains(query) ||
                      doc.specialization.toLowerCase().contains(query);
                }
                return item.value
                        ?.toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase()) ??
                    false;
              },
            ),
          ),
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
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w600),
        SizedBox(height: context.h(8)),
        InkWell(
          onTap: onTap,
          child: DropdownButtonHideUnderline(
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
        ),
      ],
    );
  }

  void _submitForm(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    if (!_formKey.currentState!.validate()) return;

    if (state.selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient.')),
      );
      return;
    }

    if (_assignedPractitioners.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please assign at least one practitioner.')),
      );
      return;
    }

    final selectedDate =
        DateTime.tryParse(_dateController.text) ?? DateTime.now();
    final dateTimestamp = selectedDate.millisecondsSinceEpoch ~/ 1000;
    final startTimeStamp =
        selectedDate.add(const Duration(hours: 10)).millisecondsSinceEpoch ~/ 1000;
    final endTimeStamp =
        selectedDate.add(const Duration(hours: 11)).millisecondsSinceEpoch ~/ 1000;

    final double totalCost = double.tryParse(_amountController.text) ?? 250.0;
    final double discountVal =
        double.tryParse(_discountController.text) ?? 0.0;
    final double paidVal = double.tryParse(_amountPaidController.text) ?? 12.0;
    final double calculatedPayable =
        (totalCost - discountVal - paidVal).clamp(0.0, double.infinity);

    final request = CreateAppointmentRequest(
      practitioners: _assignedPractitioners.map((p) {
        return AppointmentPractitionerRequest(
          id: p.id,
          role: p.role,
        );
      }).toList(),
      patientId: state.selectedPatient?.id ?? 12,
      date: dateTimestamp,
      startTime: startTimeStamp,
      endTime: endTimeStamp,
      appointmentTypeId: _selectedAppointmentTypeFilter?.id ?? 1,
      bookingType: _bookingMethod,
      simulations: AppointmentSimulationsRequest(
        frontImageBefore: _frontImageBeforeController.text.trim(),
        frontImageAfter: _frontImageAfterController.text.trim(),
        rightImageBefore: _rightImageBeforeController.text.trim(),
        rightImageAfter: _rightImageAfterController.text.trim(),
        leftImageBefore: _leftImageBeforeController.text.trim(),
        leftImageAfter: _leftImageAfterController.text.trim(),
      ),
      treatment: _selectedTreatments.map((t) {
        return AppointmentTreatmentItemRequest(
          treatmentId: t.id ?? 3,
          areaId:
              t.sideAreas?.isNotEmpty == true ? t.sideAreas!.first.id ?? 7 : 7,
          treatmentCost: (t.price ?? 250).toDouble(),
          material: AppointmentMaterialItemRequest(
            id: 10,
            selectedQuantity: 2,
          ),
        );
      }).toList(),
      treatmentTotal: totalCost,
      paymentType: AppointmentPaymentTypeRequest(
        type: _paymentType,
        status: _paymentStatus,
      ),
      discountType: _discountType,
      discount: discountVal,
      amountPaid: paidVal,
      payable: calculatedPayable,
    );

    viewModel.createAppointment(request: request).then((success) {
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment created successfully!'),
            backgroundColor: CustomColors.purple,
          ),
        );
        context.pop();
      }
    });
  }
}

class _AssignedPractitioner {
  final int id;
  final String name;
  final String role;

  _AssignedPractitioner({
    required this.id,
    required this.name,
    required this.role,
  });
}
