import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/treatment_template_list_response.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';
import '../utils/clinic_dummy_data.dart';
import 'base_view_model.dart';

final clinicAddTreatmentViewModelProvider = NotifierProvider<ClinicAddTreatmentViewModel, ClinicAddTreatmentState>(
  () => ClinicAddTreatmentViewModel._(),
);

class ClinicAddTreatmentState {
  final ClinicDummyTreatmentTemplate? selectedTemplate;
  final int activeStep;
  final Map<int, bool> stepIsDefault;

  // Custom configuration states
  final String name;
  final String patientDisplayName;
  final String description;
  final String status;
  final List<ClinicDummySession> sessions;
  final String consentFormName;
  final String preNotificationTitle;
  final String preNotificationMessage;
  final String preNotificationTiming;
  final String postNotificationTitle;
  final String postNotificationMessage;
  final String postNotificationTiming;
  final String downtimeLevel;
  final List<String> allowedRoles;
  final List<ClinicDummyProductUsage> products;
  final double basePrice;
  final Map<String, double> uomPrices;

  // Pagination states
  final List<TreatmentTemplateItemModel> templates;
  final bool isLoadingTemplates;
  final int templatesPage;
  final int templatesTotalPages;
  final bool templatesHasMore;
  final String templatesSearch;
  final String? templatesError;


  ClinicAddTreatmentState({
    this.selectedTemplate,
    this.activeStep = 0,
    this.stepIsDefault = const {
      1: true,  // Basic Info
      2: true,  // Sessions
      3: true,  // Follow-up
      4: true,  // Consent Form
      5: true,  // Pre-Notifications
      6: true,  // Post-Notifications
      7: true,  // Downtime Level
      8: true,  // Allowed Provider Roles
      9: true,  // Inventory Products
      10: true, // Pricing Setup
    },
    this.name = '',
    this.patientDisplayName = '',
    this.description = '',
    this.status = 'Draft',
    this.sessions = const [],
    this.consentFormName = '',
    this.preNotificationTitle = '',
    this.preNotificationMessage = '',
    this.preNotificationTiming = '24 Hours Before',
    this.postNotificationTitle = '',
    this.postNotificationMessage = '',
    this.postNotificationTiming = '24 Hours After',
    this.downtimeLevel = 'None',
    this.allowedRoles = const [],
    this.products = const [],
    this.basePrice = 0.0,
    this.uomPrices = const {},
    this.templates = const [],
    this.isLoadingTemplates = false,
    this.templatesPage = 1,
    this.templatesTotalPages = 1,
    this.templatesHasMore = true,
    this.templatesSearch = '',
    this.templatesError,
  });

  ClinicAddTreatmentState copyWith({
    ClinicDummyTreatmentTemplate? selectedTemplate,
    int? activeStep,
    Map<int, bool>? stepIsDefault,
    String? name,
    String? patientDisplayName,
    String? description,
    String? status,
    List<ClinicDummySession>? sessions,
    String? consentFormName,
    String? preNotificationTitle,
    String? preNotificationMessage,
    String? preNotificationTiming,
    String? postNotificationTitle,
    String? postNotificationMessage,
    String? postNotificationTiming,
    String? downtimeLevel,
    List<String>? allowedRoles,
    List<ClinicDummyProductUsage>? products,
    double? basePrice,
    Map<String, double>? uomPrices,
    List<TreatmentTemplateItemModel>? templates,
    bool? isLoadingTemplates,
    int? templatesPage,
    int? templatesTotalPages,
    bool? templatesHasMore,
    String? templatesSearch,
    String? templatesError,
  }) {
    return ClinicAddTreatmentState(
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      activeStep: activeStep ?? this.activeStep,
      stepIsDefault: stepIsDefault ?? this.stepIsDefault,
      name: name ?? this.name,
      patientDisplayName: patientDisplayName ?? this.patientDisplayName,
      description: description ?? this.description,
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      consentFormName: consentFormName ?? this.consentFormName,
      preNotificationTitle: preNotificationTitle ?? this.preNotificationTitle,
      preNotificationMessage: preNotificationMessage ?? this.preNotificationMessage,
      preNotificationTiming: preNotificationTiming ?? this.preNotificationTiming,
      postNotificationTitle: postNotificationTitle ?? this.postNotificationTitle,
      postNotificationMessage: postNotificationMessage ?? this.postNotificationMessage,
      postNotificationTiming: postNotificationTiming ?? this.postNotificationTiming,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      products: products ?? this.products,
      basePrice: basePrice ?? this.basePrice,
      uomPrices: uomPrices ?? this.uomPrices,
      templates: templates ?? this.templates,
      isLoadingTemplates: isLoadingTemplates ?? this.isLoadingTemplates,
      templatesPage: templatesPage ?? this.templatesPage,
      templatesTotalPages: templatesTotalPages ?? this.templatesTotalPages,
      templatesHasMore: templatesHasMore ?? this.templatesHasMore,
      templatesSearch: templatesSearch ?? this.templatesSearch,
      templatesError: templatesError ?? this.templatesError,
    );
  }

