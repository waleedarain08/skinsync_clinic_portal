import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/patient_model.dart';
import '../utils/responsive.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/appointment_creation_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/dialog_box/register_patient_dialog.dart';

class CreateAppointmentScreen extends ConsumerStatefulWidget {
  const CreateAppointmentScreen({super.key});

  static const String routeName = '/create-appointment';

  @override
  ConsumerState<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState
    extends ConsumerState<CreateAppointmentScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
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
          _buildStepper(state.currentStep),
          Expanded(
            child: SingleChildScrollView(
              padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.w(800)),
                  child: _buildCurrentStep(state, viewModel),
                ),
              ),
            ),
          ),
          _buildBottomNavigation(state, viewModel),
        ],
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    final steps = ['Patient', 'Treatment', 'Schedule', 'Confirm'];
    return Container(
      padding: context.appEdgeInsets(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: CustomColors.border)),
      ),
      child: AdaptiveLayoutRowColumn(
        expandedWidget: false,
        alignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          final isCompleted = index < currentStep;
          final isActive = index == currentStep;
          return Row(
            children: [
              _buildStepIndicator(index + 1, isCompleted, isActive),
              context.horizontalSpace(8),
              Text(
                steps[index],
                style: isActive
                    ? context.fonts.purple14w600
                    : (isCompleted
                          ? context.fonts.black14w400
                          : context.fonts.grey14w400),
              ),
              if (index < steps.length - 1)
                Container(
                  width: context.w(40),
                  height: 1,
                  margin: context.appEdgeInsets(horizontal: 16),
                  color: isCompleted
                      ? CustomColors.purple
                      : CustomColors.border,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool isCompleted, bool isActive) {
    return Container(
      width: context.w(28),
      height: context.w(28),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? CustomColors.green
            : (isActive ? CustomColors.purple : Colors.white),
        border: Border.all(
          color: isActive || isCompleted
              ? Colors.transparent
              : CustomColors.border,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '$step',
                style: isActive
                    ? context.fonts.white12w700
                    : context.fonts.grey12w700,
              ),
      ),
    );
  }

  Widget _buildCurrentStep(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    switch (state.currentStep) {
      case 0:
        return _buildPatientStep(state, viewModel);
      default:
        return Center(
          child: Text(
            'Step ${state.currentStep + 1} coming soon...',
            style: context.fonts.grey14w400,
          ),
        );
    }
  }

  Widget _buildPatientStep(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdaptiveLayoutRowColumn(
          expandedWidget: false,
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Patient Information', style: context.fonts.black20w600),
            CustomPrimaryButton(
              onTap: () => RegisterPatientDialog.show(context),
              label: 'Register New Patient',
              icon: Icons.person_add_alt_1_outlined,
              height: context.h(42),
              width: context.w(200),
            ),
          ],
        ),
        context.verticalSpace(24),
        BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search Existing Patient', style: context.fonts.black16w600),
              context.verticalSpace(16),
              TextField(
                controller: _searchController,
                onChanged: viewModel.searchPatients,
                decoration: AppDecorations.input(
                  context,
                  hint: 'Search by email or phone number...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: CustomColors.grey,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: CustomColors.grey,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            viewModel.searchPatients('');
                          },
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        context.verticalSpace(24),
        if (state.searchResults.isNotEmpty || state.selectedPatient != null)
          Text('Search Results', style: context.fonts.black16w600),
        context.verticalSpace(12),
        if (state.selectedPatient != null)
          _buildPatientCard(state.selectedPatient!, true, viewModel),
        ...state.searchResults
            .where((p) => p.id != state.selectedPatient?.id)
            .map((p) => _buildPatientCard(p, false, viewModel)),
      ],
    );
  }

  Widget _buildPatientCard(
    PatientModel patient,
    bool isSelected,
    AppointmentCreationViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => viewModel.selectPatient(patient),
        borderRadius: BorderRadius.circular(12),
        child: BorderdContainerWidget(
          padding: context.appEdgeInsets(all: 16),
          borderColor: isSelected ? CustomColors.purple : CustomColors.border,
          borderWidth: isSelected ? 2 : 1,
          backgroundColor: isSelected
              ? CustomColors.purple.withValues(alpha: 0.02)
              : Colors.white,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: CustomColors.softGrey,
                child: Text(
                  patient.name[0].toUpperCase(),
                  style: context.fonts.purple16w700,
                ),
              ),
              context.horizontalSpace(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name.capitalize,
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(4),
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 14,
                          color: CustomColors.grey,
                        ),
                        context.horizontalSpace(4),
                        Text(patient.email, style: context.fonts.grey12w400),
                        context.horizontalSpace(16),
                        const Icon(
                          Icons.phone_outlined,
                          size: 14,
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
                const Icon(Icons.check_circle, color: CustomColors.purple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(
    AppointmentCreationState state,
    AppointmentCreationViewModel viewModel,
  ) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CustomColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomOutlinedButton(
            onTap: state.currentStep > 0 ? viewModel.previousStep : null,
            label: 'Previous',
            width: context.w(120),
          ),
          CustomPrimaryButton(
            onTap: state.selectedPatient != null ? viewModel.nextStep : null,
            label: 'Next',
            width: context.w(120),
          ),
        ],
      ),
    );
  }
}
