import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/theme.dart';
import '../utils/clinic_dummy_data.dart';
import '../view_models/session_view_model.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/session_creation_steps/treatment_creation_steps.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

  static const String routeName = '/create-treatment-session';

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateTreatmentScreenState();
}

class _CreateTreatmentScreenState extends ConsumerState<CreateSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sessionViewModelProvider.notifier).resetPresetStates();
    });
  }

  int _getSessionOffsetStep(int sessionStep) {
    return sessionStep - 1;
  }

  @override
  Widget build(BuildContext context) {
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);

    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet =
        context.screenWidth > 800 && context.screenWidth <= 1200;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: GradientScaffold(
        appBar: AppBar(
          flexibleSpace: AppDecorations.appBarGradient,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Session Detail Builder',
            style: context.fonts.black18w600,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: CustomColors.black),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop || isTablet)
              _buildLeftSidebar(context, sessionViewModel),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  if (!isDesktop && !isTablet)
                    _buildMobileProgress(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: context.appEdgeInsets(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: context.w(isDesktop ? 800 : 900),
                          ),
                          child: Column(
                            children: [
                              _buildStepHeader(context),
                              context.verticalSpace(32),
                              Container(
                                padding: context.appEdgeInsets(all: 32),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: context.appBorderRadius(
                                    all: 16,
                                  ),
                                  border: Border.all(
                                    color: CustomColors.border,
                                  ),
                                  boxShadow: AppShadows.card(context),
                                ),
                                child: _buildCurrentStepContent(
                                  context,
                                  ref,
                                ),
                              ),
                              context.verticalSpace(48),
                              _buildActionButtons(
                                context,
                                sessionViewModel,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftSidebar(
    BuildContext context,
    SessionViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final steps = [
      'Inventory Products',
      'Scheduling',
      'Pricing',
      'Protocols',
      'Pre-Treatment Instructions',
      'Post-Treatment Instructions',
      'Post Treatment Photos',
      'Phase Notifications',
      'Downtime Level',
      'Allowed Provider Roles',
      'Follow-Up Setup',
      'Patient Consent',
    ];

    final currentOffsetStep = _getSessionOffsetStep(sessionState.sessionStep);

    return Container(
      width: context.w(280),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: CustomColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress', style: context.fonts.grey12w600),
                context.verticalSpace(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentOffsetStep + 1} / ${steps.length}',
                      style: context.fonts.black14w700,
                    ),
                    Text(
                      '${((currentOffsetStep + 1) / steps.length * 100).toInt()}%',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (currentOffsetStep + 1) / steps.length,
                    minHeight: context.h(8),
                    backgroundColor: CustomColors.whiteGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      CustomColors.purple,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: context.appEdgeInsets(vertical: 16),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final bool isActive = currentOffsetStep == index;
                final bool isCompleted = currentOffsetStep > index;

                return InkWell(
                  onTap: index < currentOffsetStep
                      ? () {
                          viewModel.setSessionStep(index + 1);
                        }
                      : null,
                  child: Container(
                    padding: context.appEdgeInsets(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? CustomColors.purple.withValues(alpha: 0.05)
                          : Colors.transparent,
                      border: Border(
                        right: BorderSide(
                          color: isActive
                              ? CustomColors.purple
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.w(24),
                          height: context.w(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? CustomColors.green
                                : (isActive
                                      ? CustomColors.purple
                                      : Colors.white),
                            border: Border.all(
                              color: isActive || isCompleted
                                  ? Colors.transparent
                                  : CustomColors.border,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : Text(
                                    '${index + 1}',
                                    style: isActive
                                        ? context.fonts.white10w700
                                        : context.fonts.grey10w700,
                                  ),
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: isActive
                                ? context.fonts.purple14w600
                                : (isCompleted
                                      ? context.fonts.black14w400
                                      : context.fonts.grey14w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context) {
    final titles = [
      'Inventory Products',
      'Scheduling',
      'Pricing Setup',
      'Clinical Protocols',
      'Pre-Treatment Instructions',
      'Post-Treatment Instructions',
      'Post Treatment Photos',
      'Phase Notifications',
      'Downtime Level',
      'Allowed Provider Roles',
      'Follow-Up Configuration',
      'Patient Consent Form',
    ];
    final descriptions = [
      'Configure required products from inventory and area-wise consumption.',
      'Centralize appointment duration, preparation times, and booking permissions.',
      'Finalize treatment base price and sub-area pricing adjustments.',
      'Standardize procedures with checklists and required text fields.',
      'Detailed instructions and supporting media for patients before the procedure.',
      'Aftercare guidelines and recovery media for patients after the procedure.',
      'Configure how many post-treatment photos should be captured for this treatment.',
      'Automated reminders and follow-up engagement messages.',
      'Configure booking restriction window after treatment.',
      'Define which provider roles are authorized to perform this treatment.',
      'Manage rules and scheduling for post-procedure clinical check-ins.',
      'Upload and manage legal procedural consent documentation.',
    ];
    final icons = [
      Icons.inventory_2_outlined,
      Icons.schedule_outlined,
      Icons.payments_outlined,
      Icons.assignment_turned_in_outlined,
      Icons.login_rounded,
      Icons.logout_rounded,
      Icons.add_a_photo_outlined,
      Icons.notifications_active_outlined,
      Icons.hourglass_bottom_rounded,
      Icons.badge_outlined,
      Icons.replay_outlined,
      Icons.fact_check_outlined,
    ];

    final sessionState = ref.watch(sessionViewModelProvider);
    final sessionViewModel = ref.read(sessionViewModelProvider.notifier);
    final int stepIndex = _getSessionOffsetStep(sessionState.sessionStep);
    if (stepIndex < 0 || stepIndex >= titles.length) {
      return const SizedBox.shrink();
    }

    final bool isOverridden = sessionViewModel.isStepOverridden(sessionState.sessionStep);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.purple.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 12),
              ),
              child: Icon(
                icons[stepIndex],
                color: CustomColors.purple,
                size: 24,
              ),
            ),
            context.horizontalSpace(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[stepIndex], style: context.fonts.black20w600),
                  Text(
                    descriptions[stepIndex],
                    style: context.fonts.grey14w400,
                  ),
                ],
              ),
            ),
            context.horizontalSpace(16),
            isOverridden
                ? CustomPrimaryButton(
                    onTap: () {
                      sessionViewModel.revertAdminPreset(sessionState.sessionStep);
                      setState(() {});
                    },
                    icon: Icons.undo_rounded,
                    label: 'Revert',
                    width: context.w(130),
                  )
                : CustomOutlinedButton(
                    onTap: () {
                      _showAdminConfigDialog(context, sessionState.sessionStep);
                    },
                    icon: Icons.admin_panel_settings_outlined,
                    label: 'Admin Config',
                    width: context.w(150),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileProgress(BuildContext context) {
    final sessionState = ref.watch(sessionViewModelProvider);
    const stepsCount = 12;
    final currentOffsetStep = _getSessionOffsetStep(sessionState.sessionStep);
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentOffsetStep + 1} of $stepsCount',
                style: context.fonts.black14w700,
              ),
              Text(
                '${((currentOffsetStep + 1) / stepsCount * 100).toInt()}%',
                style: context.fonts.purple14w700,
              ),
            ],
          ),
          context.verticalSpace(8),
          LinearProgressIndicator(
            value: (currentOffsetStep + 1) / stepsCount,
            minHeight: context.h(4),
            backgroundColor: CustomColors.whiteGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(
              CustomColors.purple,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    switch (sessionState.sessionStep) {
      case 1:
        return const MaterialsStep();
      case 2:
        return const SchedulingStep();
      case 3:
        return const PricingStep();
      case 4:
        return const ProtocolsStep();
      case 5:
        return const PreInstructionsStep();
      case 6:
        return const PostInstructionsStep();
      case 7:
        return const PostPhotosStep();
      case 8:
        return const NotificationsStep();
      case 9:
        return const DowntimeStep();
      case 10:
        return const RolesStep();
      case 11:
        return const FollowUpStep();
      case 12:
        return const ConsentStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons(
    BuildContext context,
    SessionViewModel viewModel,
  ) {
    final sessionState = ref.watch(sessionViewModelProvider);
    final bool isLastStep = sessionState.sessionStep == 12;
    return Row(
      children: [
        if (sessionState.sessionStep > 1) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () {
                viewModel.setSessionStep(sessionState.sessionStep - 1);
              },
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ] else if (sessionState.sessionStep == 1) ...[
          Expanded(
            child: CustomOutlinedButton(
              onTap: () {
                context.pop();
              },
              label: 'Previous Step',
            ),
          ),
          context.horizontalSpace(16),
        ],
        Expanded(
          flex: 2,
          child: CustomPrimaryButton(
            onTap: () async {
              log('CURRENT STEP: ${sessionState.sessionStep}');
              if (isLastStep) {
                context.pop();
              } else {
                viewModel.setSessionStep(sessionState.sessionStep + 1);
              }
            },
            label: isLastStep ? 'Save Session Details' : 'Next Step',
          ),
        ),
      ],
    );
  }

  void _showAdminConfigDialog(BuildContext context, int step) {
    final config = ClinicDummySessionConfig.stepConfigs[step];
    if (config == null) return;

    final String title = config['title'] as String;
    final List<String> details = List<String>.from(config['details'] as List);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: context.w(500),
            padding: context.appEdgeInsets(all: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        Icons.admin_panel_settings_rounded,
                        color: CustomColors.purple,
                        size: 24,
                      ),
                    ),
                    context.horizontalSpace(12),
                    Expanded(
                      child: Text(
                        title,
                        style: context.fonts.black18w600,
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(20),
                Text(
                  'Admin session details configuration matching SessionDetailResponse:',
                  style: context.fonts.grey12w600,
                ),
                context.verticalSpace(12),
                Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: details.map((detail) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: context.fonts.purple14w700,
                            ),
                            Expanded(
                              child: Text(
                                detail,
                                style: context.fonts.black13w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                context.verticalSpace(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomOutlinedButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      label: 'Close Config',
                      width: context.w(130),
                    ),
                    context.horizontalSpace(12),
                    CustomPrimaryButton(
                      onTap: () {
                        ref.read(sessionViewModelProvider.notifier).applyAdminPreset(step);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      label: 'Use This Configuration',
                      width: context.w(200),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
