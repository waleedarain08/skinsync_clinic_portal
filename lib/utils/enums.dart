import 'package:flutter/material.dart';

import '../exceptions/app_exception.dart';

enum SharedPreferencesKeys {
  themeModeKey("theme-mode"),
  accessTokenKey("access-token"),
  refreshTokenKey('refresh-token'),
  accessTokenExpiryKey('access-token-expiry'),
  refreshTokenExpiryKey('refresh-token-expiry'),
  userKey('user-key');

  const SharedPreferencesKeys(this.keyText);

  final String keyText;
}

enum DoctorRole { owner, doctor, injector }

enum Role { doctor, injector, user }

enum Endpoint {
  login('clinic/login'),
  refreshToken('clinic/auth/refresh'),
  me('clinic/me'),
  getClinicTreatments('clinic/treatments/list'),
  createDoctor('clinic/practitioners/register'),
  getPractitioners('clinic/practitioners'),
  practitionersID('clinic/practitioners/{id}'),
  practitionerStatus('clinic/practitioners/{id}/status'),
  fetchPractitionerByEmail('clinic/practitioners/fetch'),
  getAdminTreatments('clinic/treatments/admin'),
  getTreatmentTemplates('clinic/treatments/admin'),
  getAdminTreatmentsSideAreas('clinic/treatments/admin/{treatmentId}/areas'),
  addClinicTreatment('clinic/treatments/batch'),
  changePassword('clinic/change-password'),
  forgetPassword('clinic/forgot-password'),
  resetPassword('clinic/reset-password'),
  verifyOtp('clinic/verify-reset-otp'),
  treatmentsStatus('clinic/treatments/status'),
  deleteTreatment('clinic/treatments/{treatment_id}'),
  updateDoctorTreatment('clinic/doctors'),
  getFeature("clinic/features"),
  roles("clinic/roles"),
  catalog('clinic/products/catalog'),
  clinicProducts('clinic/products'),
  createAppointment('clinic/appointments'),
  getAppointment('clinic/new-appointments'),
  appointmentId('clinic/new-appointments/{id}'),
  treatmentDetail('clinic/treatments/{id}'),
  sessionUpdate('clinic/sessions/update'),
  sessionDetail('clinic/sessions/{id}'),
  deleteSession('admin/sessions/{id}'),
  sessionStatus('clinic/sessions/status'),
  products('admin/products'),
  updateProduct('clinic/products/{id}'),
  deleteProduct('admin/products/{id}'),
  getBrands('admin/brands'),
  unitTypesList('admin/unit-types'),
  packageTypeList('admin/package-types'),
  usageType('clinic/usage-types'),
  manufacturersList('admin/manufacturers'),
  suppliers('admin/suppliers'),
  adminProductList('clinic/admin-products/list'),
  batchLots('clinic/products/batches/{batchId}/lots'),
  productBatches('clinic/products/{productId}/batches'),
  lotItems('clinic/products/lots/{lotId}/items'),
  updateLotItem('clinic/products/lot-items/{id}'),
  appointmentStatuses('clinic/appointment-statuses'),
  providerRoles('clinic/provider-roles'),
  appointmentTypes('clinic/appointment-types'),
  areasAvailable('clinic/treatments/{treatmentId}/available-areas'),
  areas('clinic/treatments/{treatmentId}/areas'),
  treatmentAreas('clinic/treatments/{treatmentId}/session-areas'),
  sessionMaterials('clinic/session-materials/{treatmentId}/{areaId}'),
  treatmentCost('clinic/treatment-cost'),
  bookingMethods('clinic/booking-methods'),
  adminAreas('admin/treatments/{treatmentId}/areas'),
  explorerReels('clinic/reels'),
  updateReel('clinic/reels/{id}'),
  explorerCommunity('clinic/community-posts'),
  updatePost('clinic/community-posts/{id}'),
  postCategories('clinic/community-post/categories'),
  patients('clinic/patients'),
  patientDetail('clinic/patients/{id}'),
  patientRegister('clinic/patient/register'),
  patientTreatmentRequest('clinic/patient-treatment-request'),
  getMe("clinic/me"),
  updateClinicProfile('clinic/profile'),
  deductionTimings('clinic/deduction-timings'),
  downTimeLevel('clinic/treatments/{id}/downtime-presets'),
  notification('clinic/notifications'),
  clinicDetail('clinic/detail'),
  chats('clinic/chats'),
  messages('clinic/chats/messages'),
  addPractitioner('clinic/chat/practitioners'),
  protocolFields('clinic/protocol_fields'),
  staffRole('clinic/staff-roles'),
  createStaff('clinic/register-staff'),
  revenue('clinic/revenue'),
  staff('clinic/staff'),
  appointmentsAvailability('clinic/appointments/availability'),
  aiOnboardingChat('clinic/ai-onboarding/chat'),
  clinicCurrentPlan('clinic/clinic-current-plan'),
  subscribe('clinic/subscribe'),
  clinicalJourney('clinic/clinical-journey'),
  treatmentProgress('clinic/treatment-progress');

