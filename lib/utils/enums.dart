import 'package:flutter/material.dart';

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
  adminAreas('admin/treatments/{treatmentId}/areas'),
  explorerReels('clinic/reels'),
  updateReel('clinic/reels/{id}'),
  explorerCommunity('clinic/community-posts'),
  updatePost('clinic/community-posts/{id}'),
  postCategories('clinic/community-post/categories'),
  patients('clinic/patients'),
  patientDetail('clinic/patients/{id}'),
  patientTreatmentRequest('clinic/patient-treatment-request'),
  getMe("clinic/me"),
  updateClinicProfile('clinic/profile'),
  deductionTimings('clinic/deduction-timings'),
  downTimeLevel('clinic/treatments/{id}/downtime-presets'),
  notification('clinic/notifications'),
  clinicDetail('clinic/detail');

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

enum BaseUrls {
  api('https://api.skinsyncai.com/api/'),
  apiQa('https://api-dev.skinsyncai.com/api/');

  final String url;

  const BaseUrls(this.url);
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
  allStatus,
  noShow,
  delayed,
  completed,
  arrived,
  rescheduled,
  ongoing;

  String get label {
    switch (this) {
      case AppointmentStatus.allStatus:
        return 'All Status';
      case AppointmentStatus.noShow:
        return 'No Show';
      case AppointmentStatus.delayed:
        return 'Delayed';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.arrived:
        return 'Arrived';
      case AppointmentStatus.ongoing:
        return 'Ongoing';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.allStatus:
        return Colors.grey;
      case AppointmentStatus.noShow:
        return const Color(0xFF939393);
      case AppointmentStatus.delayed:
        return const Color(0xFFFB2C36);
      case AppointmentStatus.completed:
        return Colors.black;
      case AppointmentStatus.arrived:
        return const Color(0xFF155DFC);
      case AppointmentStatus.ongoing:
        return const Color(0xFFF2C54A);
      case AppointmentStatus.rescheduled:
        return const Color(0xFFFFA500);
    }
  }

  static AppointmentStatus fromLabel(String label) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.label == label,
      orElse: () => AppointmentStatus.allStatus,
    );
  }

  static AppointmentStatus fromApi(String? value) {
    switch (value?.toLowerCase()) {
      case 'no_show':
        return AppointmentStatus.noShow;
      case 'delayed':
        return AppointmentStatus.delayed;

      case 'completed':
        return AppointmentStatus.completed;

      case 'arrived':
        return AppointmentStatus.arrived;

      case 'ongoing':
        return AppointmentStatus.ongoing;

      case 'rescheduled':
        return AppointmentStatus.rescheduled;

      default:
        return AppointmentStatus.allStatus;
    }
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

enum ChatMessageType {
  text('text', 'Text'),
  normal('normal', 'Normal'),
  media('media', 'Media'),
  document('document', 'Document'),
  sharedRequest('sharedRequest', 'Shared Request'),
  appointment('appointment', 'Appointment');

  final String value;
  final String label;

  const ChatMessageType(this.value, this.label);

  static ChatMessageType fromValue(String? value) {
    if (value == null) return ChatMessageType.text;
    final val = value.toLowerCase();
    return ChatMessageType.values.firstWhere(
      (e) => e.value.toLowerCase() == val,
      orElse: () => ChatMessageType.text,
    );
  }
}