  // Value resolution logic (Inheritance vs Custom overrides)
  String get effectiveName => (stepIsDefault[1] ?? true) ? (selectedTemplate?.name ?? '') : name;
  String get effectivePatientDisplayName => (stepIsDefault[1] ?? true) ? (selectedTemplate?.patientDisplayName ?? '') : patientDisplayName;
  String get effectiveDescription => (stepIsDefault[1] ?? true) ? (selectedTemplate?.description ?? '') : description;
  String get effectiveStatus => (stepIsDefault[1] ?? true) ? (selectedTemplate?.status ?? 'Draft') : status;

  List<ClinicDummySession> get effectiveSessions {
    final useDefault = stepIsDefault[2] ?? true;
    if (useDefault) {
      return selectedTemplate?.sessions ?? [];
    }
    return sessions;
  }

  String get effectiveConsentFormName => (stepIsDefault[4] ?? true) ? (selectedTemplate?.consentFormName ?? '') : consentFormName;

  String get effectivePreNotificationTitle => (stepIsDefault[5] ?? true) ? (selectedTemplate?.preTreatmentNotificationTitle ?? '') : preNotificationTitle;
  String get effectivePreNotificationMessage => (stepIsDefault[5] ?? true) ? (selectedTemplate?.preTreatmentNotificationMessage ?? '') : preNotificationMessage;
  String get effectivePreNotificationTiming => (stepIsDefault[5] ?? true) ? (selectedTemplate?.preTreatmentNotificationTiming ?? '24 Hours Before') : preNotificationTiming;

  String get effectivePostNotificationTitle => (stepIsDefault[6] ?? true) ? (selectedTemplate?.postTreatmentNotificationTitle ?? '') : postNotificationTitle;
  String get effectivePostNotificationMessage => (stepIsDefault[6] ?? true) ? (selectedTemplate?.postTreatmentNotificationMessage ?? '') : postNotificationMessage;
  String get effectivePostNotificationTiming => (stepIsDefault[6] ?? true) ? (selectedTemplate?.postTreatmentNotificationTiming ?? '24 Hours After') : postNotificationTiming;

  String get effectiveDowntimeLevel => (stepIsDefault[7] ?? true) ? (selectedTemplate?.downtimeLevel ?? 'None') : downtimeLevel;

  List<String> get effectiveAllowedRoles => (stepIsDefault[8] ?? true) ? (selectedTemplate?.allowedRoles ?? []) : allowedRoles;

  List<ClinicDummyProductUsage> get effectiveProducts => (stepIsDefault[9] ?? true) ? (selectedTemplate?.products ?? []) : products;

  double get effectiveBasePrice => (stepIsDefault[10] ?? true) ? (selectedTemplate?.basePrice ?? 0.0) : basePrice;