  final String path;

  const Endpoint(this.path);

  String withParams(Map<String, String> params) {
    var updatedPath = path;
    params.forEach((key, value) {
      updatedPath = updatedPath.replaceAll('{$key}', value);
    });
    return updatedPath;
  }
}

enum AiEndpoint {
  onboardingMessage('onboarding/message'),
  treatmentMessage('treatment/message');

  final String path;

  const AiEndpoint(this.path);

  String withParams(Map<String, String> params) {
    var updatedPath = path;
    params.forEach((key, value) {
      updatedPath = updatedPath.replaceAll('{$key}', value);
    });
    return updatedPath;
  }
}

enum BaseUrls {
  api('https://api.skinsyncai.com/api/'),
  apiQa('https://api-dev.skinsyncai.com/api/');

  // apiQa('http://localhost:8084/api/');

  final String url;

  const BaseUrls(this.url);
}

enum AiBaseUrls {
  live('http://18.116.65.70:8003/api/v1/'),
  ngrok('https://parchment-repressed-outskirts.ngrok-free.dev/api/v1/');

  // apiQa('http://localhost:8084/api/');

  final String url;

  const AiBaseUrls(this.url);
}

enum AuthScreen { login, forgetPassword, verifyOtp, createNewPassword }

enum ProductStatus {
  all('All'),
  active('Active'),
  inactive('In Active');

  final String label;

  const ProductStatus(this.label);
}

enum CreateTreatmentSteps {
  allowedProviderRoles('allowed_provider_roles'),
  patientConsent('patient_consent'),
  phaseNotifications('phase_notifications'),
  postTreatmentInstructions('post_treatment_instructions'),
  preTreatmentInstructions('pre_treatment_instructions'),
  inventoryProducts('inventory_products'),
  protocols('protocols'),
  sessionsSetup('sessions_setup'),
  pricing('pricing'),
  categories('categories'),
  treatmentAreas('treatment_areas'),
  scheduling('scheduling'),
  postTreatmentPhotos('post_treatment_photos'),
  downtimeLevel('downtime_level'),
  followUpSetup('follow_up_setup'),
  businessLogic('business_logic'),
  basicInfo('basic_info'),
  getBrands('admin/brands'),
  unitTypesList('admin/unit-types'),
  packageTypeList('admin/package-types'),
  usageType('admin/usage-types'),
  status("status");

  final String name;

  const CreateTreatmentSteps(this.name);
}

enum Status { active, inactive }

enum AppointmentStatus {
  inReview('in_review', 'In Review'),
  changesRequested('changes_requested', 'Changes Requested'),
  awaitingPatient('awaiting_patient', 'Awaiting Patient'),
  confirmed('confirmed', 'Confirmed'),
  pending('pending', 'Pending'),
  scheduled('scheduled', 'Scheduled'),
  rescheduled('rescheduled', 'Rescheduled'),
  checked_in('checked_in', 'Checked In'),
  in_progress('in_progress', 'In Progress'),
  no_show('no_show', 'No Show'),
  completed('completed', 'Completed'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String label;

  const AppointmentStatus(this.value, this.label);

  Color get color {
    switch (this) {
      // Intake / review stage: cool neutrals and purples
      case AppointmentStatus.inReview:
        return const Color(0xFF7C3AED); // violet
      case AppointmentStatus.changesRequested:
        return const Color(0xFFEA580C); // deep orange (needs action)
      case AppointmentStatus.awaitingPatient:
        return const Color(0xFF0891B2); // cyan (waiting on patient)

      // Booked stage: blues and greens
      case AppointmentStatus.pending:
        return const Color(0xFF6B7280); // gray (not yet decided)
      case AppointmentStatus.scheduled:
        return const Color(0xFF2563EB); // blue
      case AppointmentStatus.confirmed:
        return const Color(0xFF16A34A); // green
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFFA500); // orange (existing)

      // Day-of stage
      case AppointmentStatus.checked_in:
        return const Color(0xFF155DFC); // strong blue (existing "arrived")
      case AppointmentStatus.in_progress:
        return const Color(0xFFF2C54A); // amber (existing "ongoing")

      // Terminal stage
      case AppointmentStatus.completed:
        return Colors.black; // existing
      case AppointmentStatus.no_show:
        return const Color(0xFF939393); // gray (existing)
      case AppointmentStatus.cancelled:
        return const Color(0xFFFB2C36); // red (existing "delayed" red)
    }
  }

