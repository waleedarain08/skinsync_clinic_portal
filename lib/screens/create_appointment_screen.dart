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
import '../view_models/provider_view_model.dart';
import '../view_models/treatment_view_model.dart';
import '../models/responses/area_list_response.dart';
import '../models/responses/booking_methods_response.dart';
import '../models/responses/session_materials_response.dart';
import '../models/requests/treatment_cost_request.dart';
import '../view_models/area_view_model.dart';
import 'dashboard/patient_management_detail.dart';
import '../widgets/app_loader.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/number_paginator.dart';
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
  static final Filters _allRoleFilter =
      Filters(id: 0, name: 'All');
  Filters? _selectedRoleFilter = _allRoleFilter;
  TreatmentModel? _selectedDropdownTreatment;

  final List<TreatmentModel> _selectedTreatments = [];
  final Map<int, List<AreaModel>> _fetchedAreasMap = {};
  bool _isFetchingAreas = false;

  // Session materials state
  final Map<String, List<SessionMaterialData>> _sessionMaterialsMap = {};
  final Map<String, bool> _fetchingSessionMaterialsMap = {};
  final Map<String, SessionMaterialData?> _selectedSessionMap = {};
  final Map<String, MaterialItem?> _selectedMaterialMap = {};
  final Map<String, int> _selectedMaterialQtyMap = {};

  // Treatment cost state
  final Map<String, num?> _treatmentCostMap = {};
  final Map<String, bool> _fetchingTreatmentCostMap = {};

  // Section 3: Practitioners & Clinical Schedule (Paginated & Searchable via fetchPractitioner API)
  final _practitionerSearchController = TextEditingController();
  PractitionerListItem? _selectedPractitionerItem;

  final List<_AssignedPractitioner> _assignedPractitioners = [];

  final _dateController = TextEditingController();
  String? _selectedTimeSlot;
  final List<String> _timeSlots = [
    '09:00',
    '10:00',
    '11:30',
    '13:00',
    '14:30',
    '16:00',
    '17:30',
    '19:00',
  ];

  // Section 4: Notes & Booking Config
  String _bookingMethod = 'online';
  final _notesController = TextEditingController();

  // Section 5: Financials & Payment Details
  final _amountController = TextEditingController(text: '0.00');
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
      ref.read(appointmentProvider.notifier).getAppointmentsTypes();
      ref.read(treatmentViewModelProvider.notifier).getTreatments(isRefresh: true);
      ref.read(appointmentCreationProvider.notifier).fetchBookingMethods();
      ref.read(providerRoleViewModelProvider.notifier).fetchProviderRoles();
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
                    SizedBox(height: context.h(32)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomOutlinedButton(
                          onTap: () => context.pop(),
                          label: 'Cancel',
                          height: context.h(42),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        context.horizontalSpace(16),
                        CustomPrimaryButton(
                          onTap: () => _submitForm(state, viewModel),
                          label: 'Save Appointment',
                          height: context.h(42),
                          width: context.w(200),
                          icon: Icons.check_circle_outline,
                        ),
                      ],
                    ),
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
                    removeValidation: state.selectedPatient != null,
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
                          final newTx = treatment.copyWith(sideAreas: []);
                          _selectedTreatments.add(newTx);
                          _selectedDropdownTreatment = newTx;
                        }
                        _updateTotalAmount();
                        _fetchFilteredPractitioners();
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
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
                            color: isAreaSelected
                                ? CustomColors.white
                                : CustomColors.black,
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

                            if (selected) {
                              _fetchSessionMaterials(currentTreatmentId, area.id);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    if (currentTx != null &&
                        currentTx.sideAreas != null &&
                        currentTx.sideAreas!.isNotEmpty) ...[
                      SizedBox(height: context.h(12)),
                      ...currentTx.sideAreas!.map((selectedArea) {
                        return _buildSessionsAndMaterialsSection(
                          currentTreatmentId,
                          selectedArea,
                        );
                      }),
                    ],
                  ],
                );
              },
            ),
          ],
        ],
        SizedBox(height: context.h(20)),
        Text('Selected Treatments & Anatomical Areas',
            style: context.fonts.grey11w600ls12),
        SizedBox(height: context.h(12)),
        Builder(
          builder: (context) {
            final List<({TreatmentModel treatment, SideAreaModel? area})>
                flattenedItems = [];
            for (final tx in _selectedTreatments) {
              if (tx.sideAreas != null && tx.sideAreas!.isNotEmpty) {
                for (final area in tx.sideAreas!) {
                  flattenedItems.add((treatment: tx, area: area));
                }
              } else {
                flattenedItems.add((treatment: tx, area: null));
              }
            }

            if (flattenedItems.isEmpty) {
              return Text('No treatments selected yet.',
                  style: context.fonts.grey14w400);
            }

            return Wrap(
              spacing: context.w(12),
              runSpacing: context.h(12),
              children: flattenedItems.map((item) {
                final tx = item.treatment;
                final area = item.area;
                final key = area != null ? '${tx.id}-${area.id}' : '';
                final selectedSession = _selectedSessionMap[key];
                final selectedMat = _selectedMaterialMap[key];
                final selectedQty = _selectedMaterialQtyMap[key];

                String displayText = tx.name ?? '';
                if (area != null) {
                  displayText += ' - ${area.name}';
                  if (selectedSession != null) {
                    displayText += ' (${selectedSession.sessionName})';
                  }
                  if (selectedMat != null && selectedQty != null && selectedQty > 0) {
                    displayText += ' [${selectedMat.unitType}: $selectedQty]';
                  }
                }

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
                        Icons.medical_services_outlined,
                        size: context.sp(16),
                        color: CustomColors.purple,
                      ),
                      context.horizontalSpace(8),
                      Text(
                        displayText,
                        style: context.fonts.purple13w700,
                      ),
                      context.horizontalSpace(8),
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (area != null) {
                              final txIndex = _selectedTreatments
                                  .indexWhere((t) => t.id == tx.id);
                              if (txIndex != -1) {
                                final updatedAreas = List<SideAreaModel>.from(
                                  _selectedTreatments[txIndex].sideAreas ?? [],
                                );
                                updatedAreas.removeWhere((a) => a.id == area.id);
                                _selectedTreatments[txIndex] =
                                    _selectedTreatments[txIndex].copyWith(
                                  sideAreas: updatedAreas,
                                );
                              }
                            } else {
                              _selectedTreatments
                                  .removeWhere((t) => t.id == tx.id);
                            }
                            _updateTotalAmount();
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
            );
          },
        ),
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
                hintText: '0.00',
                readOnly: true,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _fetchFilteredPractitioners({
    int page = 1,
    String? searchOverride,
    Filters? roleOverride,
    String? dateOverride,
  }) {
    final search = searchOverride ?? _practitionerSearchController.text.trim();
    final selectedRole = roleOverride ?? _selectedRoleFilter;
    final role = (selectedRole == null || selectedRole.id == 0)
        ? ''
        : (selectedRole.name ?? '');
    final dateStr = dateOverride ?? _dateController.text.trim();
    final parsedDate = dateStr.isNotEmpty ? DateTime.tryParse(dateStr) : null;
    final dateTs =
        parsedDate != null ? (parsedDate.millisecondsSinceEpoch ~/ 1000) : null;
    final treatmentId = _selectedDropdownTreatment?.id ??
        (_selectedTreatments.isNotEmpty ? _selectedTreatments.first.id : null);

    ref.read(practitionerProvider.notifier).getPractitioner(
          page: page,
          search: search,
          role: role,
          treatmentId: treatmentId,
          date: dateTs,
        );
  }

  Widget _buildDateField() {
    final bool hasDate = _dateController.text.isNotEmpty;

    return BuildTextField(
      controller: _dateController,
      label: 'Select Date',
      hintText: 'YYYY-MM-DD',
      readOnly: true,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          final newDateStr = DateFormat('yyyy-MM-dd').format(picked);
          setState(() {
            _dateController.text = newDateStr;
          });
          _fetchFilteredPractitioners(dateOverride: newDateStr);
        }
      },
      prefixIcon: const Icon(
        Icons.calendar_today_outlined,
        size: 18,
        color: CustomColors.purple,
      ),
      suffixIcon: hasDate
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                size: 18,
                color: CustomColors.purple,
              ),
              onPressed: () {
                setState(() {
                  _dateController.clear();
                  _selectedTimeSlot = null;
                });
                _fetchFilteredPractitioners(dateOverride: '');
              },
            )
          : null,
    );
  }

  // Section 3: Practitioners & Clinical Schedule (Paginated & Searchable via fetchPractitioner API)
  Widget _buildPractitionerScheduleSection() {
    final practitionerState = ref.watch(practitionerProvider);
    final providerRoleState = ref.watch(providerRoleViewModelProvider);
    final apiRoles = providerRoleState.providerRoles ?? [];
    final List<Filters> providerRoles = [
      _allRoleFilter,
      ...apiRoles.where((r) => r.name?.toLowerCase() != 'all'),
    ];

    final rawDoctors = practitionerState.doctors;
    final uniqueDoctorsMap = <int, PractitionerListItem>{};
    for (final d in rawDoctors) {
      uniqueDoctorsMap[d.id] = d;
    }
    final doctors = uniqueDoctorsMap.values.toList();

    return _buildSection(
      title: 'Practitioners & Clinical Schedule',
      children: [
        // Top controls: Search Practitioner, Select Date, Select Role
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BuildTextField(
                      controller: _practitionerSearchController,
                      label: 'Search Practitioner',
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      onChanged: (val) {
                        _fetchFilteredPractitioners(searchOverride: val ?? '');
                      },
                    ),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: _buildDateField(),
                  ),
                  SizedBox(width: context.w(16)),
                  Expanded(
                    child: _buildDropdownField<Filters>(
                      label: 'Select Role',
                      hintText: 'Select Role',
                      value: _selectedRoleFilter,
                      items: providerRoles,
                      onTap: () {
                        ref
                            .read(providerRoleViewModelProvider.notifier)
                            .fetchProviderRoles();
                      },
                      onChanged: (val) {
                        setState(() => _selectedRoleFilter = val);
                        _fetchFilteredPractitioners(roleOverride: val);
                      },
                      builder: (val) => Text(val.name ?? 'Role ${val.id}'),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildTextField(
                    controller: _practitionerSearchController,
                    label: 'Search Practitioner',
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    onChanged: (val) {
                      _fetchFilteredPractitioners(searchOverride: val ?? '');
                    },
                  ),
                  SizedBox(height: context.h(16)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDateField(),
                      ),
                      SizedBox(width: context.w(16)),
                      Expanded(
                        child: _buildDropdownField<Filters>(
                          label: 'Select Role',
                          hintText: 'Select Role',
                          value: _selectedRoleFilter,
                          items: providerRoles,
                          onTap: () {
                            ref
                                .read(providerRoleViewModelProvider.notifier)
                                .fetchProviderRoles();
                          },
                          onChanged: (val) {
                            setState(() => _selectedRoleFilter = val);
                            _fetchFilteredPractitioners(roleOverride: val);
                          },
                          builder: (val) => Text(val.name ?? 'Role ${val.id}'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        SizedBox(height: context.h(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Select Practitioner', style: context.fonts.black14w600),
            if (practitionerState.totalPages > 0)
              NumberPaginator(
                totalPages: practitionerState.totalPages,
                currentPage: (practitionerState.currentPage - 1).clamp(
                  0,
                  practitionerState.totalPages > 0
                      ? practitionerState.totalPages - 1
                      : 0,
                ),
                onPageChanged: (pageIndex) {
                  _fetchFilteredPractitioners(page: pageIndex + 1);
                },
              ),
          ],
        ),
        SizedBox(height: context.h(10)),
        if (practitionerState.loading && doctors.isEmpty)
          const Center(child: AppLoader())
        else if (doctors.isEmpty)
          Text('No practitioners available. Search, select a date or role to view practitioners.',
              style: context.fonts.grey14w400)
        else
          SizedBox(
            height: context.h(130),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: context.w(16)),
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                final bool isSelected =
                    _selectedPractitionerItem?.id == doctor.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedPractitionerItem = null;
                        _assignedPractitioners.clear();
                      } else {
                        _selectedPractitionerItem = doctor;
                        _assignedPractitioners.clear();
                        _assignedPractitioners.add(
                          _AssignedPractitioner(
                            id: doctor.id,
                            name: doctor.name,
                            role: doctor.role?.isNotEmpty == true
                                ? doctor.role!
                                : 'doctor',
                          ),
                        );
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: context.w(240),
                    padding: context.appEdgeInsets(all: 12),
                    decoration: BoxDecoration(
                      color: CustomColors.white,
                      borderRadius: BorderRadius.circular(context.r(16)),
                      border: Border.all(
                        color: isSelected
                            ? CustomColors.purple
                            : CustomColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color:
                                    CustomColors.purple.withValues(alpha: 0.2),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: CustomColors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: context.r(26),
                              backgroundColor:
                                  CustomColors.purple.withValues(alpha: 0.1),
                              backgroundImage: doctor.image.isNotEmpty
                                  ? NetworkImage(doctor.image)
                                  : null,
                              child: doctor.image.isEmpty
                                  ? Icon(
                                      Icons.person_outline,
                                      color: CustomColors.purple,
                                      size: context.sp(24),
                                    )
                                  : null,
                            ),
                            if (isSelected)
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: CustomColors.purple,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name.isNotEmpty
                                    ? doctor.name
                                    : 'Practitioner ID: ${doctor.id}',
                                style: context.fonts.black14w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                doctor.specialization.isNotEmpty
                                    ? doctor.specialization
                                    : (doctor.role?.capitalize ?? 'Doctor'),
                                style: context.fonts.grey12w400,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (doctor.email.isNotEmpty) ...[
                                SizedBox(height: context.h(2)),
                                Text(
                                  doctor.email,
                                  style: context.fonts.grey12w400.copyWith(
                                    fontSize: 11.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Available Time Slots (Appears when Date is selected)
        if (_dateController.text.isNotEmpty) ...[
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
                    ? context.fonts.black14w500.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      )
                    : context.fonts.black14w500.copyWith(
                        color: Colors.black,
                        fontSize: 12.sp,
                      ),
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
      ],
    );
  }

  // Section 4: Notes & Booking Config
  Widget _buildNotesFinancialsSection() {
    final state = ref.watch(appointmentCreationProvider);
    final bookingMethods = state.bookingMethods;

    if (bookingMethods.isNotEmpty &&
        !bookingMethods.any((m) => m.key == _bookingMethod)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _bookingMethod = bookingMethods.first.key;
          });
        }
      });
    }

    return _buildSection(
      title: 'Booking Configuration & Clinical Notes',
      children: [
        Text('Allowed Booking Method', style: context.fonts.black14w600),
        SizedBox(height: context.h(10)),
        if (state.isFetchingBookingMethods && bookingMethods.isEmpty)
          const Center(child: AppLoader())
        else if (bookingMethods.isEmpty)
          Text('No booking methods available.', style: context.fonts.grey14w400)
        else
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: bookingMethods.map((method) {
              return _buildBookingMethodCard(method: method);
            }).toList(),
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

  Widget _buildBookingMethodCard({
    required BookingMethodItem method,
  }) {
    final title = method.title;
    final keyName = method.key;
    final description = method.description;
    final iconUrl = method.icon;
    final isSelected = _bookingMethod == keyName;

    return GestureDetector(
      onTap: () {
        setState(() {
          _bookingMethod = keyName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: context.w(280),
        padding: context.appEdgeInsets(all: 12),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(16)),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CustomColors.purple.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: CustomColors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (iconUrl.isNotEmpty) ...[
                      Image.network(
                        iconUrl,
                        width: context.w(22),
                        height: context.h(22),
                        errorBuilder: (context, error, stackTrace) => Icon(
                          keyName == 'online'
                              ? Icons.language
                              : Icons.directions_walk,
                          size: context.sp(20),
                          color: CustomColors.purple,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                    ] else ...[
                      Icon(
                        keyName == 'online'
                            ? Icons.language
                            : Icons.directions_walk,
                        size: context.sp(20),
                        color: CustomColors.purple,
                      ),
                      SizedBox(width: context.w(8)),
                    ],
                    Text(
                      title,
                      style: context.fonts.black14w600,
                    ),
                  ],
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: CustomColors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            if (description.isNotEmpty) ...[
              SizedBox(height: context.h(8)),
              Text(
                description,
                style: context.fonts.grey12w400,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
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

  Widget _buildDropdownField<T>({
    required String label,
    required String hintText,
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    Widget Function(T)? builder,
    VoidCallback? onTap,
  }) {
    T? validValue;
    if (value != null && items.isNotEmpty) {
      try {
        validValue = items.firstWhere((item) => item == value);
      } catch (_) {
        validValue = null;
      }
    }

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
            value: validValue,
            onMenuStateChange: (isOpen) {
              if (isOpen && onTap != null) {
                onTap();
              }
            },
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

  Future<void> _fetchSessionMaterials(int treatmentId, int areaId) async {
    final key = '$treatmentId-$areaId';
    if (_sessionMaterialsMap.containsKey(key) ||
        (_fetchingSessionMaterialsMap[key] ?? false)) {
      return;
    }

    setState(() {
      _fetchingSessionMaterialsMap[key] = true;
    });

    try {
      final materials = await ref
          .read(areaViewModelProvider.notifier)
          .fetchSessionMaterials(
            treatmentId: treatmentId,
            areaId: areaId,
            showLoading: false,
          );

      if (mounted) {
        setState(() {
          _sessionMaterialsMap[key] = materials;
          _fetchingSessionMaterialsMap[key] = false;
          if (materials.isNotEmpty) {
            final firstSession = materials.first;
            _selectedSessionMap[key] = firstSession;
            if (firstSession.material.isNotEmpty) {
              final firstMat = firstSession.material.first;
              _selectedMaterialMap[key] = firstMat;
              _selectedMaterialQtyMap[key] = firstMat.maxQty;
            } else {
              _selectedMaterialMap[key] = null;
              _selectedMaterialQtyMap[key] = 0;
            }
          }
        });

        if (materials.isNotEmpty) {
          _calculateTreatmentCost(treatmentId, areaId);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _fetchingSessionMaterialsMap[key] = false;
        });
      }
    }
  }

  double get _calculatedTotalTreatmentCost {
    double total = 0.0;
    for (final tx in _selectedTreatments) {
      if (tx.sideAreas != null && tx.sideAreas!.isNotEmpty) {
        for (final area in tx.sideAreas!) {
          final key = '${tx.id}-${area.id}';
          final cost = _treatmentCostMap[key];
          if (cost != null) {
            total += cost.toDouble();
          } else if (tx.price != null) {
            total += tx.price!.toDouble();
          }
        }
      } else if (tx.price != null) {
        total += tx.price!.toDouble();
      }
    }
    return total;
  }

  void _updateTotalAmount() {
    final total = _calculatedTotalTreatmentCost;
    _amountController.text = total.toStringAsFixed(2);
  }

  Future<void> _calculateTreatmentCost(int treatmentId, int areaId) async {
    final key = '$treatmentId-$areaId';
    final selectedSession = _selectedSessionMap[key];
    if (selectedSession == null) return;

    final selectedMat = _selectedMaterialMap[key];
    final selectedQty =
        _selectedMaterialQtyMap[key] ?? selectedMat?.maxQty ?? 1;

    final materialReq = [
      TreatmentCostMaterialRequest(
        id: selectedMat?.id ?? 0,
        selectedQuantity: selectedQty,
      ),
    ];

    final request = TreatmentCostRequest(
      treatmentId: treatmentId,
      areaId: areaId,
      sessionId: selectedSession.sessionId,
      material: materialReq,
    );

    setState(() {
      _fetchingTreatmentCostMap[key] = true;
    });

    try {
      final cost = await ref
          .read(areaViewModelProvider.notifier)
          .calculateTreatmentCost(request: request, showLoading: false);

      if (mounted) {
        setState(() {
          _treatmentCostMap[key] = cost;
          _fetchingTreatmentCostMap[key] = false;
        });
        _updateTotalAmount();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _fetchingTreatmentCostMap[key] = false;
        });
      }
    }
  }

  Future<void> _showQuantitySliderDialog({
    required String key,
    required MaterialItem material,
  }) async {
    int currentQty = _selectedMaterialQtyMap[key] ?? material.maxQty;
    if (currentQty < material.minQty) currentQty = material.minQty;
    if (currentQty > material.maxQty) currentQty = material.maxQty;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final int min = material.minQty;
            final int max = material.maxQty;
            final int divisions = (max - min) > 0 ? (max - min) : 1;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              title: Text(
                'Select Quantity for ${material.unitType}',
                style: context.fonts.black16w600,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Quantity: $currentQty',
                    style: context.fonts.black18w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                  SizedBox(height: context.h(16)),
                  Slider(
                    value: currentQty.toDouble(),
                    min: min.toDouble(),
                    max: max.toDouble(),
                    divisions: divisions,
                    activeColor: CustomColors.purple,
                    inactiveColor: CustomColors.lightPurple,
                    label: '$currentQty',
                    onChanged: (val) {
                      setDialogState(() {
                        currentQty = val.round();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Min: $min', style: context.fonts.grey12w400),
                        Text('Max: $max', style: context.fonts.grey12w400),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text('Cancel', style: context.fonts.grey14w400),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedMaterialMap[key] = material;
                      _selectedMaterialQtyMap[key] = currentQty;
                    });
                    final parts = key.split('-');
                    if (parts.length == 2) {
                      final tId = int.tryParse(parts[0]);
                      final aId = int.tryParse(parts[1]);
                      if (tId != null && aId != null) {
                        _calculateTreatmentCost(tId, aId);
                      }
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSessionsAndMaterialsSection(
      int treatmentId, SideAreaModel area) {
    final areaId = area.id;
    if (areaId == null) return const SizedBox.shrink();
    final key = '$treatmentId-$areaId';

    final isLoading = _fetchingSessionMaterialsMap[key] ?? false;
    final sessions = _sessionMaterialsMap[key] ?? [];
    final selectedSession = _selectedSessionMap[key];
    final selectedMaterial = _selectedMaterialMap[key];

    return Container(
      margin: EdgeInsets.only(top: context.h(8)),
      padding: context.appEdgeInsets(all: 12),
      decoration: BoxDecoration(
        color: CustomColors.lightPurple.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: context.sp(16),
                    color: CustomColors.purple,
                  ),
                  SizedBox(width: context.w(8)),
                  Text(
                    'Sessions & Materials for ${area.name ?? ''}',
                    style: context.fonts.black14w600,
                  ),
                ],
              ),
              if (_fetchingTreatmentCostMap[key] == true) ...[
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ] else if (_treatmentCostMap[key] != null) ...[
                Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(8)),
                    border: Border.all(
                      color: CustomColors.purple.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Cost: \$${_treatmentCostMap[key]}',
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: context.h(8)),
          if (isLoading) ...[
            Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: context.w(8)),
                Text(
                  'Fetching sessions for ${area.name}...',
                  style: context.fonts.grey12w400,
                ),
              ],
            ),
          ] else if (sessions.isEmpty) ...[
            Text(
              'No sessions or materials found for ${area.name}.',
              style: context.fonts.grey12w400,
            ),
          ] else ...[
            Text(
              'Select Session:',
              style: context.fonts.grey12w600,
            ),
            SizedBox(height: context.h(6)),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: sessions.map((session) {
                final isSessionSelected =
                    selectedSession?.sessionId == session.sessionId;
                return ChoiceChip(
                  label: Text(session.sessionName),
                  selected: isSessionSelected,
                  selectedColor: CustomColors.purple,
                  checkmarkColor: CustomColors.white,
                  labelStyle: context.fonts.black14w500.copyWith(
                    fontSize: 12.sp,
                    color: isSessionSelected
                        ? CustomColors.white
                        : CustomColors.black,
                  ),
                  backgroundColor: CustomColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.appBorderRadius(all: 6),
                    side: BorderSide(
                      color: isSessionSelected
                          ? CustomColors.purple
                          : CustomColors.border,
                    ),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedSessionMap[key] = session;
                        if (session.material.isNotEmpty) {
                          final firstMat = session.material.first;
                          _selectedMaterialMap[key] = firstMat;
                          _selectedMaterialQtyMap[key] = firstMat.maxQty;
                        } else {
                          _selectedMaterialMap[key] = null;
                          _selectedMaterialQtyMap[key] = 0;
                        }
                      });
                      _calculateTreatmentCost(treatmentId, areaId);
                    }
                  },
                );
              }).toList(),
            ),
            if (selectedSession != null &&
                selectedSession.material.isNotEmpty) ...[
              SizedBox(height: context.h(10)),
              Text(
                'Session Materials:',
                style: context.fonts.grey12w600,
              ),
              SizedBox(height: context.h(6)),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: selectedSession.material.map((mat) {
                  final isMatSelected = selectedMaterial?.id == mat.id;
                  final bool hasRange = mat.minQty < mat.maxQty;

                  return ChoiceChip(
                    label: Text(
                      '${mat.unitType} (Min: ${mat.minQty}, Max: ${mat.maxQty})',
                    ),
                    selected: isMatSelected,
                    selectedColor: CustomColors.purple,
                    checkmarkColor: CustomColors.white,
                    labelStyle: context.fonts.black14w500.copyWith(
                      fontSize: 12.sp,
                      color: isMatSelected
                          ? CustomColors.white
                          : CustomColors.black,
                    ),
                    backgroundColor: CustomColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.appBorderRadius(all: 6),
                      side: BorderSide(
                        color: isMatSelected
                            ? CustomColors.purple
                            : CustomColors.border,
                      ),
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedMaterialMap[key] = mat;
                        if (_selectedMaterialQtyMap[key] == null ||
                            _selectedMaterialMap[key]?.id != mat.id) {
                          _selectedMaterialQtyMap[key] = mat.maxQty;
                        }
                      });

                      _calculateTreatmentCost(treatmentId, areaId);

                      if (hasRange) {
                        _showQuantitySliderDialog(key: key, material: mat);
                      }
                    },
                  );
                }).toList(),
              ),
              if (selectedMaterial != null) ...[
                SizedBox(height: context.h(10)),
                Builder(
                  builder: (context) {
                    final bool hasRange =
                        selectedMaterial.minQty < selectedMaterial.maxQty;
                    final currentQty =
                        _selectedMaterialQtyMap[key] ?? selectedMaterial.maxQty;

                    return Container(
                      padding: context.appEdgeInsets(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(context.r(8)),
                        border: Border.all(
                          color: CustomColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Selected Quantity: ',
                                style: context.fonts.grey12w400,
                              ),
                              Text(
                                '$currentQty ${selectedMaterial.unitType}',
                                style: context.fonts.black14w600.copyWith(
                                  color: CustomColors.purple,
                                ),
                              ),
                            ],
                          ),
                          if (hasRange) ...[
                            InkWell(
                              onTap: () {
                                _showQuantitySliderDialog(
                                  key: key,
                                  material: selectedMaterial,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(12),
                                  vertical: context.h(6),
                                ),
                                decoration: BoxDecoration(
                                  color: CustomColors.purple,
                                  borderRadius: BorderRadius.circular(
                                    context.r(6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.tune,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: context.w(4)),
                                    Text(
                                      'Select Quantity',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ],
        ],
      ),
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
      if (_selectedPractitionerItem != null) {
        _assignedPractitioners.add(
          _AssignedPractitioner(
            id: _selectedPractitionerItem!.id,
            name: _selectedPractitionerItem!.name,
            role: _selectedPractitionerItem!.role?.isNotEmpty == true
                ? _selectedPractitionerItem!.role!
                : 'doctor',
          ),
        );
      }
    }

    if (_assignedPractitioners.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a practitioner.')),
      );
      return;
    }

    if (_dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an appointment date.')),
      );
      return;
    }

    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an available time slot.')),
      );
      return;
    }

    final selectedDate =
        DateTime.tryParse(_dateController.text) ?? DateTime.now();
    int hour = 10;
    int minute = 0;
    if (_selectedTimeSlot != null) {
      try {
        final parts = _selectedTimeSlot!.split(':');
        if (parts.length == 2) {
          hour = int.parse(parts[0]);
          minute = int.parse(parts[1]);
        }
      } catch (_) {}
    }
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
    final endDateTime = startDateTime.add(const Duration(hours: 1));
    final int dateTimestamp =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day)
                .millisecondsSinceEpoch ~/
            1000;
    final int startTimeStamp = startDateTime.millisecondsSinceEpoch ~/ 1000;
    final int endTimeStamp = endDateTime.millisecondsSinceEpoch ~/ 1000;

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
      treatment: () {
        final List<AppointmentTreatmentItemRequest> items = [];
        for (final t in _selectedTreatments) {
          final cost = (t.price ?? totalCost).toDouble();

          if (t.sideAreas != null && t.sideAreas!.isNotEmpty) {
            for (final area in t.sideAreas!) {
              final key = '${t.id}-${area.id}';
              final selectedSession = _selectedSessionMap[key];
              final selectedMat = _selectedMaterialMap[key];
              final selectedQty =
                  _selectedMaterialQtyMap[key] ?? selectedMat?.minQty ?? 1;

              final materialReq = AppointmentMaterialItemRequest(
                id: selectedMat?.id ?? 0,
                selectedQuantity: selectedQty,
              );

              items.add(
                AppointmentTreatmentItemRequest(
                  treatmentId: t.id,
                  areaId: area.id,
                  sessionId: selectedSession?.sessionId ?? 0,
                  treatmentCost: cost,
                  material: materialReq,
                ),
              );
            }
          } else {
            final defaultMaterial = AppointmentMaterialItemRequest(
              id: 0,
              selectedQuantity: 1,
            );
            items.add(
              AppointmentTreatmentItemRequest(
                treatmentId: t.id,
                areaId: 0,
                sessionId: 0,
                treatmentCost: cost,
                material: defaultMaterial,
              ),
            );
          }
        }
        return items;
      }(),
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
