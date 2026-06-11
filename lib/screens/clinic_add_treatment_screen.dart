import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/widgets/build_textfield.dart';
import 'package:skinsync_clinic_portal/widgets/header__with_back_btn.dart';
import 'package:skinsync_clinic_portal/utils/clinic_dummy_data.dart';
import 'package:skinsync_clinic_portal/view_models/clinic_add_treatment_view_model.dart';

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

  // Cached state versions to handle cursor position and synchronization
  ClinicDummyTreatmentTemplate? _lastTemplate;
  Map<int, bool>? _lastDefaults;

  @override
  void initState() {
    super.initState();
    // Reset state on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clinicAddTreatmentViewModelProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
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

    final isLandscape = context.isLandscape;

    return Scaffold(
      backgroundColor: CustomColors.dashboardBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: const BuildHeader(title: 'Add Treatment'),
            ),
            
            // Layout container
            Expanded(
              child: isLandscape ? _buildLandscapeLayout(state) : _buildPortraitLayout(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Sidebar Stepper
        Container(
          width: 260.w,
          color: Colors.white,
          child: ListView.builder(
            itemCount: _steps.length,
            itemBuilder: (context, idx) {
              final isCompleted = idx < state.activeStep;
              final isActive = idx == state.activeStep;
              return InkWell(
                onTap: () => notifier.setStep(idx),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  color: isActive ? CustomColors.navigationRailBackground : Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 24.r,
                        height: 24.r,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.black
                              : isCompleted
                                  ? CustomColors.green
                                  : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 14.r)
                              : Text(
                                  "${idx + 1}",
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey.shade700,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _steps[idx],
                          style: TextStyle(
                            color: isActive ? Colors.black : Colors.grey.shade600,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Right Active Form View
        Expanded(
          child: Container(
            margin: EdgeInsets.all(24.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildActiveStepContent(state),
                    ),
                  ),
                  const Divider(height: 32),
                  _buildNavigationButtons(state),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    return Column(
      children: [
        // Horizontal scrollable step list for Mobile
        Container(
          height: 60.h,
          color: Colors.white,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _steps.length,
            itemBuilder: (context, idx) {
              final isActive = idx == state.activeStep;
              final isCompleted = idx < state.activeStep;
              return GestureDetector(
                onTap: () => notifier.setStep(idx),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isActive ? Colors.black : Colors.transparent,
                        width: 2.h,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.black
                              : isCompleted
                                  ? CustomColors.green
                                  : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 12.r)
                              : Text(
                                  "${idx + 1}",
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey.shade700,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _steps[idx],
                        style: TextStyle(
                          color: isActive ? Colors.black : Colors.grey.shade600,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Scrollable content area below steps
        Expanded(
          child: Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildActiveStepContent(state),
                    ),
                  ),
                  const Divider(height: 24),
                  _buildNavigationButtons(state),
                ],
              ),
            ),
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
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Configuration Mode",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
              if (isDefault)
                Row(
                  children: [
                    Icon(Icons.lock, color: Colors.grey.shade400, size: 14.r),
                    SizedBox(width: 4.w),
                    Text(
                      "Inherited from Admin Default",
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
                    )
                  ],
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => notifier.setStepIsDefault(stepIndex, true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isDefault ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: isDefault
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Use Admin Default",
                          style: TextStyle(
                            color: isDefault ? Colors.black : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => notifier.setStepIsDefault(stepIndex, false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: !isDefault ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        boxShadow: !isDefault
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          "Custom Configuration",
                          style: TextStyle(
                            color: !isDefault ? Colors.black : Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
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
  Widget _buildStep1TemplateSelection(ClinicAddTreatmentState state) {
    final notifier = ref.read(clinicAddTreatmentViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Treatment Template", style: CustomFonts.black20w600),
        SizedBox(height: 8.h),
        Text(
          "Choose a baseline medical treatment. This will import standard settings which can then be customized.",
          style: CustomFonts.grey14w400,
        ),
        SizedBox(height: 20.h),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ClinicDummyData.templates.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final temp = ClinicDummyData.templates[index];
            final isSelected = state.selectedTemplate?.id == temp.id;

            return InkWell(
              onTap: () => notifier.selectTemplate(temp),
              child: Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black.withOpacity(0.02) : Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(temp.name, style: CustomFonts.black16w600),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  temp.category,
                                  style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(temp.description, style: CustomFonts.grey12w400),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text("UOM: ", style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text(temp.products.firstOrNull?.product.uom ?? "Unit", style: TextStyle(fontSize: 11.sp, color: Colors.black)),
                              SizedBox(width: 16.w),
                              Text("Base price: ", style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                              Text("\$${temp.basePrice.toStringAsFixed(2)}", style: TextStyle(fontSize: 11.sp, color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: Colors.black, size: 24.r)
                    else
                      Icon(Icons.circle_outlined, color: Colors.grey.shade300, size: 24.r),
                  ],
                ),
              ),
            );
          },
        ),

        if (state.selectedTemplate != null) ...[
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 16.h),
          Text("Inherited Structural Metadata", style: CustomFonts.black16w600),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildReadonlyLabelValue("Category", state.selectedTemplate!.category),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildReadonlyLabelValue("Subcategory", state.selectedTemplate!.subcategory),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildReadonlyLabelValue("Global SKU Identifier", state.selectedTemplate!.sku),
        ],
      ],
    );
  }

  Widget _buildReadonlyLabelValue(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.bold)),
        ],
      ),
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
        Text("Basic Information", style: CustomFonts.black20w600),
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
        BuildTextField(
          label: 'Patient-Facing Display Name',
          controller: _displayNameController,
          hintText: 'e.g., Anti-Wrinkle Injection Treatment',
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updateBasicInfo(patientDisplayName: val),
          validator: (val) => val == null || val.isEmpty ? "Display name is required" : null,
        ),
        SizedBox(height: 16.h),
        BuildTextField(
          label: 'Description',
          controller: _descController,
          hintText: 'Describe the treatment details...',
          maxLines: 4,
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) => notifier.updateBasicInfo(description: val),
        ),
        SizedBox(height: 16.h),
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
            Text("Sessions Structure", style: CustomFonts.black20w600),
            if (!isDefault)
              ElevatedButton.icon(
                onPressed: () => notifier.addSession(),
                icon: Icon(Icons.add, size: 16.r, color: Colors.white),
                label: Text("Add Session", style: TextStyle(fontSize: 12.sp, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
                ),
              ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(2, state),

        if (list.isEmpty)
          Container(
            padding: EdgeInsets.all(24.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text("No sessions configured.", style: CustomFonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, idx) {
              final s = list[idx];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: isDefault ? Colors.grey.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                      child: Text(
                        "${s.number}",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Session ${s.number}", style: CustomFonts.black16w600),
                          SizedBox(height: 4.h),
                          Text(
                            "${s.followUps.length} Clinical Follow-ups Scheduled",
                            style: CustomFonts.grey12w400,
                          ),
                        ],
                      ),
                    ),
                    if (!isDefault)
                      IconButton(
                        onPressed: () => notifier.removeSession(idx),
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
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
        Text("Follow-Up Configuration", style: CustomFonts.black20w600),
        SizedBox(height: 8.h),
        Text(
          "Schedule virtual or in-person checkups for patients nested inside each target Session.",
          style: CustomFonts.grey14w400,
        ),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(3, state),

        if (sessions.isEmpty)
          Container(
            padding: EdgeInsets.all(24.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r)),
            child: Text("Please add or select sessions in Step 3 first.", style: CustomFonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => SizedBox(height: 20.h),
            itemBuilder: (context, sIdx) {
              final session = sessions[sIdx];
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Session ${session.number} Follow-ups", style: CustomFonts.black16w600),
                        if (!isDefault)
                          TextButton.icon(
                            onPressed: () => notifier.addFollowUp(sIdx),
                            icon: Icon(Icons.add_circle_outline, size: 16.r, color: Colors.black),
                            label: Text("Add Follow-up", style: TextStyle(fontSize: 12.sp, color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(height: 8.h),

                    if (session.followUps.isEmpty)
                      Container(
                        padding: EdgeInsets.all(16.r),
                        alignment: Alignment.center,
                        child: Text("No follow-ups defined for this session.", style: CustomFonts.grey12w400),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: session.followUps.length,
                        separatorBuilder: (_, __) => const Divider(height: 24),
                        itemBuilder: (context, fIdx) {
                          final f = session.followUps[fIdx];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined, color: Colors.grey.shade400, size: 18.r),
                                  SizedBox(width: 8.w),
                                  Text("Follow-up #${fIdx + 1}", style: CustomFonts.black14w600),
                                  const Spacer(),
                                  if (!isDefault)
                                    IconButton(
                                      onPressed: () => notifier.removeFollowUp(sIdx, fIdx),
                                      icon: const Icon(Icons.close, color: Colors.red, size: 18),
                                    ),
                                ],
                              ),
                              SizedBox(height: 12.h),
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
                                  SizedBox(width: 16.w),
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
                                        SizedBox(width: 8.w),
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
                              SizedBox(height: 12.h),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: Colors.black,
                                title: Text("Image Upload Mandatory", style: CustomFonts.black14w500),
                                subtitle: Text("Patient must take and upload high-res target area photos before booking.", style: CustomFonts.grey12w400),
                                value: f.isImageUploadMandatory,
                                onChanged: isDefault ? null : (val) {
                                  notifier.updateFollowUp(sIdx, fIdx, isImageUploadMandatory: val);
                                },
                              ),
                              SizedBox(height: 8.h),
                              Text("Clinical Instructions & Notes", style: CustomFonts.black14w500),
                              SizedBox(height: 8.h),
                              TextFormField(
                                initialValue: f.clinicalInstructions,
                                readOnly: isDefault,
                                enabled: !isDefault,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText: "Enter specific instructions or treatment checkpoints...",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
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
        Text("Patient Clinical Consent Forms", style: CustomFonts.black20w600),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(4, state),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Icon(Icons.picture_as_pdf_outlined, size: 60.r, color: Colors.red.shade400),
              SizedBox(height: 12.h),
              Text(
                consentName.isNotEmpty ? consentName : "No document configured",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 6.h),
              Text(
                "Requires mandatory clinician-patient signatures before physical or chemical work starts.",
                style: CustomFonts.grey12w400,
                textAlign: TextAlign.center,
              ),
              if (!isDefault) ...[
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    // Mock file upload trigger
                    notifier.updateConsentForm("Clinic_Custom_Clinical_Consent_Form.pdf");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mock custom consent PDF uploaded successfully.")),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey.shade400, width: 1, style: BorderStyle.solid),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                    width: double.infinity,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_file, size: 18.r),
                          SizedBox(width: 8.w),
                          Text("Upload Custom clinical PDF Form", style: CustomFonts.black14w600),
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
        Text("Pre-Treatment Preparation Alerts", style: CustomFonts.black20w600),
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
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
        Text("Post-Treatment Aftercare Alerts", style: CustomFonts.black20w600),
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
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
        SizedBox(height: 16.h),
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
        Text("Clinical Downtime Level", style: CustomFonts.black20w600),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(7, state),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.isLandscape ? 4 : 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.3,
          ),
          itemCount: ClinicDummyData.downtimeLevels.length,
          itemBuilder: (context, idx) {
            final level = ClinicDummyData.downtimeLevels[idx];
            final isSelected = selectedLevel == level;

            Color themeColor;
            switch (level) {
              case 'None':
                themeColor = CustomColors.green;
                break;
              case 'Low':
                themeColor = CustomColors.blueColor;
                break;
              case 'Moderate':
                themeColor = Colors.orange;
                break;
              case 'High':
                themeColor = CustomColors.errorColor;
                break;
              default:
                themeColor = Colors.grey;
            }

            return InkWell(
              onTap: isDefault ? null : () => notifier.updateDowntimeLevel(level),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? themeColor.withOpacity(0.06) : Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected ? themeColor : Colors.grey.shade200,
                    width: isSelected ? 2.0 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _getDowntimeDesc(level),
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
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
        Text("Allowed Provider Roles", style: CustomFonts.black20w600),
        SizedBox(height: 8.h),
        Text("Which practitioner roles are legally allowed to perform this treatment?", style: CustomFonts.grey14w400),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(8, state),

        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: ClinicDummyData.providerRoles.map((role) {
            final isSelected = selectedRoles.contains(role);
            return FilterChip(
              showCheckmark: true,
              checkmarkColor: Colors.white,
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
              label: Text(role),
              selected: isSelected,
              onSelected: isDefault ? null : (selected) {
                notifier.toggleAllowedRole(role);
              },
            );
          }).toList(),
        ),
      ],
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
            Text("Inventory Products Mapping", style: CustomFonts.black20w600),
            if (!isDefault && remainingProducts.isNotEmpty)
              _buildAddProductMenu(remainingProducts),
          ],
        ),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(9, state),

        if (productsList.isEmpty)
          Container(
            padding: EdgeInsets.all(24.r),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r)),
            child: Text("No required medical stock products matched.", style: CustomFonts.grey14w400),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productsList.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, idx) {
              final usage = productsList[idx];
              final p = usage.product;

              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Colors.grey.shade300),
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
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6.r)),
                              child: Icon(Icons.medication, color: Colors.black87, size: 20.r),
                            ),
                            SizedBox(width: 12.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: CustomFonts.black16w600),
                                Text("Unit of Measure (UOM): ${p.uom}", style: CustomFonts.grey12w400),
                              ],
                            ),
                          ],
                        ),
                        if (!isDefault)
                          IconButton(
                            onPressed: () => notifier.removeProductUsage(p.id),
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(height: 8.h),

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
                        SizedBox(width: 12.w),
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
                    SizedBox(height: 12.h),

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
                        SizedBox(width: 12.w),
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
                    SizedBox(height: 12.h),

                    // Allow Substitution
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeColor: Colors.black,
                      title: Text("Allow Clinic Substitutions", style: CustomFonts.black14w500),
                      subtitle: Text("Clinicians can select equivalent brands if this item is out of stock.", style: CustomFonts.grey12w400),
                      value: usage.allowSubstitution,
                      onChanged: isDefault ? null : (val) {
                        notifier.updateProductUsage(p.id, allowSubstitution: val);
                      },
                    ),

                    SizedBox(height: 8.h),
                    Text("Target Injection/Application Sub-Areas", style: CustomFonts.black14w500),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: ["Forehead", "Cheeks", "Glabella", "Crow's Feet", "Lips", "Full Face"].map((area) {
                        final isSelected = usage.targetAreas.contains(area);
                        return ChoiceChip(
                          selectedColor: Colors.black,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 11.sp,
                          ),
                          label: Text(area),
                          selected: isSelected,
                          onSelected: isDefault ? null : (selected) {
                            final updatedAreas = List<String>.from(usage.targetAreas);
                            if (selected) {
                              updatedAreas.add(area);
                            } else {
                              updatedAreas.remove(area);
                            }
                            notifier.updateProductUsage(p.id, targetAreas: updatedAreas);
                          },
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 16.r, color: Colors.white),
              SizedBox(width: 4.w),
              Text("Add Product", style: TextStyle(fontSize: 12.sp, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 250.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        items: remaining.map((ip) {
          return DropdownMenuItem<ClinicDummyProduct>(
            value: ip,
            child: Text(
              "${ip.name} (${ip.uom})",
              style: TextStyle(fontSize: 12.sp),
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
        Text("Treatment Pricing Blueprint", style: CustomFonts.black20w600),
        SizedBox(height: 8.h),
        Text("Define the standard entry session price and custom pricing factors per specific unit of measure.", style: CustomFonts.grey14w400),
        SizedBox(height: 16.h),
        _buildInheritanceToggle(10, state),

        BuildTextField(
          label: "Base Treatment Session Price",
          controller: _basePriceController,
          hintText: "e.g., 150.00",
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.attach_money, color: Colors.black),
          readOnly: isDefault,
          enabled: !isDefault,
          onChanged: (val) {
            final p = double.tryParse(val) ?? 0.0;
            notifier.updateBasePrice(p);
          },
          validator: (val) {
            if (val == null || val.isEmpty) return "Price is required";
            if (double.tryParse(val) == null) return "Invalid price format";
            return null;
          },
        ),

        if (uniqueUoms.isNotEmpty) ...[
          SizedBox(height: 24.h),
          const Divider(),
          SizedBox(height: 16.h),
          Text("Dynamic Unit Overrides", style: CustomFonts.black16w600),
          SizedBox(height: 4.h),
          Text(
            "Configure pricing metrics per consumed product unit to automatically calculate patient invoice adjustments.",
            style: CustomFonts.grey12w400,
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uniqueUoms.length,
            separatorBuilder: (_, __) => SizedBox(height: 14.h),
            itemBuilder: (context, idx) {
              final uom = uniqueUoms[idx];
              final ctrl = _uomControllers[uom];
              if (ctrl == null) return const SizedBox.shrink();

              return BuildTextField(
                label: "Custom Price Per consumed $uom",
                controller: ctrl,
                hintText: "e.g., 15.00",
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money, color: Colors.blue),
                readOnly: isDefault,
                enabled: !isDefault,
                onChanged: (val) {
                  final p = double.tryParse(val) ?? 0.0;
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
        Text("Review Clinical Treatment Blueprint", style: CustomFonts.black20w600),
        SizedBox(height: 8.h),
        Text("Perform a final visual audit of your configuration before saving to your active catalog.", style: CustomFonts.grey14w400),
        SizedBox(height: 20.h),

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
        _buildReviewRow("Base Session Price", "\$${state.effectiveBasePrice.toStringAsFixed(2)}"),
        ...products.map((p) => _buildReviewRow("  • stock product", "${p.product.name} [Min: ${p.minQty}, Max: ${p.maxQty} ${p.product.uom}s]")),
        ...uniqueUoms.map((uom) => _buildReviewRow("  • dynamic rate per $uom", "\$${state.getEffectiveUomPrice(uom).toStringAsFixed(2)}")),
      ],
    );
  }

  Widget _buildReviewSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 11.sp, color: Colors.blue.shade700, fontWeight: FontWeight.bold, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildReviewRow(String label, String val) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              val.isEmpty ? "—" : val,
              style: TextStyle(fontSize: 13.sp, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // Warning when no template selected
  Widget _buildTemplateWarning() {
    return Container(
      padding: EdgeInsets.all(24.r),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40.r),
          SizedBox(height: 12.h),
          Text("No Baseline Template Selected", style: CustomFonts.black16w600),
          SizedBox(height: 6.h),
          Text(
            "Please navigate to Step 1 and choose a treatment template first.",
            style: CustomFonts.grey14w400,
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
        Text(label, style: CustomFonts.black14w500),
        SizedBox(height: 10.h),
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              "Select options",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            ),
            value: items.contains(value) ? value : null,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: enabled ? onChanged : null,
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: enabled ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300!),
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
        Text(label, style: CustomFonts.black12w600),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue.toString(),
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
          ),
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
        Text(label, style: CustomFonts.black12w600),
        SizedBox(height: 8.h),
        TextFormField(
          initialValue: initialValue.toString(),
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6.r)),
          ),
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
          OutlinedButton(
            onPressed: () => notifier.prevStep(),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Text("Previous", style: CustomFonts.black14w600),
          ),
          SizedBox(width: 12.w),
        ],
        const Spacer(),
        if (!isLast)
          ElevatedButton(
            onPressed: state.selectedTemplate == null
                ? null
                : () {
                    // Custom validation rules per step if required
                    if (_formKey.currentState?.validate() ?? true) {
                      notifier.nextStep();
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Next Step", style: CustomFonts.white14w600),
                SizedBox(width: 8.w),
                const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
              ],
            ),
          )
        else ...[
          OutlinedButton(
            onPressed: () => _handleSave(isDraft: true),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Text("Save Draft", style: CustomFonts.black14w600),
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () => _handleSave(isDraft: false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: Text("Save Treatment", style: CustomFonts.white14w600),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: Padding(
            padding: EdgeInsets.all(32.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 40.r, color: Colors.white),
                ),
                SizedBox(height: 24.h),
                Text(
                  isDraft ? "Draft Saved Successfully!" : "Treatment Added Successfully!",
                  style: CustomFonts.black20w700,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  isDraft
                      ? "The clinical blueprint has been recorded as a draft in your local workspace."
                      : "The treatment configuration has been fully finalized and updated in your clinic active catalog.",
                  style: CustomFonts.grey14w400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(); // Dismiss success dialog
                      ref.read(clinicAddTreatmentViewModelProvider.notifier).reset();
                      context.pop(); // Navigate back to treatments screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("Return to Catalog", style: CustomFonts.white14w600),
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
