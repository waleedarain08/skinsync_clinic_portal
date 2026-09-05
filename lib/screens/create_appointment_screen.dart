import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/patient_model.dart';
import '../models/requests/create_appointment_request.dart';
import '../models/treatment_model.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/appointment_creation_view_model.dart';
import '../view_models/practitioner_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dialog_box/register_patient_dialog.dart';
import '../widgets/dialog_box/select_treatment_dailog.dart';
import '../widgets/gradient_scaffold.dart';

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
  final _searchController = TextEditingController();

  // Section 2: Treatment & Services
  String _selectedAppointmentType = 'Consultation & Session';
  final List<String> _appointmentTypes = [
    'Consultation & Session',
    'Treatment Session',
    'Virtual Consultation',
    'Follow-Up Session',
    'In-Person Consultation',
  ];
  final List<TreatmentModel> _selectedTreatments = [
    TreatmentModel(
      id: 3,
      name: 'Botox Cosmetic',
      description: 'Botox Anti-Wrinkle Treatment',
      price: 250,
      sideAreas: [
        SideAreaModel(id: 7, name: 'Forehead'),
      ],
    ),
  ];

  // Section 3: Practitioners & Clinical Schedule
  static final List<_PractitionerOption> _availablePractitioners = [
    _PractitionerOption(id: 64, name: 'Dr. Sarah Smith', role: 'doctor'),
    _PractitionerOption(id: 65, name: 'Dr. Michael Lee', role: 'injector'),
    _PractitionerOption(id: 66, name: 'Dr. John Adams', role: 'doctor'),
    _PractitionerOption(id: 67, name: 'Nurse Sarah Jenkins', role: 'nurse'),
  ];

  late _PractitionerOption _selectedPractitionerOption;
  String _practitionerRole = 'doctor';
  final List<String> _practitionerRoles = ['doctor', 'injector', 'nurse'];

  final List<_PractitionerOption> _assignedPractitioners = [
    _PractitionerOption(id: 64, name: 'Dr. Sarah Smith', role: 'doctor'),
  ];

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
    _selectedPractitionerOption = _availablePractitioners.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(practitionerProvider.notifier).getPractitioner();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                      width: context.w(100),
                      height: context.h(40),
                    ),
                    context.horizontalSpace(12),
                    CustomPrimaryButton(
                      onTap: () => _submitForm(state, viewModel),
                      label: 'Save Appointment',
                      width: context.w(180),
                      height: context.h(40),
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

  // Section 1: Patient Selection
  Widget _buildPatientSection(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    return _buildSection(
      title: 'Patient Selection',
      trailing: CustomPrimaryButton(
        onTap: () => RegisterPatientDialog.show(context),
        label: 'Register New Patient',
        icon: Icons.person_add_alt_1_outlined,
        height: context.h(36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      children: [
        BuildTextField(
          controller: _searchController,
          label: 'Search Existing Patient',
          hintText: 'Search by patient name, email, or phone number...',
          prefixIcon: const Icon(Icons.search, color: CustomColors.grey),
          onChanged: (val) => viewModel.searchPatients(val ?? ''),
        ),
        SizedBox(height: context.h(16)),
        if (state.selectedPatient != null) ...[
          Text('Selected Patient', style: context.fonts.grey11w600ls12),
          SizedBox(height: context.h(10)),
          _buildPatientCard(state.selectedPatient!, true, viewModel),
        ],
        if (state.searchResults.isNotEmpty) ...[
          SizedBox(height: context.h(12)),
          Text('Search Results', style: context.fonts.grey11w600ls12),
          SizedBox(height: context.h(10)),
          ...state.searchResults
              .where((p) => p.id != state.selectedPatient?.id)
              .map((p) => _buildPatientCard(p, false, viewModel)),
        ],
      ],
    );
  }

  Widget _buildPatientCard(
    PatientModel patient,
    bool isSelected,
    AppointmentCreationViewModel viewModel,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => viewModel.selectPatient(patient),
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
                  patient.name[0].toUpperCase(),
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
    return _buildSection(
      title: 'Treatment & Services',
      trailing: CustomPrimaryButton(
        onTap: () => showDialog(
          context: context,
          builder: (context) => const SelectTreatmentDialog(),
        ),
        label: 'Assign Treatments',
        icon: Icons.add,
        height: context.h(36),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Appointment Type',
                hintText: 'Select Type',
                value: _selectedAppointmentType,
                items: _appointmentTypes,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedAppointmentType = val);
                  }
                },
                builder: (val) => Text(val),
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
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: _selectedTreatments.map((treatment) {
              final areaText = treatment.sideAreas != null &&
                      treatment.sideAreas!.isNotEmpty
                  ? ' (${treatment.sideAreas!.map((a) => a.name).join(', ')})'
                  : '';
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
                      '${treatment.name}$areaText',
                      style: context.fonts.purple13w700,
                    ),
                    context.horizontalSpace(8),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTreatments.removeWhere(
                            (t) => t.id == treatment.id,
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
      ],
    );
  }

  // Section 3: Practitioner & Schedule
  Widget _buildPractitionerScheduleSection() {
    return _buildSection(
      title: 'Practitioners & Clinical Schedule',
      trailing: CustomPrimaryButton(
        onTap: () {
          final exists = _assignedPractitioners.any(
            (p) => p.id == _selectedPractitionerOption.id,
          );
          if (!exists) {
            setState(() {
              _assignedPractitioners.add(
                _selectedPractitionerOption.copyWith(role: _practitionerRole),
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<_PractitionerOption>(
                label: 'Assigned Practitioner',
                hintText: 'Select Practitioner',
                value: _selectedPractitionerOption,
                items: _availablePractitioners,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPractitionerOption = val;
                      _practitionerRole = val.role;
                    });
                  }
                },
                builder: (val) => Text(val.name),
              ),
            ),
            SizedBox(width: context.w(16)),
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Practitioner Role',
                hintText: 'Select Role',
                value: _practitionerRole,
                items: _practitionerRoles,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _practitionerRole = val);
                  }
                },
                builder: (val) => Text(val.capitalize),
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
      appointmentTypeId: 1,
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

class _PractitionerOption {
  final int id;
  final String name;
  final String role;

  _PractitionerOption({
    required this.id,
    required this.name,
    required this.role,
  });

  _PractitionerOption copyWith({String? role}) {
    return _PractitionerOption(
      id: id,
      name: name,
      role: role ?? this.role,
    );
  }
}