  bool get isInReview =>
      this == AppointmentStatus.inReview || this == AppointmentStatus.pending;
  bool get isChangesRequested => this == AppointmentStatus.changesRequested;
  bool get isAwaitingPatient => this == AppointmentStatus.awaitingPatient;
  bool get isConfirmed => this == AppointmentStatus.confirmed;
  bool get isPending => this == AppointmentStatus.pending;
  bool get isCompleted => this == AppointmentStatus.completed;
  bool get isCancelled => this == AppointmentStatus.cancelled;

  static List<String> get valuesList =>
      AppointmentStatus.values.map((e) => e.value).toList();

  static AppointmentStatus fromValue(String? value) {
    if (value == null) return AppointmentStatus.pending;
    final val = value.toLowerCase().trim().replaceAll('-', '_');
    switch (val) {
      case 'in_review':
        return AppointmentStatus.inReview;
      case 'changes_requested':
        return AppointmentStatus.changesRequested;
      case 'awaiting_patient':
        return AppointmentStatus.awaitingPatient;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
      case 'canceled':
        return AppointmentStatus.cancelled;
      case 'pending':
      default:
        return AppointmentStatus.pending;
    }
  }
}

enum ProtocolType {
  checkbox('checkbox'),
  textField('textField'),
  text('text');

  final String value;
  const ProtocolType(this.value);

  bool get isTextField =>
      this == ProtocolType.textField || this == ProtocolType.text;
  bool get isCheckbox => this == ProtocolType.checkbox;

  static ProtocolType fromString(String? type) {
    final lower = type?.toString().toLowerCase() ?? '';
    if (lower == 'textfield' || lower == 'text') {
      return ProtocolType.textField;
    }
    return ProtocolType.checkbox;
  }
}

enum LotItemStatus {
  available('available', 'Available'),
  allocated('allocated', 'Allocated'),
  used('used', 'Used'),
  reserved('reserved', 'Reserved'),
  damaged('damaged', 'Damaged');

  const LotItemStatus(this.value, this.label);

  final String value;
  final String label;
}

enum AppointmentFilter {
  all,
  past,
  today,
  upcoming,
  followup;

  String get label {
    switch (this) {
      case AppointmentFilter.all:
        return "All Appointments";
      case AppointmentFilter.past:
        return "Past Appointments";
      case AppointmentFilter.today:
        return "Today Appointments";
      case AppointmentFilter.upcoming:
        return "Upcoming Appointments";
      case AppointmentFilter.followup:
        return "Followup";
    }
  }

  static AppointmentFilter fromLabel(String label) {
    return AppointmentFilter.values.firstWhere(
      (e) => e.label == label,
      orElse: () => AppointmentFilter.all,
    );
  }
}

enum DiscountType { per, flat }

enum RequestType {
  post('POST'),
  get('GET'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE'),
  multipartPost('MULTIPART-POST'),
  multipartPatch('MULTIPART-PATCH');

  final String label;

  const RequestType(this.label);
}

enum MessageType {
  text('text', 'Text'),
  normal('normal', 'Normal'),
  media('media', 'Media'),
  document('document', 'Document'),
  sharedRequest('request', 'Shared Request'),
  appointment('appointment', 'Appointment'),
  planApproval('plan_approval', 'Plan Approval'),
  treatmentInstructions('treatment_instructions', 'Treatment Instructions'),
  sessionCompleted('session_completed', 'Session Completed'),
  consentForm('consent_form', 'Consent Form');

  final String value;
  final String label;

  const MessageType(this.value, this.label);

  static MessageType fromValue(String? value) {
    if (value == null) return MessageType.text;
    final val = value.toLowerCase();
    return MessageType.values.firstWhere(
      (e) => e.value.toLowerCase() == val,
      orElse: () => MessageType.text,
    );
  }
}

enum AiChatMessageType {
  text('text', 'Text'),
  question('question', 'Question'),
  optionSelection('optionSelection', 'Option Selection'),
  treatmentDraft('treatmentDraft', 'Treatment Draft');

  final String value;
  final String label;

  const AiChatMessageType(this.value, this.label);

  static AiChatMessageType fromValue(String? value) {
    if (value == null) return AiChatMessageType.text;
    final val = value.toLowerCase();
    return AiChatMessageType.values.firstWhere(
      (e) => e.value.toLowerCase() == val,
      orElse: () => AiChatMessageType.text,
    );
  }
}

enum EventType {
  message('message'),
  appointment('appointment'),
  newAppointment('new_appointment'),
  error('error'),
  subscription('subscription'),
  requestShared('request_shared'),
  newChat('new_chat'),
  rescheduleAppointment('reschedule_appointment');

  final String value;

  const EventType(this.value);

  static EventType fromValue(String? value) {
    if (value == null) {
      throw const UnknownException(message: 'Invalid event type value');
    }
    final val = value.toLowerCase();
    return EventType.values.firstWhere((e) => e.value.toLowerCase() == val);
  }
}