  double getEffectiveUomPrice(String uom) {
    if (stepIsDefault[10] ?? true) {
      if (uom == 'Unit') return 12.0;
      if (uom == 'Syringe') return 600.0;
      if (uom == 'Vial') return 400.0;
      if (uom == 'Kit') return 250.0;
      if (uom == 'Tube') return 50.0;
      return 100.0;
    }
    return uomPrices[uom] ?? (uom == 'Unit' ? 12.0 : uom == 'Syringe' ? 600.0 : uom == 'Vial' ? 400.0 : uom == 'Kit' ? 250.0 : uom == 'Tube' ? 50.0 : 100.0);
  }
}

class ClinicAddTreatmentViewModel extends BaseViewModel<ClinicAddTreatmentState> {
  ClinicAddTreatmentViewModel._();

  Timer? _searchDebounce;

  @override
  ClinicAddTreatmentState build() {
    init();
    ref.onDispose(dispose);
    return ClinicAddTreatmentState();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> fetchTemplates({bool isRefresh = false}) async {
    if (state.isLoadingTemplates) return;

    final int targetPage = isRefresh ? 1 : state.templatesPage;
    if (!isRefresh && !state.templatesHasMore) return;

    state = state.copyWith(
      isLoadingTemplates: true,
      templatesError: null,
      templatesPage: targetPage,
      templates: isRefresh ? [] : state.templates,
    );

    try {
      final repository = locator<TreatmentRepository>();
      final response = await repository.getTreatmentTemplates(
        page: targetPage,
        limit: 10,
        search: state.templatesSearch,
      );

      final List<TreatmentTemplateItemModel> newTemplates = response.data ?? [];
      final int totalPages = response.totalPages ?? 1;

      state = state.copyWith(
        templates: isRefresh ? newTemplates : [...state.templates, ...newTemplates],
        isLoadingTemplates: false,
        templatesPage: targetPage + 1,
        templatesTotalPages: totalPages,
        templatesHasMore: targetPage < totalPages && newTemplates.isNotEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingTemplates: false,
        templatesError: e.toString().replaceAll('Exception:', '').trim(),
        templatesHasMore: false,
      );
    }
  }

  void onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    state = state.copyWith(templatesSearch: query);

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchTemplates(isRefresh: true);
    });
  }

  void selectTemplate(TreatmentTemplateItemModel item) {
    // Convert to ClinicDummyTreatmentTemplate to preserve wizard compatibility
    final template = ClinicDummyTreatmentTemplate(
      id: item.id?.toString() ?? '',
      name: item.name ?? '',
      patientDisplayName: item.name ?? '',
      category: 'Injectables',
      subcategory: 'Neuromodulators',
      sku: item.globalSku ?? '',
      description: item.shortDescription ?? '',
      status: item.status ?? 'Draft',
      sessions: [
        ClinicDummySession(
          number: 1,
          followUps: [
            ClinicDummyFollowUp(
              appointmentType: 'In-Person',
              intervalValue: 1,
              intervalUnit: 'Weeks',
              isImageUploadMandatory: false,
              clinicalInstructions: '',
            )
          ],
        )
      ],
      consentFormName: 'Clinic_Standard_Clinical_Consent_Form.pdf',
      preTreatmentNotificationTitle: 'Preparing for Treatment',
      preTreatmentNotificationMessage: 'Please follow the preparation guidelines.',
      preTreatmentNotificationTiming: '24 Hours Before',
      postTreatmentNotificationTitle: 'Aftercare Instructions',
      postTreatmentNotificationMessage: 'Please follow the aftercare guidelines.',
      postTreatmentNotificationTiming: '24 Hours After',
      downtimeLevel: 'None',
      allowedRoles: ['Injector'],
      products: [],
      basePrice: 0.0,
    );

    // Deep copy sessions
    final copiedSessions = template.sessions.map((s) {
      return ClinicDummySession(
        number: s.number,
        followUps: s.followUps.map((f) => ClinicDummyFollowUp(
          appointmentType: f.appointmentType,
          intervalValue: f.intervalValue,
          intervalUnit: f.intervalUnit,
          isImageUploadMandatory: f.isImageUploadMandatory,
          clinicalInstructions: f.clinicalInstructions,
        )).toList(),
      );
    }).toList();

    state = state.copyWith(
      selectedTemplate: template,
      name: template.name,
      patientDisplayName: template.patientDisplayName,
      description: template.description,
      status: template.status,
      sessions: copiedSessions,
      consentFormName: template.consentFormName,
      preNotificationTitle: template.preTreatmentNotificationTitle,
      preNotificationMessage: template.preTreatmentNotificationMessage,
      preNotificationTiming: template.preTreatmentNotificationTiming,
      postNotificationTitle: template.postTreatmentNotificationTitle,
      postNotificationMessage: template.postTreatmentNotificationMessage,
      postNotificationTiming: template.postTreatmentNotificationTiming,
      downtimeLevel: template.downtimeLevel,
      allowedRoles: List<String>.from(template.allowedRoles),
      products: [],
      basePrice: template.basePrice,
      uomPrices: {
        'Unit': 12.0,
        'Syringe': 600.0,
        'Vial': 400.0,
        'Kit': 250.0,
        'Tube': 50.0,
      },
    );
  }

  void setStepIsDefault(int step, bool isDefault) {
    final updatedMap = Map<int, bool>.from(state.stepIsDefault);
    updatedMap[step] = isDefault;
    state = state.copyWith(stepIsDefault: updatedMap);
  }

  void updateBasicInfo({
    String? name,
    String? patientDisplayName,
    String? description,
    String? status,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      patientDisplayName: patientDisplayName ?? state.patientDisplayName,
      description: description ?? state.description,
      status: status ?? state.status,
    );
  }

  void addSession() {
    final nextNum = state.sessions.length + 1;
    final updated = [
      ...state.sessions,
      ClinicDummySession(
        number: nextNum,
        followUps: [],
      )
    ];
    state = state.copyWith(sessions: updated);
  }

  void removeSession(int index) {
    if (index < 0 || index >= state.sessions.length) return;
    final updated = List<ClinicDummySession>.from(state.sessions);
    updated.removeAt(index);
    // Re-number subsequent sessions
    for (int i = 0; i < updated.length; i++) {
      updated[i] = ClinicDummySession(
        number: i + 1,
        followUps: updated[i].followUps,
      );
    }
    state = state.copyWith(sessions: updated);
  }

  void addFollowUp(int sessionIndex) {
    if (sessionIndex < 0 || sessionIndex >= state.sessions.length) return;
    final updated = List<ClinicDummySession>.from(state.sessions);
    final session = updated[sessionIndex];
    final updatedFollowUps = [
      ...session.followUps,
      ClinicDummyFollowUp(
        appointmentType: 'In-Person',
        intervalValue: 1,
        intervalUnit: 'Weeks',
        isImageUploadMandatory: false,
        clinicalInstructions: '',
      )
    ];
    updated[sessionIndex] = ClinicDummySession(
      number: session.number,
      followUps: updatedFollowUps,
    );
    state = state.copyWith(sessions: updated);
  }

  void removeFollowUp(int sessionIndex, int followUpIndex) {
    if (sessionIndex < 0 || sessionIndex >= state.sessions.length) return;
    final updated = List<ClinicDummySession>.from(state.sessions);
    final session = updated[sessionIndex];
    if (followUpIndex < 0 || followUpIndex >= session.followUps.length) return;
    final updatedFollowUps = List<ClinicDummyFollowUp>.from(session.followUps);
    updatedFollowUps.removeAt(followUpIndex);
    updated[sessionIndex] = ClinicDummySession(
      number: session.number,
      followUps: updatedFollowUps,
    );
    state = state.copyWith(sessions: updated);
  }

  void updateFollowUp(int sessionIndex, int followUpIndex, {
    String? appointmentType,
    int? intervalValue,
    String? intervalUnit,
    bool? isImageUploadMandatory,
    String? clinicalInstructions,
  }) {
    if (sessionIndex < 0 || sessionIndex >= state.sessions.length) return;
    final updated = List<ClinicDummySession>.from(state.sessions);
    final session = updated[sessionIndex];
    if (followUpIndex < 0 || followUpIndex >= session.followUps.length) return;
    final updatedFollowUps = List<ClinicDummyFollowUp>.from(session.followUps);
    final old = updatedFollowUps[followUpIndex];
    updatedFollowUps[followUpIndex] = old.copyWith(
      appointmentType: appointmentType,
      intervalValue: intervalValue,
      intervalUnit: intervalUnit,
      isImageUploadMandatory: isImageUploadMandatory,
      clinicalInstructions: clinicalInstructions,
    );
    updated[sessionIndex] = ClinicDummySession(
      number: session.number,
      followUps: updatedFollowUps,
    );
    state = state.copyWith(sessions: updated);
  }

  void updateConsentForm(String name) {
    state = state.copyWith(consentFormName: name);
  }

  void updatePreNotification({
    String? title,
    String? message,
    String? timing,
  }) {
    state = state.copyWith(
      preNotificationTitle: title ?? state.preNotificationTitle,
      preNotificationMessage: message ?? state.preNotificationMessage,
      preNotificationTiming: timing ?? state.preNotificationTiming,
    );
  }

  void updatePostNotification({
    String? title,
    String? message,
    String? timing,
  }) {
    state = state.copyWith(
      postNotificationTitle: title ?? state.postNotificationTitle,
      postNotificationMessage: message ?? state.postNotificationMessage,
      postNotificationTiming: timing ?? state.postNotificationTiming,
    );
  }

  void updateDowntimeLevel(String level) {
    state = state.copyWith(downtimeLevel: level);
  }

  void toggleAllowedRole(String role) {
    final updated = List<String>.from(state.allowedRoles);
    if (updated.contains(role)) {
      updated.remove(role);
    } else {
      updated.add(role);
    }
    state = state.copyWith(allowedRoles: updated);
  }

  void addProductUsage(ClinicDummyProduct product) {
    // Prevent adding duplicates
    if (state.products.any((p) => p.product.id == product.id)) return;
    final updated = [
      ...state.products,
      ClinicDummyProductUsage(
        product: product,
        usageType: 'Required',
        deductionTiming: 'On Completion',
        allowSubstitution: false,
        minQty: 1,
        maxQty: 10,
        targetAreas: ['Full Face'],
      )
    ];
    state = state.copyWith(products: updated);
  }

  void removeProductUsage(String productId) {
    final updated = state.products.where((p) => p.product.id != productId).toList();
    state = state.copyWith(products: updated);
  }

  void updateProductUsage(String productId, {
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
    double? minQty,
    double? maxQty,
    List<String>? targetAreas,
  }) {
    final updated = state.products.map((p) {
      if (p.product.id == productId) {
        return p.copyWith(
          usageType: usageType,
          deductionTiming: deductionTiming,
          allowSubstitution: allowSubstitution,
          minQty: minQty,
          maxQty: maxQty,
          targetAreas: targetAreas,
        );
      }
      return p;
    }).toList();
    state = state.copyWith(products: updated);
  }

  void updateBasePrice(double price) {
    state = state.copyWith(basePrice: price);
  }

  void updateUomPrice(String uom, double price) {
    final updated = Map<String, double>.from(state.uomPrices);
    updated[uom] = price;
    state = state.copyWith(uomPrices: updated);
  }

  void setStep(int step) {
    if (step >= 0 && step < 12) {
      state = state.copyWith(activeStep: step);
    }
  }

  void nextStep() {
    if (state.activeStep < 11) {
      state = state.copyWith(activeStep: state.activeStep + 1);
    }
  }

  void prevStep() {
    if (state.activeStep > 0) {
      state = state.copyWith(activeStep: state.activeStep - 1);
    }
  }

  void reset() {
    state = ClinicAddTreatmentState();
  }

  void setTemplatesPage(int page) {
    state = state.copyWith(
      templatesPage: page,
      templatesHasMore: true,
    );
    fetchTemplates(isRefresh: true);
  }
}
