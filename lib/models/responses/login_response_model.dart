import '../user_model.dart';
import 'base_response_model.dart';

class LoginResponseModel extends BaseResponse<AuthData> {
  const LoginResponseModel({
    required super.success,
    required super.message,
    super.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "is_success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class AuthData {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiresAt;
  final int? refreshExpiresAt;
  final UserModel? clinicUser;
  final DashboardModel? dashboard;

  AuthData({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.clinicUser,
    this.dashboard,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        accessExpiresAt: json["access_expires_at"],
        refreshExpiresAt: json["refresh_expires_at"],
        clinicUser: json["clinic_user"] == null
            ? null
            : UserModel.fromJson(json["clinic_user"]),
        dashboard: json["dashboard"] == null
            ? null
            : DashboardModel.fromJson(json["dashboard"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
        "access_expires_at": accessExpiresAt,
        "refresh_expires_at": refreshExpiresAt,
        "clinic_user": clinicUser?.toJson(),
        "dashboard": dashboard?.toJson(),
      };
}

class DashboardModel {
  final int? totalTreatment;
  final int? totalPractitioner;
  final int? totalTreatmentRequest;
  final List<DashboardTreatmentModel>? treatments;
  final List<RequestClinicTreatmentModel>? todayTreatmentRequest;

  DashboardModel({
    this.totalTreatment,
    this.totalPractitioner,
    this.totalTreatmentRequest,
    this.treatments,
    this.todayTreatmentRequest,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalTreatment: json["total_treatment"],
      totalPractitioner: json["total_practitioner"],
      totalTreatmentRequest: json["total_treatment_request"],
      treatments: json["treatments"] != null
          ? (json["treatments"] as List)
              .map((e) => DashboardTreatmentModel.fromJson(e))
              .toList()
          : null,
      todayTreatmentRequest: json["today_treatment_request"] != null
          ? (json["today_treatment_request"] as List)
              .map((e) => RequestClinicTreatmentModel.fromJson(e))
              .toList()
          : null,
          
    );
  }

  Map<String, dynamic> toJson() => {
        "total_treatment": totalTreatment,
        "total_practitioner": totalPractitioner,
        "total_treatment_request": totalTreatmentRequest,
        "treatments": treatments?.map((e) => e.toJson()).toList(),
        "today_treatment_request":
            todayTreatmentRequest?.map((e) => e.toJson()).toList(),
      };
}

class DashboardTreatmentModel {
  final int? id;
  final String? name;
  final String? shortDescription;
  final String? image;
  final String? icon;
  final String? sku;

  DashboardTreatmentModel({
    this.id,
    this.name,
    this.shortDescription,
    this.image,
    this.icon,
    this.sku,
  });

  factory DashboardTreatmentModel.fromJson(Map<String, dynamic> json) {
    return DashboardTreatmentModel(
      id: json["id"],
      name: json["name"],
      shortDescription: json["short_description"],
      image: json["image"],
      icon: json["icon"],
      sku: json["sku"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "short_description": shortDescription,
        "image": image,
        "icon": icon,
        "sku": sku,
      };
}

class RequestClinicTreatmentModel {
  final int? id;
  final String? patientName;
  final String? patientEmail;
  final String? image;
  final int? totalTreatmentCount;

  RequestClinicTreatmentModel({
    this.id,
    this.patientName,
    this.patientEmail,
    this.image,
    this.totalTreatmentCount,
  });

  factory RequestClinicTreatmentModel.fromJson(Map<String, dynamic> json) {
    return RequestClinicTreatmentModel(
      id: json["id"],
      patientName: json["patient_name"],
      patientEmail: json["patient_email"],
      image: json["image"],
      totalTreatmentCount: json["total_treatment_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_name": patientName,
        "patient_email": patientEmail,
        "image": image,
        "total_treatment_count": totalTreatmentCount,
      };
}