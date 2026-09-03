import '../treatment_detail_model.dart';
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
  final bool isCompleted;
  final DashboardModel? dashboard;

  AuthData({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.clinicUser,
    this.isCompleted = false,
    this.dashboard,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        accessExpiresAt: json["access_expires_at"],
        refreshExpiresAt: json["refresh_expires_at"],
        isCompleted: json['is_completed'] ?? false,
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
        "is_completed": isCompleted,
        "dashboard": dashboard?.toJson(),
      };
}

class DashboardModel {
  final int? totalTreatment;
  final int? totalPractitioner;
  final int? totalTreatmentRequest;
  final int? totalAppointment;
  final List<DashboardTreatmentModel>? treatments;
  final List<RequestClinicTreatmentModel>? todayTreatmentRequest;
  final AppointmentStatusOverviewModel? appointmentStatusOverview;
  final List<DashboardAppointmentModel>? todayAppointments;

  DashboardModel({
    this.totalTreatment,
    this.totalPractitioner,
    this.totalTreatmentRequest,
    this.totalAppointment,
    this.treatments,
    this.todayTreatmentRequest,
    this.appointmentStatusOverview,
    this.todayAppointments,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalTreatment: json["total_treatment"],
      totalPractitioner: json["total_practitioner"],
      totalTreatmentRequest: json["total_treatment_request"],
      totalAppointment: json["total_appointment"],
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
      appointmentStatusOverview: json["appointment_status_overview"] != null ||
              json["appointment_overview"] != null
          ? AppointmentStatusOverviewModel.fromJson(
              json["appointment_status_overview"] ??
                  json["appointment_overview"],
            )
          : null,
      todayAppointments: json["today_appointments"] != null ||
              json["today_appointment"] != null
          ? ((json["today_appointments"] ?? json["today_appointment"]) as List)
              .map((e) => DashboardAppointmentModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "total_treatment": totalTreatment,
        "total_practitioner": totalPractitioner,
        "total_treatment_request": totalTreatmentRequest,
        "total_appointment": totalAppointment,
        "treatments": treatments?.map((e) => e.toJson()).toList(),
        "today_treatment_request":
            todayTreatmentRequest?.map((e) => e.toJson()).toList(),
        "appointment_status_overview": appointmentStatusOverview?.toJson(),
        "today_appointments":
            todayAppointments?.map((e) => e.toJson()).toList(),
      };
}

class AppointmentStatusOverviewModel {
  final int? totalAppointments;
  final int? completed;
  final int? inProgress;
  final int? pending;
  final int? arrived;
  final int? delayed;
  final int? noShow;

  AppointmentStatusOverviewModel({
    this.totalAppointments,
    this.completed,
    this.inProgress,
    this.pending,
    this.arrived,
    this.delayed,
    this.noShow,
  });

  factory AppointmentStatusOverviewModel.fromJson(Map<String, dynamic> json) {
    return AppointmentStatusOverviewModel(
      totalAppointments: json["total_appointments"] ?? json["total"],
      completed: json["completed"],
      inProgress: json["in_progress"] ?? json["ongoing"],
      pending: json["pending"] ?? json["scheduled"],
      arrived: json["arrived"],
      delayed: json["delayed"],
      noShow: json["no_show"],
    );
  }

  Map<String, dynamic> toJson() => {
        "total_appointments": totalAppointments,
        "completed": completed,
        "in_progress": inProgress,
        "pending": pending,
        "arrived": arrived,
        "delayed": delayed,
        "no_show": noShow,
      };
}

class DashboardAppointmentModel {
  final int? id;
  final String? patientName;
  final String? patientImage;
  final String? appointmentType;
  final List<TreatmentDetail>? treatments;
  final String? doctorName;
  final String? doctorImage;
  final String? time;
  final String? status;
  final double? amount;
  final String? date;

  DashboardAppointmentModel({
    this.id,
    this.patientName,
    this.patientImage,
    this.appointmentType,
    this.treatments,
    this.doctorName,
    this.doctorImage,
    this.time,
    this.status,
    this.amount,
    this.date,
  });

  factory DashboardAppointmentModel.fromJson(Map<String, dynamic> json) {
    List<TreatmentDetail>? parsedTreatments;
    if (json["treatments"] != null && json["treatments"] is List) {
      parsedTreatments = (json["treatments"] as List)
          .map((e) => TreatmentDetail.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json["treatment"] != null || json["booking_type"] != null) {
      final String raw =
          (json["treatment"] ?? json["booking_type"]).toString();
      if (raw.isNotEmpty) {
        parsedTreatments = [
          TreatmentDetail(treatmentName: raw),
        ];
      }
    }

    return DashboardAppointmentModel(
      id: json["id"],
      patientName: json["patient_name"],
      patientImage: json["patient_image"],
      appointmentType: json["appointment_type"],
      treatments: parsedTreatments,
      doctorName: json["doctor_name"] ?? json["practitioner_name"],
      doctorImage: json["doctor_image"],
      time: json["time"] ?? json["start_time"]?.toString(),
      status: json["status"],
      amount:
          json["amount"]?.toDouble() ?? json["treatment_total"]?.toDouble(),
      date: json["date"]?.toString(),
    );
  }

  String get formattedTreatments {
    if (treatments != null && treatments!.isNotEmpty) {
      final formattedList = treatments!
          .map((t) => t.formattedName)
          .where((s) => s.isNotEmpty)
          .toList();
      if (formattedList.isNotEmpty) {
        return formattedList.join(', ');
      }
    }
    return '';
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_name": patientName,
        "patient_image": patientImage,
        "appointment_type": appointmentType,
        "treatments": treatments?.map((e) => e.toJson()).toList(),
        "doctor_name": doctorName,
        "doctor_image": doctorImage,
        "time": time,
        "status": status,
        "amount": amount,
        "date": date,
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
