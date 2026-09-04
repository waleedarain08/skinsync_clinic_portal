import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/patient_model.dart';
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
      id: 101,
      name: 'Botox Cosmetic',
      description: 'Botox Anti-Wrinkle Treatment',
      price: 350,
      sideAreas: [
        SideAreaModel(id: 1, name: 'Forehead'),
        SideAreaModel(id: 2, name: 'Crow\'s Feet'),
      ],
    ),
    TreatmentModel(
      id: 102,
      name: 'Juvederm Filler',
      description: 'Dermal Fillers Lip Volumizer',
      price: 450,
      sideAreas: [
        SideAreaModel(id: 3, name: 'Lips'),
      ],
    ),
  ];

  // Section 3: Practitioner & Schedule
  String? _selectedPractitioner = 'Dr. Sarah Smith';
  final List<String> _practitioners = [
    'Dr. Sarah Smith',
    'Dr. Michael Lee',
    'Dr. John Adams',
    'Dr. Sarah Jenkins',
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

  // Section 4: Notes & Financials
  final _amountController = TextEditingController(text: '350');
  final _notesController = TextEditingController();
  String _bookingMethod = 'online';
  final List<String> _bookingMethods = ['online', 'walk_in', 'manual'];

  @override
  void initState() {
    super.initState();
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
                label: 'Total Estimated Cost (\$)',
                hintText: '350',
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
      title: 'Practitioner & Clinical Schedule',
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDropdownField<String>(
                label: 'Assigned Practitioner',
                hintText: 'Select Practitioner',
                value: _selectedPractitioner,
                items: _practitioners,
                onChanged: (val) {
                  setState(() => _selectedPractitioner = val);
                },
                builder: (val) => Text(val),
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

  // Section 4: Notes & Financials
  Widget _buildNotesFinancialsSection() {
    return _buildSection(
      title: 'Clinical Notes & Booking Configuration',
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
          hintText: 'Enter patient instructions, contraindications, or preparation notes...',
          maxLines: 3,
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

    // Save appointment logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment created successfully!'),
        backgroundColor: CustomColors.purple,
      ),
    );
    context.pop();
  }
}
