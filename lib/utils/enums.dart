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
  createDoctor('clinic/doctors/register'),
  getDoctors('clinic/doctors'),
  getAdminTreatments('treatments/masters'),
  getTreatmentTemplates('clinic/treatments/admin'),
  getAdminTreatmentsSideAreas('clinic/side-areas/treatment/{treatmentId}'),
  addClinicTreatment('clinic/side-areas/bulk'),
  changePassword('clinic/change-password'),
  forgetPassword('clinic/forgot-password'),
  resetPassword('clinic/reset-password'),
  verifyOtp('clinic/verify-reset-otp'),
  deleteTreatment('clinic/treatments/{treatment_id}'),
  updateDoctorTreatment('clinic/doctors'),
  getFeature("clinic/features"),
  roles("clinic/roles"),
  catalog('clinic/products/catalog'),
  clinicProducts('clinic/products'),
  getAppointment('clinic/appointments'),
  treatmentDetail('clinic/treatments/{id}'),
  sessionUpdate('sessionUpdate'),
  sessionDetail('clinic/sessions/{id}'),
   deleteSession('admin/sessions/{id}'),
    sessionStatus('admin/sessions/status'),
    products('admin/products'),
    updateProduct('admin/products/{id}'),
  deleteProduct('admin/products/{id}'),
  getBrands('admin/brands'),
  unitTypesList('admin/unit-types'),
  packageTypeList('admin/package-types'),
  usageType('admin/usage-types'),
  manufacturersList('admin/manufacturers'),
  suppliers('admin/suppliers'),
  adminProductList('admin/products/list'),
  batchLots('admin/batches/{batchId}/lots'),
  productBatches('admin/products/{productId}/batches'),
  lotItems('admin/lots/{lotId}/items'),
  updateLotItem('admin/items/{id}'),
   providerRoles('clinic/provider-roles'),
  getMe("clinic/me");

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
  // api('http://3.128.27.193/api/');
  api('https://api-qa.skinsyncai.com/api/');
  // api('https://s21hn0m8-8084.asse.devtunnels.ms/api/');

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
