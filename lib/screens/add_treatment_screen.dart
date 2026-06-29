import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../utils/theme.dart';
import '../widgets/app_network_image.dart';
import '../widgets/build_textfield.dart';
import '../utils/clinic_dummy_data.dart';
import '../view_models/clinic_add_treatment_view_model.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/number_paginator.dart';

class ClinicAddTreatmentScreen extends ConsumerStatefulWidget {
  const ClinicAddTreatmentScreen({super.key});

  static const String routeName = '/clinic-add-treatment';

  @override
  ConsumerState<ClinicAddTreatmentScreen> createState() => _ClinicAddTreatmentScreenState();
}

class _ClinicAddTreatmentScreenState extends ConsumerState<ClinicAddTreatmentScreen> {
  // Shared text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _basePriceController = TextEditingController();
  final TextEditingController _preTitleController = TextEditingController();
  final TextEditingController _preMsgController = TextEditingController();
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postMsgController = TextEditingController();

  // Dynamic controllers for UOM pricing overrides
  final Map<String, TextEditingController> _uomControllers = {};

  // Form keys
  final _formKey = GlobalKey<FormState>();

  // Scroll controller for infinite pagination & template search controller
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _templatesSearchController = TextEditingController();

  // Cached state versions to handle cursor position and synchronization
  ClinicDummyTreatmentTemplate? _lastTemplate;
  Map<int, bool>? _lastDefaults;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Reset state and fetch templates on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicAddTreatmentViewModelProvider.notifier).reset();
      ref.read(clinicAddTreatmentViewModelProvider.notifier).fetchTemplates(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _templatesSearchController.dispose();
    _nameController.dispose();
    _displayNameController.dispose();
    _descController.dispose();
    _basePriceController.dispose();
    _preTitleController.dispose();
    _preMsgController.dispose();
    _postTitleController.dispose();
    _postMsgController.dispose();
    for (var controller in _uomControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(clinicAddTreatmentViewModelProvider);
      if (state.activeStep == 0) {
        ref.read(clinicAddTreatmentViewModelProvider.notifier).fetchTemplates();
      }
    }
  }

  void _syncControllers(ClinicAddTreatmentState state) {
    if (state.selectedTemplate != _lastTemplate || state.stepIsDefault != _lastDefaults) {
      _lastTemplate = state.selectedTemplate;
      _lastDefaults = Map<int, bool>.from(state.stepIsDefault);

      _nameController.text = state.effectiveName;
      _displayNameController.text = state.effectivePatientDisplayName;
      _descController.text = state.effectiveDescription;
      _basePriceController.text = state.effectiveBasePrice > 0 ? state.effectiveBasePrice.toStringAsFixed(2) : '';
      _preTitleController.text = state.effectivePreNotificationTitle;
      _preMsgController.text = state.effectivePreNotificationMessage;
      _postTitleController.text = state.effectivePostNotificationTitle;
      _postMsgController.text = state.effectivePostNotificationMessage;
    }

    // Sync dynamic UOM price controllers
    final selectedProducts = state.effectiveProducts;
    final uniqueUoms = selectedProducts.map((p) => p.product.uom).toSet().toList();
    for (final uom in uniqueUoms) {
      if (!_uomControllers.containsKey(uom)) {
        _uomControllers[uom] = TextEditingController(
          text: state.getEffectiveUomPrice(uom).toStringAsFixed(2),
        );
      } else {
        final currentVal = state.getEffectiveUomPrice(uom).toStringAsFixed(2);
        // Only override if admin default is active, to prevent overwriting user typing
        if ((state.stepIsDefault[10] ?? true) && _uomControllers[uom]!.text != currentVal) {
          _uomControllers[uom]!.text = currentVal;
        }
      }
    }
  }

  final List<String> _steps = [
    "Template Selection",
    "Basic Information",
    "Sessions Setup",
    "Follow-Up Config",
    "Consent Forms",
    "Pre-Treatment Alerts",
    "Post-Treatment Alerts",
    "Downtime Level",
    "Allowed Roles",
    "Inventory Products",
    "Pricing Setup",
    "Review & Save",
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clinicAddTreatmentViewModelProvider);
    _syncControllers(state);

    final bool isDesktop = context.screenWidth > 1200;
    final bool isTablet = context.screenWidth > 800 && context.screenWidth <= 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Add Clinic Treatment', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.close, color: CustomColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar Stepper
          if (isDesktop || isTablet) _buildLeftSidebar(state),

          // Main Active Form View
          Expanded(
            child: Column(
              children: [
                if (!isDesktop && !isTablet) _buildMobileProgress(state),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: context.w(isDesktop ? 800 : 900),
                        ),
                        child: Column(
                          children: [
                            _buildStepHeader(state),
                            context.verticalSpace(32),
                            Container(
                              padding: context.appEdgeInsets(all: 32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: context.appBorderRadius(all: 16),
                                border: Border.all(color: CustomColors.border),
                                boxShadow: AppShadows.card(context),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildActiveStepContent(state),
                                    context.verticalSpace(32),
                                    const Divider(),
                                    context.verticalSpace(24),
                                    _buildNavigationButtons(state),
                                  ],
                                ),
                              ),
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
    );
  }

  Widget _buildLeftSidebar(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
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
                      '${state.activeStep + 1} / ${_steps.length}',
                      style: context.fonts.black14w700,
                    ),
                    Text(
                      '${((state.activeStep + 1) / _steps.length * 100).toInt()}%',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
                context.verticalSpace(12),
                ClipRRect(
                  borderRadius: context.appBorderRadius(all: 10),
                  child: LinearProgressIndicator(
                    value: (state.activeStep + 1) / _steps.length,
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
              itemCount: _steps.length,
              itemBuilder: (context, idx) {
                final isCompleted = idx < state.activeStep;
                final isActive = idx == state.activeStep;

                return InkWell(
                  onTap: idx <= state.activeStep ? () => notifier.setStep(idx) : null,
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
                                    '${idx + 1}',
                                    style: isActive
                                        ? context.fonts.white10w700
                                        : context.fonts.grey10w700,
                                  ),
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Text(
                            _steps[idx],
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

  Widget _buildMobileProgress(ClinicAddTreatmentState state) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${state.activeStep + 1} of ${_steps.length}',
                style: context.fonts.black14w700,
              ),
              Text(
                '${((state.activeStep + 1) / _steps.length * 100).toInt()}%',
                style: context.fonts.purple14w700,
              ),
            ],
          ),
          context.verticalSpace(8),
          LinearProgressIndicator(
            value: (state.activeStep + 1) / _steps.length,
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

  Widget _buildStepHeader(ClinicAddTreatmentState state) {
    final titles = [
      "Template Selection",
      "Basic Information",
      "Sessions Setup",
      "Follow-Up Config",
      "Consent Forms",
      "Pre-Treatment Alerts",
      "Post-Treatment Alerts",
      "Downtime Level",
      "Allowed Roles",
      "Inventory Products",
      "Pricing Setup",
      "Review & Save",
    ];
    final descriptions = [
      "Choose a baseline medical treatment template to populate default settings.",
      "Core identification details including status.",
      "Sessions structure and default clinical settings.",
      "Schedule virtual or in-person checkups nested inside each target Session.",
      "Review and manage legal clinical consent document rules.",
      "Pre-treatment preparation guidelines and timed client alerts.",
      "Aftercare instructions and scheduled client alerts.",
      "Define restriction periods for anatomical areas after procedure.",
      "Allowed practitioner roles authorized to perform this treatment.",
      "Map Stock levels, consumption minimums and substitution rules.",
      "Standard pricing and consumed stock unit override rules.",
      "Audit your treatment configuration before activation.",
    ];
    final icons = [
      Icons.library_books_outlined,
      Icons.description_outlined,
      Icons.event_repeat_rounded,
      Icons.replay_outlined,
      Icons.fact_check_outlined,
      Icons.login_rounded,
      Icons.logout_rounded,
      Icons.hourglass_bottom_rounded,
      Icons.badge_outlined,
      Icons.inventory_2_outlined,
      Icons.payments_outlined,
      Icons.assignment_turned_in_outlined,
    ];

    return Row(
      children: [
        Container(
          padding: context.appEdgeInsets(all: 12),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            borderRadius: context.appBorderRadius(all: 12),
          ),
          child: Icon(
            icons[state.activeStep],
            color: CustomColors.purple,
            size: 24,
          ),
        ),
        context.horizontalSpace(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titles[state.activeStep],
                style: context.fonts.black20w600,
              ),
              Text(
                descriptions[state.activeStep],
                style: context.fonts.grey14w400,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveStepContent(ClinicAddTreatmentState state) {
    switch (state.activeStep) {
      case 0:
        return _buildStep1TemplateSelection(state);
      case 1:
        return _buildStep2BasicInformation(state);
      case 2:
        return _buildStep3SessionsSetup(state);
      case 3:
        return _buildStep4FollowUpConfig(state);
      case 4:
        return _buildStep5ConsentForms(state);
      case 5:
        return _buildStep6PreNotifications(state);
      case 6:
        return _buildStep7PostNotifications(state);
      case 7:
        return _buildStep8DowntimeLevel(state);
      case 8:
        return _buildStep9AllowedRoles(state);
      case 9:
        return _buildStep10InventoryProducts(state);
      case 10:
        return _buildStep11PricingSetup(state);
      case 11:
        return _buildStep12ReviewAndSave(state);
      default:
        return const SizedBox.shrink();
    }
  }

  // REUSABLE COMPONENT: Standard top block showing Use Default vs Custom override
  Widget _buildInheritanceToggle(int stepIndex, ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return const SizedBox.shrink();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[stepIndex] ?? true;

    return Padding(
      padding: context.appEdgeInsets(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Configuration Mode",
                style: context.fonts.grey12w600,
              ),
              if (isDefault)
                Row(
                  children: [
                    const Icon(Icons.lock, color: CustomColors.grey, size: 14),
                    context.horizontalSpace(6),
                    Text(
                      "Inherited from Admin Default",
                      style: context.fonts.grey12w400,
                    )
                  ],
                ),
            ],
          ),
          context.verticalSpace(8),
          Container(
            padding: context.appEdgeInsets(all: 4),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(all: 8),
              border: Border.all(color: CustomColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => notifier.setStepIsDefault(stepIndex, true),
                    child: Container(
                      padding: context.appEdgeInsets(vertical: 8),
                      decoration: BoxDecoration(
                        color: isDefault ? Colors.white : Colors.transparent,
                        borderRadius: context.appBorderRadius(all: 6),
                        boxShadow: isDefault ? AppShadows.xs(context) : null,
                      ),
                      child: Center(
                        child: Text(
                          "Use Admin Default",
                          style: isDefault ? context.fonts.purple14w600 : context.fonts.grey14w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => notifier.setStepIsDefault(stepIndex, false),
                    child: Container(
                      padding: context.appEdgeInsets(vertical: 8),
                      decoration: BoxDecoration(
                        color: !isDefault ? Colors.white : Colors.transparent,
                        borderRadius: context.appBorderRadius(all: 6),
                        boxShadow: !isDefault ? AppShadows.xs(context) : null,
                      ),
                      child: Center(
                        child: Text(
                          "Custom Configuration",
                          style: !isDefault ? context.fonts.purple14w600 : context.fonts.grey14w600,
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
    );
  }

  // ==================== STEP 1: TEMPLATE SELECTION ====================
  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'medication':
      case 'vaccines':
        return Icons.vaccines_outlined;
      case 'spa':
        return Icons.spa_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'face':
        return Icons.face_outlined;
      default:
        return Icons.vaccines_outlined;
    }
  }

  Widget _buildIconWidget(String iconSource) {
    if (iconSource.startsWith('http') || iconSource.contains('/')) {
      return AppNetworkImage(
        imageUrl: iconSource,
        fit: BoxFit.cover,
        errorIcon: Icons.broken_image,
      );
    }
    return Container(
      color: Colors.white.withValues(alpha: 0.2),
      child: Center(
        child: Icon(
          _getIconData(iconSource),
          color: Colors.white,
          size: context.sp(14),
        ),
      ),
    );
  }

  Widget _buildFooterPaginator(ClinicAddTreatmentState state) {
    if (state.templatesTotalPages <= 1) return const SizedBox.shrink();

    return Padding(
      padding: context.appEdgeInsets(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing Results ${((state.templatesPage - 2) * 10 + 1).clamp(1, double.infinity).toInt()}-${((state.templatesPage - 2) * 10 + state.templates.length).clamp(0, double.infinity).toInt()}',
            style: context.fonts.grey14w400,
          ),
          NumberPaginator(
            totalPages: state.templatesTotalPages,
            currentPage: (state.templatesPage - 2).clamp(0, state.templatesTotalPages - 1),
            onPageChanged: (pageIndex) {
              ref.read(clinicAddTreatmentViewModelProvider.notifier).setTemplatesPage(pageIndex + 1);
            },
          ),
        ],
      ),
    );
  }

  // ==================== STEP 1: TEMPLATE SELECTION ====================
  Widget _buildStep1TemplateSelection(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Treatment Template", style: context.fonts.black18w600),
        context.verticalSpace(8),
        Text(
          "Choose a baseline medical treatment. This will import standard settings which can then be customized.",
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(20),

        TextFormField(
          controller: _templatesSearchController,
          style: context.fonts.black14w400,
          decoration: AppDecorations.input(
            context,
            hint: "Search treatment templates by name...",
            prefixIcon: const Icon(Icons.search_rounded, color: CustomColors.grey),
            suffixIcon: _templatesSearchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: CustomColors.grey),
                    onPressed: () {
                      _templatesSearchController.clear();
                      setState(() {});
                      notifier.onSearchChanged('');
                    },
                  )
                : null,
          ),
          onChanged: (val) {
            setState(() {});
            notifier.onSearchChanged(val);
          },
        ),
        context.verticalSpace(20),

        if (state.isLoadingTemplates && state.templates.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(color: CustomColors.purple),
            ),
          )
        else if (state.templatesError != null && state.templates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: CustomColors.red, size: 40),
                  context.verticalSpace(12),
                  Text(
                    state.templatesError!,
                    style: context.fonts.black14w600,
                    textAlign: TextAlign.center,
                  ),
                  context.verticalSpace(12),
                  CustomOutlinedButton(
                    onTap: () => notifier.fetchTemplates(isRefresh: true),
                    label: "Retry",
                  ),
                ],
              ),
            ),
          )
        else if (state.templates.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, color: CustomColors.grey, size: 40),
                  context.verticalSpace(12),
                  Text(
                    "No treatment templates found",
                    style: context.fonts.black14w600,
                  ),
                ],
              ),
            ),
          )
        else ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.screenWidth > 1200 ? 4 : (context.screenWidth > 800 ? 3 : 2),
              crossAxisSpacing: context.w(16),
              mainAxisSpacing: context.h(16),
              childAspectRatio: 180 / 130,
            ),
            itemCount: state.templates.length,
            itemBuilder: (context, index) {
              final temp = state.templates[index];
              final isSelected = state.selectedTemplate?.id == temp.id.toString();

              return GestureDetector(
                onTap: () => notifier.selectTemplate(temp),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: context.appBorderRadius(all: 16),
                    border: Border.all(
                      color: isSelected ? CustomColors.purple : CustomColors.border,
                      width: isSelected ? 2.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: CustomColors.purple.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : AppShadows.xs(context),
                  ),
                  child: ClipRRect(
                    borderRadius: context.appBorderRadius(all: 14), // Account for border width
                    child: Stack(
                      children: [
                        // 1. Full-Cover Image Background
                        Positioned.fill(
                          child: AppNetworkImage(
                            imageUrl: temp.image ?? '',
                            fit: BoxFit.cover,
                            placeholderColor: CustomColors.whiteGrey,
                          ),
                        ),

                        // 2. Selection Tint / Dark Overlay Gradient for readability
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isSelected
                                    ? [
                                        CustomColors.purple.withValues(alpha: 0.25),
                                        CustomColors.purple.withValues(alpha: 0.65),
                                        CustomColors.purple.withValues(alpha: 0.9),
                                      ]
                                    : [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: 0.35),
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                              ),
                            ),
                          ),
                        ),

                        // 3. Title Aligned to Bottom (and shortDescription under it if present)
                        Positioned(
                          bottom: context.h(12),
                          left: context.w(12),
                          right: context.w(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                temp.name ?? '',
                                style: context.fonts.white14w600.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (temp.shortDescription != null && temp.shortDescription!.isNotEmpty) ...[
                                context.verticalSpace(2),
                                Text(
                                  temp.shortDescription!,
                                  style: context.fonts.grey10w400.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // 4. Icon/Thumbnail Container on Top Left
                        if (temp.icon != null && temp.icon!.isNotEmpty)
                          Positioned(
                            top: context.h(10),
                            left: context.w(10),
                            child: Container(
                              width: context.w(28),
                              height: context.w(28),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: _buildIconWidget(temp.icon!),
                              ),
                            ),
                          ),

                        // 5. Check Indicator on Top Right
                        Positioned(
                          top: context.h(10),
                          right: context.w(10),
                          child: Container(
                            padding: EdgeInsets.all(context.w(4)),
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColors.purple : Colors.black.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              isSelected ? Icons.check : Icons.circle_outlined,
                              size: context.sp(12),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (state.isLoadingTemplates)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: CustomColors.purple),
              ),
            ),
          _buildFooterPaginator(state),
        ],
      ],
    );
  }

  // ==================== STEP 2: BASIC INFORMATION ====================
  Widget _buildStep2BasicInformation(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[1] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Basic Information", style: context.fonts.black18w600),
        context.verticalSpace(16),
        _buildInheritanceToggle(1, state),
        
        BuildTextField(
          label: 'Treatment Name',
          controller: _nameController,
          hintText: 'e.g., Botox Cosmetic Clinical Edition',
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updateBasicInfo(name: val),
          validator: (val) => val == null || val.isEmpty ? "Name is required" : null,
        ),
        context.verticalSpace(16),
        BuildTextField(
          label: 'Patient-Facing Display Name',
          controller: _displayNameController,
          hintText: 'e.g., Anti-Wrinkle Injection Treatment',
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updateBasicInfo(patientDisplayName: val),
          validator: (val) => val == null || val.isEmpty ? "Display name is required" : null,
        ),
        context.verticalSpace(16),
        BuildTextField(
          label: 'Description',
          controller: _descController,
          hintText: 'Describe the treatment details...',
          maxLines: 4,
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updateBasicInfo(description: val),
        ),
        context.verticalSpace(16),
        _buildDropdownSelector(
          label: "Status",
          value: state.effectiveStatus,
          items: ["Active", "Inactive", "Draft"],
          enabled: !isDefault,
          onChanged: (val) {
            if (val != null) notifier.updateBasicInfo(status: val);
          },
        ),
      ],
    );
  }

  // ==================== STEP 3: SESSIONS SETUP ====================
  Widget _buildStep3SessionsSetup(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[2] ?? true;
    final list = state.effectiveSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Sessions Structure", style: context.fonts.black18w600),
            if (!isDefault)
              CustomPrimaryButton(
                onTap: () => notifier.addSession(),
                label: "Add Session",
                width: context.w(150),
              ),
          ],
        ),
        context.verticalSpace(16),
        _buildInheritanceToggle(2, state),

        if (list.isEmpty)
          Container(
            padding: context.appEdgeInsets(all: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: context.appBorderRadius(all: 8),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text("No sessions configured.", style: context.fonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (context, index) => context.verticalSpace(12),
            itemBuilder: (context, idx) {
              final s = list[idx];
              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: isDefault ? CustomColors.whiteGrey : Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 10),
                      decoration: const BoxDecoration(color: CustomColors.purple, shape: BoxShape.circle),
                      child: Text(
                        "${s.number}",
                        style: context.fonts.white12w700,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Session ${s.number}", style: context.fonts.black16w600),
                          context.verticalSpace(4),
                          Text(
                            "${s.followUps.length} Clinical Follow-ups Scheduled",
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                    ),
                    if (!isDefault)
                      IconButton(
                        onPressed: () => notifier.removeSession(idx),
                        icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ==================== STEP 4: FOLLOW-UP CONFIG ====================
  Widget _buildStep4FollowUpConfig(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[3] ?? true;
    final sessions = state.effectiveSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Follow-Up Configuration", style: context.fonts.black18w600),
        context.verticalSpace(8),
        Text(
          "Schedule virtual or in-person checkups for patients nested inside each target Session.",
          style: context.fonts.grey14w400,
        ),
        context.verticalSpace(16),
        _buildInheritanceToggle(3, state),

        if (sessions.isEmpty)
          Container(
            padding: context.appEdgeInsets(all: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.appBorderRadius(all: 8)),
            child: Text("Please add or select sessions in Step 3 first.", style: context.fonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => context.verticalSpace(20),
            itemBuilder: (context, sIdx) {
              final session = sessions[sIdx];
              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Session ${session.number} Follow-ups", style: context.fonts.black16w600),
                        if (!isDefault)
                          CustomOutlinedButton(
                            onTap: () => notifier.addFollowUp(sIdx),
                            label: "Add Follow-up",
                            width: context.w(150),
                          ),
                      ],
                    ),
                    const Divider(),
                    context.verticalSpace(8),

                    if (session.followUps.isEmpty)
                      Container(
                        padding: context.appEdgeInsets(all: 16),
                        alignment: Alignment.center,
                        child: Text("No follow-ups defined for this session.", style: context.fonts.grey12w400),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: session.followUps.length,
                        separatorBuilder: (context, index) => const Divider(height: 24),
                        itemBuilder: (context, fIdx) {
                          final f = session.followUps[fIdx];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, color: CustomColors.grey, size: 18),
                                  context.horizontalSpace(8),
                                  Text("Follow-up #${fIdx + 1}", style: context.fonts.black14w600),
                                  const Spacer(),
                                  if (!isDefault)
                                    IconButton(
                                      onPressed: () => notifier.removeFollowUp(sIdx, fIdx),
                                      icon: const Icon(Icons.close, color: CustomColors.red, size: 18),
                                    ),
                                ],
                              ),
                              context.verticalSpace(12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDropdownSelector(
                                      label: "Appointment Type",
                                      value: f.appointmentType,
                                      items: ClinicDummyData.appointmentTypes,
                                      enabled: !isDefault,
                                      onChanged: (val) {
                                        if (val != null) {
                                          notifier.updateFollowUp(sIdx, fIdx, appointmentType: val);
                                        }
                                      },
                                    ),
                                  ),
                                  context.horizontalSpace(16),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _buildSimpleNumericField(
                                            label: "Interval",
                                            initialValue: f.intervalValue,
                                            enabled: !isDefault,
                                            onChanged: (val) {
                                              notifier.updateFollowUp(sIdx, fIdx, intervalValue: val);
                                            },
                                          ),
                                        ),
                                        context.horizontalSpace(8),
                                        Expanded(
                                          flex: 3,
                                          child: _buildDropdownSelector(
                                            label: "Unit",
                                            value: f.intervalUnit,
                                            items: ["Days", "Weeks", "Months"],
                                            enabled: !isDefault,
                                            onChanged: (val) {
                                              if (val != null) {
                                                notifier.updateFollowUp(sIdx, fIdx, intervalUnit: val);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              context.verticalSpace(12),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: CustomColors.purple,
                                title: Text("Image Upload Mandatory", style: context.fonts.black14w500),
                                subtitle: Text("Patient must take and upload high-res target area photos before booking.", style: context.fonts.grey12w400),
                                value: f.isImageUploadMandatory,
                                onChanged: isDefault ? null : (val) {
                                  notifier.updateFollowUp(sIdx, fIdx, isImageUploadMandatory: val);
                                },
                              ),
                              context.verticalSpace(8),
                              Text("Clinical Instructions & Notes", style: context.fonts.black14w500),
                              context.verticalSpace(8),
                              TextFormField(
                                initialValue: f.clinicalInstructions,
                                readOnly: isDefault,
                                enabled: !isDefault,
                                maxLines: 2,
                                style: context.fonts.black14w400,
                                decoration: AppDecorations.input(
                                  context,
                                  hint: "Enter specific instructions or treatment checkpoints...",
                                  maxLines: 2,
                                ),
                                onChanged: (val) {
                                  notifier.updateFollowUp(sIdx, fIdx, clinicalInstructions: val);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // ==================== STEP 5: PATIENT CONSENT FORMS ====================
  Widget _buildStep5ConsentForms(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[4] ?? true;
    final consentName = state.effectiveConsentFormName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Patient Clinical Consent Forms", style: context.fonts.black18w600),
        context.verticalSpace(16),
        _buildInheritanceToggle(4, state),

        Container(
          width: double.infinity,
          padding: context.appEdgeInsets(all: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.appBorderRadius(all: 12),
            border: Border.all(color: CustomColors.border),
          ),
          child: Column(
            children: [
              Icon(Icons.picture_as_pdf_outlined, size: context.r(60), color: Colors.red.shade400),
              context.verticalSpace(12),
              Text(
                consentName.isNotEmpty ? consentName : "No document configured",
                style: context.fonts.black16w700,
              ),
              context.verticalSpace(6),
              Text(
                "Requires mandatory clinician-patient signatures before physical or chemical work starts.",
                style: context.fonts.grey12w400,
                textAlign: TextAlign.center,
              ),
              if (!isDefault) ...[
                context.verticalSpace(20),
                InkWell(
                  onTap: () {
                    // Mock file upload trigger
                    notifier.updateConsentForm("Clinic_Custom_Clinical_Consent_Form.pdf");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mock custom consent PDF uploaded successfully.")),
                    );
                  },
                  borderRadius: context.appBorderRadius(all: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomColors.whiteGrey,
                      borderRadius: context.appBorderRadius(all: 8),
                      border: Border.all(color: CustomColors.border),
                    ),
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.upload_file, size: 18, color: CustomColors.purple),
                          context.horizontalSpace(8),
                          Text("Upload Custom clinical PDF Form", style: context.fonts.purple14w600),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ==================== STEP 6: PRE-TREATMENT ALERTS ====================
  Widget _buildStep6PreNotifications(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[5] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Pre-Treatment Preparation Alerts", style: context.fonts.black18w600),
        context.verticalSpace(16),
        _buildInheritanceToggle(5, state),

        BuildTextField(
          label: "Notification Title",
          controller: _preTitleController,
          hintText: "e.g., Preparing for Botox",
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updatePreNotification(title: val),
          validator: (val) => val == null || val.isEmpty ? "Title is required" : null,
        ),
        context.verticalSpace(16),
        BuildTextField(
          label: "Reminder / Guidance Message",
          controller: _preMsgController,
          hintText: "Enter instructions, forbidden medications, skin preparations...",
          maxLines: 4,
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updatePreNotification(message: val),
          validator: (val) => val == null || val.isEmpty ? "Message is required" : null,
        ),
        context.verticalSpace(16),
        _buildDropdownSelector(
          label: "Reminder Trigger Timing",
          value: state.effectivePreNotificationTiming,
          items: ["12 Hours Before", "24 Hours Before", "2 Days Before", "3 Days Before"],
          enabled: !isDefault,
          onChanged: (val) {
            if (val != null) notifier.updatePreNotification(timing: val);
          },
        ),
      ],
    );
  }

  // ==================== STEP 7: POST-TREATMENT ALERTS ====================
  Widget _buildStep7PostNotifications(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[6] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Post-Treatment Aftercare Alerts", style: context.fonts.black18w600),
        context.verticalSpace(16),
        _buildInheritanceToggle(6, state),

        BuildTextField(
          label: "Notification Title",
          controller: _postTitleController,
          hintText: "e.g., Post-Treatment Aftercare Advice",
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updatePostNotification(title: val),
          validator: (val) => val == null || val.isEmpty ? "Title is required" : null,
        ),
        context.verticalSpace(16),
        BuildTextField(
          label: "Engagement / Recovery Instructions",
          controller: _postMsgController,
          hintText: "Enter skin soothing, washing restrictions, hydration steps...",
          maxLines: 4,
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updatePostNotification(message: val),
          validator: (val) => val == null || val.isEmpty ? "Message is required" : null,
        ),
        context.verticalSpace(16),
        _buildDropdownSelector(
          label: "Engagement Trigger Timing",
          value: state.effectivePostNotificationTiming,
          items: ["4 Hours After", "12 Hours After", "24 Hours After", "2 Days After", "5 Days After"],
          enabled: !isDefault,
          onChanged: (val) {
            if (val != null) notifier.updatePostNotification(timing: val);
          },
        ),
      ],
    );
  }

  // ==================== STEP 8: DOWNTIME LEVEL ====================
  Widget _buildStep8DowntimeLevel(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[7] ?? true;
    final selectedLevel = state.effectiveDowntimeLevel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Clinical Downtime Level", style: context.fonts.black18w600),
        context.verticalSpace(16),
        _buildInheritanceToggle(7, state),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.screenWidth > 1200 ? 4 : 2,
            crossAxisSpacing: context.w(12),
            mainAxisSpacing: context.h(12),
            childAspectRatio: 1.3,
          ),
          itemCount: ClinicDummyData.downtimeLevels.length,
          itemBuilder: (context, idx) {
            final level = ClinicDummyData.downtimeLevels[idx];
            final isSelected = selectedLevel == level;

            Color themeColor = CustomColors.purple;
            switch (level) {
              case 'None':
                themeColor = CustomColors.green;
                break;
              case 'Low':
                themeColor = Colors.blue;
                break;
              case 'Moderate':
                themeColor = Colors.orange;
                break;
              case 'High':
                themeColor = CustomColors.red;
                break;
            }

            return InkWell(
              onTap: isDefault ? null : () => notifier.updateDowntimeLevel(level),
              borderRadius: context.appBorderRadius(all: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? themeColor.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(
                    color: isSelected ? themeColor : CustomColors.border,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: context.w(12),
                      height: context.w(12),
                      decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                    ),
                    context.verticalSpace(8),
                    Text(
                      level,
                      style: isSelected ? context.fonts.purple14w700.copyWith(color: themeColor) : context.fonts.black14w600,
                    ),
                    context.verticalSpace(4),
                    Text(
                      _getDowntimeDesc(level),
                      style: context.fonts.grey10w400,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getDowntimeDesc(String level) {
    if (level == 'None') return "Go straight to work";
    if (level == 'Low') return "Minor redness, makeup ok";
    if (level == 'Moderate') return "Slight peeling or swelling";
    return "Social isolation 3-5 days";
  }

  // ==================== STEP 9: ALLOWED PROVIDER ROLES ====================
  Widget _buildStep9AllowedRoles(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[8] ?? true;
    final selectedRoles = state.effectiveAllowedRoles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Allowed Provider Roles", style: context.fonts.black18w600),
        context.verticalSpace(8),
        Text("Which practitioner roles are legally allowed to perform this treatment?", style: context.fonts.grey14w400),
        context.verticalSpace(16),
        _buildInheritanceToggle(8, state),

        Wrap(
          spacing: context.w(12),
          runSpacing: context.h(12),
          children: ClinicDummyData.providerRoles.map((role) {
            final isSelected = selectedRoles.contains(role);
            return _roleChip(
              role,
              isSelected,
              isDefault ? null : () => notifier.toggleAllowedRole(role),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _roleChip(String role, bool isSelected, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 30),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple : Colors.white,
          borderRadius: context.appBorderRadius(all: 30),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
              color: isSelected ? Colors.white : CustomColors.grey,
              size: 18,
            ),
            context.horizontalSpace(8),
            Text(
              role,
              style: isSelected ? context.fonts.white14w600 : context.fonts.black14w400,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== STEP 10: INVENTORY PRODUCTS SELECTION ====================
  Widget _buildStep10InventoryProducts(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[9] ?? true;
    final productsList = state.effectiveProducts;

    // Filter available products that are not yet selected
    final remainingProducts = ClinicDummyData.inventoryProducts
        .where((ip) => !productsList.any((p) => p.product.id == ip.id))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Inventory Products Mapping", style: context.fonts.black18w600),
            if (!isDefault && remainingProducts.isNotEmpty)
              _buildAddProductMenu(remainingProducts),
          ],
        ),
        context.verticalSpace(16),
        _buildInheritanceToggle(9, state),

        if (productsList.isEmpty)
          Container(
            padding: context.appEdgeInsets(all: 24),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.appBorderRadius(all: 8)),
            child: Text("No required medical stock products matched.", style: context.fonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productsList.length,
            separatorBuilder: (context, index) => context.verticalSpace(16),
            itemBuilder: (context, idx) {
              final usage = productsList[idx];
              final p = usage.product;

              return Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: context.appBorderRadius(all: 12),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: context.appEdgeInsets(all: 8),
                              decoration: BoxDecoration(color: CustomColors.whiteGrey, borderRadius: context.appBorderRadius(all: 6)),
                              child: const Icon(Icons.medication, color: CustomColors.purple, size: 20),
                            ),
                            context.horizontalSpace(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: context.fonts.black16w600),
                                Text("Unit of Measure (UOM): ${p.uom}", style: context.fonts.grey12w400),
                              ],
                            ),
                          ],
                        ),
                        if (!isDefault)
                          IconButton(
                            onPressed: () => notifier.removeProductUsage(p.id),
                            icon: const Icon(Icons.delete_outline, color: CustomColors.red),
                          ),
                      ],
                    ),
                    const Divider(),
                    context.verticalSpace(8),

                    // Inputs for customizing usage rules
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownSelector(
                            label: "Usage Type",
                            value: usage.usageType,
                            items: ["Required", "Optional", "Variable"],
                            enabled: !isDefault,
                            onChanged: (val) {
                              if (val != null) {
                                notifier.updateProductUsage(p.id, usageType: val);
                              }
                            },
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          child: _buildDropdownSelector(
                            label: "Deduction Timing",
                            value: usage.deductionTiming,
                            items: ["On Completion", "Manual"],
                            enabled: !isDefault,
                            onChanged: (val) {
                              if (val != null) {
                                notifier.updateProductUsage(p.id, deductionTiming: val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(12),

                    // Min and Max Limits based on dynamic UOM label
                    Row(
                      children: [
                        Expanded(
                          child: _buildSimpleNumericFieldDouble(
                            label: "Min Quantity (${p.uom}s)",
                            initialValue: usage.minQty,
                            enabled: !isDefault,
                            onChanged: (val) {
                              notifier.updateProductUsage(p.id, minQty: val);
                            },
                          ),
                        ),
                        context.horizontalSpace(12),
                        Expanded(
                          child: _buildSimpleNumericFieldDouble(
                            label: "Max Quantity (${p.uom}s)",
                            initialValue: usage.maxQty,
                            enabled: !isDefault,
                            onChanged: (val) {
                              notifier.updateProductUsage(p.id, maxQty: val);
                            },
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    // Allow Substitution
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: CustomColors.purple,
                      title: Text("Allow Clinic Substitutions", style: context.fonts.black14w500),
                      subtitle: Text("Clinicians can select equivalent brands if this item is out of stock.", style: context.fonts.grey12w400),
                      value: usage.allowSubstitution,
                      onChanged: isDefault ? null : (val) {
                        notifier.updateProductUsage(p.id, allowSubstitution: val);
                      },
                    ),

                    context.verticalSpace(8),
                    Text("Target Injection/Application Sub-Areas", style: context.fonts.black14w500),
                    context.verticalSpace(8),
                    Wrap(
                      spacing: context.w(8),
                      runSpacing: context.h(8),
                      children: ["Forehead", "Cheeks", "Glabella", "Crow's Feet", "Lips", "Full Face"].map((area) {
                        final isSelected = usage.targetAreas.contains(area);
                        return InkWell(
                          onTap: isDefault ? null : () {
                            final updatedAreas = List<String>.from(usage.targetAreas);
                            if (!isSelected) {
                              updatedAreas.add(area);
                            } else {
                              updatedAreas.remove(area);
                            }
                            notifier.updateProductUsage(p.id, targetAreas: updatedAreas);
                          },
                          borderRadius: context.appBorderRadius(all: 10),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: context.appEdgeInsets(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColors.purple.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: context.appBorderRadius(all: 10),
                              border: Border.all(
                                color: isSelected ? CustomColors.purple : CustomColors.border,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                                  size: 16,
                                  color: isSelected ? CustomColors.purple : CustomColors.grey,
                                ),
                                context.horizontalSpace(8),
                                Text(
                                  area,
                                  style: isSelected ? context.fonts.purple13w600 : context.fonts.black12w400,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAddProductMenu(List<ClinicDummyProduct> remaining) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ClinicDummyProduct>(
        customButton: Container(
          padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: CustomColors.purple,
            borderRadius: context.appBorderRadius(all: 6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 16, color: Colors.white),
              context.horizontalSpace(4),
              Text("Add Product", style: context.fonts.white12w700),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: context.w(250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: context.appBorderRadius(all: 8),
          ),
        ),
        items: remaining.map((ip) {
          return DropdownMenuItem<ClinicDummyProduct>(
            value: ip,
            child: Text(
              "${ip.name} (${ip.uom})",
              style: context.fonts.black12w400,
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) {
            notifier.addProductUsage(val);
          }
        },
      ),
    );
  }

  // ==================== STEP 11: PRICING SETUP ====================
  Widget _buildStep11PricingSetup(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isDefault = state.stepIsDefault[10] ?? true;

    // Scan products for unique UOMs
    final selectedProducts = state.effectiveProducts;
    final uniqueUoms = selectedProducts.map((p) => p.product.uom).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Treatment Pricing Blueprint", style: context.fonts.black18w600),
        context.verticalSpace(8),
        Text("Define the standard entry session price and custom pricing factors per specific unit of measure.", style: context.fonts.grey14w400),
        context.verticalSpace(16),
        _buildInheritanceToggle(10, state),

        BuildTextField(
          label: "Base Treatment Session Price (AED)",
          controller: _basePriceController,
          hintText: "e.g., 150.00",
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.attach_money, color: CustomColors.purple),
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) {
            final p = double.tryParse(val ?? "") ?? 0.0;
            notifier.updateBasePrice(p);
          },
          validator: (val) {
            if (val == null || val.isEmpty) return "Price is required";
            if (double.tryParse(val) == null) return "Invalid price format";
            return null;
          },
        ),

        if (uniqueUoms.isNotEmpty) ...[
          context.verticalSpace(24),
          const Divider(),
          context.verticalSpace(16),
          Text("Dynamic Unit Overrides", style: context.fonts.black16w600),
          context.verticalSpace(4),
          Text(
            "Configure pricing metrics per consumed product unit to automatically calculate patient invoice adjustments.",
            style: context.fonts.grey12w400,
          ),
          context.verticalSpace(16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uniqueUoms.length,
            separatorBuilder: (context, index) => context.verticalSpace(14),
            itemBuilder: (context, idx) {
              final uom = uniqueUoms[idx];
              final ctrl = _uomControllers[uom];
              if (ctrl == null) return const SizedBox.shrink();

              return BuildTextField(
                label: "Custom Price Per consumed $uom (AED)",
                controller: ctrl,
                hintText: "e.g., 15.00",
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, color: CustomColors.purple),
                readOnly: isDefault,
                enabled: !isDefault,
                onChanged: (val) {
                  final p = double.tryParse(val ?? "") ?? 0.0;
                  notifier.updateUomPrice(uom, p);
                },
              );
            },
          ),
        ],
      ],
    );
  }

  // ==================== STEP 12: REVIEW & SAVE ====================
  Widget _buildStep12ReviewAndSave(ClinicAddTreatmentState state) {
    if (state.selectedTemplate == null) return _buildTemplateWarning();

    final sessions = state.effectiveSessions;
    final products = state.effectiveProducts;
    final uniqueUoms = products.map((p) => p.product.uom).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Review Clinical Treatment Blueprint", style: context.fonts.black18w600),
        context.verticalSpace(8),
        Text("Perform a final visual audit of your configuration before saving to your active catalog.", style: context.fonts.grey14w400),
        context.verticalSpace(20),

        // Section: Baseline Template
        _buildReviewSectionHeader("Baseline Settings Template"),
        _buildReviewRow("Selected Template", state.selectedTemplate!.name),
        _buildReviewRow("Category / Sub", "${state.selectedTemplate!.category} → ${state.selectedTemplate!.subcategory}"),
        _buildReviewRow("Global Product SKU", state.selectedTemplate!.sku),

        const Divider(height: 30),

        // Section: Basic Details
        _buildReviewSectionHeader("Treatment Details"),
        _buildReviewRow("Clinical Name", state.effectiveName),
        _buildReviewRow("Patient Title", state.effectivePatientDisplayName),
        _buildReviewRow("Description", state.effectiveDescription),
        _buildReviewRow("Initial Status", state.effectiveStatus),

        const Divider(height: 30),

        // Section: Sessions and Followups
        _buildReviewSectionHeader("Sessions & Followups"),
        _buildReviewRow("Total Session Steps", "${sessions.length} Sessions"),
        ...sessions.map((s) => _buildReviewRow("  → Session ${s.number}", "${s.followUps.length} follow-ups scheduled")),

        const Divider(height: 30),

        // Section: Notifications & Safety
        _buildReviewSectionHeader("Patient Communications & Safety"),
        _buildReviewRow("Pre-Alert", "${state.effectivePreNotificationTitle} (${state.effectivePreNotificationTiming})"),
        _buildReviewRow("Post-Alert", "${state.effectivePostNotificationTitle} (${state.effectivePostNotificationTiming})"),
        _buildReviewRow("Downtime Level", state.effectiveDowntimeLevel),
        _buildReviewRow("Allowed Practitioner Roles", state.effectiveAllowedRoles.join(', ')),

        const Divider(height: 30),

        // Section: Inventory Mapping & Pricing
        _buildReviewSectionHeader("Inventory Consumption & Pricing"),
        _buildReviewRow("Base Session Price", "AED ${state.effectiveBasePrice.toStringAsFixed(2)}"),
        ...products.map((p) => _buildReviewRow("  • stock product", "${p.product.name} [Min: ${p.minQty}, Max: ${p.maxQty} ${p.product.uom}s]")),
        ...uniqueUoms.map((uom) => _buildReviewRow("  • dynamic rate per $uom", "AED ${state.getEffectiveUomPrice(uom).toStringAsFixed(2)}")),
      ],
    );
  }

  Widget _buildReviewSectionHeader(String title) {
    return Padding(
      padding: context.appEdgeInsets(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: context.fonts.purple12w700,
      ),
    );
  }

  Widget _buildReviewRow(String label, String val) {
    return Padding(
      padding: context.appEdgeInsets(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: context.fonts.grey12w600),
          ),
          context.horizontalSpace(12),
          Expanded(
            flex: 3,
            child: Text(
              val.isEmpty ? "—" : val,
              style: context.fonts.black12w600,
            ),
          ),
        ],
      ),
    );
  }

  // Warning when no template selected
  Widget _buildTemplateWarning() {
    return Container(
      padding: context.appEdgeInsets(all: 24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: context.appBorderRadius(all: 8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: CustomColors.red, size: 40),
          context.verticalSpace(12),
          Text("No Baseline Template Selected", style: context.fonts.black16w600),
          context.verticalSpace(6),
          Text(
            "Please navigate to Step 1 and choose a treatment template first.",
            style: context.fonts.grey14w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSelector({
    required String label,
    required String value,
    required List<String> items,
    required bool enabled,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black14w500),
        context.verticalSpace(10),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "Select options",
              style: context.fonts.grey14w400.copyWith(color: CustomColors.grey),
            ),
            value: items.contains(value) ? value : null,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: context.fonts.black14w400))).toList(),
            onChanged: enabled ? onChanged : null,
            buttonStyleData: ButtonStyleData(
              height: context.h(48),
              padding: context.appEdgeInsets(horizontal: 16),
              decoration: BoxDecoration(
                color: enabled ? Colors.white : CustomColors.whiteGrey,
                borderRadius: context.appBorderRadius(all: 8),
                border: Border.all(color: CustomColors.border),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: context.appBorderRadius(all: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleNumericField({
    required String label,
    required int initialValue,
    required bool enabled,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black12w600),
        context.verticalSpace(8),
        TextFormField(
          initialValue: initialValue.toString(),
          enabled: enabled,
          keyboardType: TextInputType.number,
          style: context.fonts.black14w400,
          decoration: AppDecorations.input(context),
          onChanged: (val) {
            final parsed = int.tryParse(val) ?? 1;
            onChanged(parsed);
          },
        ),
      ],
    );
  }

  Widget _buildSimpleNumericFieldDouble({
    required String label,
    required double initialValue,
    required bool enabled,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.fonts.black12w600),
        context.verticalSpace(8),
        TextFormField(
          initialValue: initialValue.toString(),
          enabled: enabled,
          keyboardType: TextInputType.number,
          style: context.fonts.black14w400,
          decoration: AppDecorations.input(context),
          onChanged: (val) {
            final parsed = double.tryParse(val) ?? 1.0;
            onChanged(parsed);
          },
        ),
      ],
    );
  }

  // Bottom action buttons inside stepper
  Widget _buildNavigationButtons(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    final isFirst = state.activeStep == 0;
    final isLast = state.activeStep == 11;

    return Row(
      children: [
        if (!isFirst) ...[
          CustomOutlinedButton(
            onTap: () => notifier.prevStep(),
            label: "Previous",
            width: context.w(120),
          ),
          context.horizontalSpace(12),
        ],
        const Spacer(),
        if (!isLast)
          CustomPrimaryButton(
            onTap: state.selectedTemplate == null
                ? null
                : () {
                    // Custom validation rules per step if required
                    if (_formKey.currentState?.validate() ?? true) {
                      notifier.nextStep();
                    }
                  },
            label: "Next Step",
            width: context.w(150),
          )
        else ...[
          CustomOutlinedButton(
            onTap: () => _handleSave(isDraft: true),
            label: "Save Draft",
            width: context.w(130),
          ),
          context.horizontalSpace(12),
          CustomPrimaryButton(
            onTap: () => _handleSave(isDraft: false),
            label: "Save Treatment",
            width: context.w(160),
          ),
        ]
      ],
    );
  }

  void _handleSave({required bool isDraft}) {
    if (!_formKey.currentState!.validate()) return;

    // Show beautiful success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(16))),
          child: Padding(
            padding: context.appEdgeInsets(all: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),
                context.verticalSpace(24),
                Text(
                  isDraft ? "Draft Saved Successfully!" : "Treatment Added Successfully!",
                  style: context.fonts.black20w600,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(12),
                Text(
                  isDraft
                      ? "The clinical blueprint has been recorded as a draft in your local workspace."
                      : "The treatment configuration has been fully finalized and updated in your clinic active catalog.",
                  style: context.fonts.grey14w400,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(24),
                SizedBox(
                  width: double.infinity,
                  child: CustomPrimaryButton(
                    onTap: () {
                      Navigator.of(ctx).pop(); // Dismiss success dialog
                      ref.read(clinicAddTreatmentViewModelProvider.notifier).reset();
                      context.pop(); // Navigate back to treatments screen
                    },
                    label: "Return to Catalog",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
