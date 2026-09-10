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
    isCompleted: json["is_completed"] ?? false,
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
  final List<FrequentlyTreatmentModel>? treatments;
  final List<FrequentlyConversion>? frequentlyConversions;
  final List<RequestClinicTreatmentModel>? todayTreatmentRequest;
  final List<TodaysCheckinModel>? todaysCheckin;
  final List<DashboardAppointmentModel>? todaysAppointment;

  DashboardModel({
    this.totalTreatment,
    this.totalPractitioner,
    this.totalTreatmentRequest,
    this.treatments,
    this.frequentlyConversions,
    this.todayTreatmentRequest,
    this.todaysCheckin,
    this.todaysAppointment,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalTreatment: json["total_treatment"],
      totalPractitioner: json["total_practitioner"],
      totalTreatmentRequest: json["total_treatment_request"],
      frequentlyConversions: json["frequently_conversions"] != null
          ? (json["frequently_conversions"] as List)
                .map(
                  (e) =>
                      FrequentlyConversion.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      treatments: json["treatments"] != null
          ? (json["treatments"] as List)
                .map(
                  (e) => FrequentlyTreatmentModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,

      todayTreatmentRequest: json["today_treatment_request"] != null
          ? (json["today_treatment_request"] as List)
                .map(
                  (e) => RequestClinicTreatmentModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      todaysCheckin: json["todays_checkin"] != null
          ? (json["todays_checkin"] as List)
                .map(
                  (e) => TodaysCheckinModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      todaysAppointment: json["todays_appointment"] != null
          ? (json["todays_appointment"] as List)
                .map(
                  (e) => DashboardAppointmentModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "total_treatment": totalTreatment,
    "total_practitioner": totalPractitioner,
    "total_treatment_request": totalTreatmentRequest,
    "treatments": treatments?.map((e) => e.toJson()).toList(),
    "today_treatment_request": todayTreatmentRequest
        ?.map((e) => e.toJson())
        .toList(),
    "todays_checkin": todaysCheckin?.map((e) => e.toJson()).toList(),
    "todays_appointment": todaysAppointment?.map((e) => e.toJson()).toList(),
  };
}

class FrequentlyConversion {
  final int patientId;
  final String patientImage;
  final String name;
  final String email;
  final String phoneNumber;
  final String appointmentRef;
  final int appointmentId;
  final int conversionCount;

  FrequentlyConversion({
    required this.patientId,
    required this.patientImage,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.appointmentRef,
    required this.appointmentId,
    required this.conversionCount,
  });

  factory FrequentlyConversion.fromJson(Map<String, dynamic> json) {
    return FrequentlyConversion(
      patientId: json['patient_id'] ?? 0,
      patientImage: json['patientImage'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      appointmentRef: json['appointmentRef'] ?? '',
      appointmentId: json['appointmentId'] ?? 0,
      conversionCount: json['conversionCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'patientImage': patientImage,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'appointmentRef': appointmentRef,
      'appointmentId': appointmentId,
      'conversionCount': conversionCount,
    };
  }
}

class DashboardAppointmentModel {
  final int? id;
  final String? appointmentKey;
  final String? patientName;
  final String? patientImage;
  final String? appointmentType;
  final List<TreatmentDetail>? treatments;
  final String? doctorName;
  final String? doctorImage;
  final String? paymentStatus;
  final String? status;
  final int? treatmentCount;
  final String? bookingType;
  final int? date;
  final AppointmentSlotModel? slot;

  DashboardAppointmentModel({
    this.id,
    this.appointmentKey,
    this.patientName,
    this.patientImage,
    this.appointmentType,
    this.treatments,
    this.doctorName,
    this.doctorImage,
    this.paymentStatus,
    this.status,
    this.treatmentCount,
    this.bookingType,
    this.date,
    this.slot,
  });

  factory DashboardAppointmentModel.fromJson(Map<String, dynamic> json) {
    List<TreatmentDetail>? parsedTreatments;

    if (json["treatments"] != null && json["treatments"] is List) {
      parsedTreatments = (json["treatments"] as List)
          .map((e) => TreatmentDetail.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json["treatment"] != null || json["booking_type"] != null) {
      final String raw = (json["treatment"] ?? json["booking_type"]).toString();

      if (raw.isNotEmpty) {
        parsedTreatments = [TreatmentDetail(treatmentName: raw)];
      }
    }

    return DashboardAppointmentModel(
      id: json["id"],
      appointmentKey: json["appointment_key"],
      patientName: json["patient_name"],
      patientImage: json["patient_image"],
      appointmentType: json["appointment_type"],
      treatments: parsedTreatments,
      doctorName: json["doctor_name"] ?? json["practitioner_name"],
      doctorImage: json["doctor_image"],
      paymentStatus: json["payment_status"],
      status: json["status"],
      treatmentCount: json["treatment_count"],
      bookingType: json["booking_type"],
      date: json["date"],
      slot: json["slot"] != null
          ? AppointmentSlotModel.fromJson(json["slot"] as Map<String, dynamic>)
          : null,
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
    "appointment_key": appointmentKey,
    "patient_name": patientName,
    "patient_image": patientImage,
    "appointment_type": appointmentType,
    "treatments": treatments?.map((e) => e.toJson()).toList(),
    "doctor_name": doctorName,
    "doctor_image": doctorImage,
    "payment_status": paymentStatus,
    "status": status,
    "treatment_count": treatmentCount,
    "booking_type": bookingType,
    "date": date,
    "slot": slot?.toJson(),
  };
}

class AppointmentSlotModel {
  final int? startTime;
  final int? endTime;

  AppointmentSlotModel({this.startTime, this.endTime});

  factory AppointmentSlotModel.fromJson(Map<String, dynamic> json) {
    return AppointmentSlotModel(
      startTime: json["start_time"],
      endTime: json["end_time"],
    );
  }

  Map<String, dynamic> toJson() => {
    "start_time": startTime,
    "end_time": endTime,
  };
}

class FrequentlyTreatmentModel {
  final int treatmentId;
  final int areaId;
  final String treatmentName;
  final String areaName;
  final String treatmentImage;
  final String icon;

  FrequentlyTreatmentModel({
    required this.treatmentId,
    required this.areaId,
    required this.treatmentName,
    required this.areaName,
    required this.treatmentImage,
    required this.icon,
  });

  factory FrequentlyTreatmentModel.fromJson(Map<String, dynamic> json) {
    return FrequentlyTreatmentModel(
      treatmentId: json['treatment_id'] ?? 0,
      areaId: json['area_id'] ?? 0,
      treatmentName: json['treatment_name'] ?? '',
      areaName: json['area_name'] ?? '',
      treatmentImage: json['treatment_image'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatment_id': treatmentId,
      'area_id': areaId,
      'treatment_name': treatmentName,
      'area_name': areaName,
      'treatment_image': treatmentImage,
      'icon': icon,
    };
  }
}

class TodaysCheckinModel {
  final String? patientImage;
  final String? patientName;
  final String? patientEmail;
  final String? appointmentReference;
  final int? appointmentId;
  final int? patientId;

  TodaysCheckinModel({
    this.patientImage,
    this.patientName,
    this.patientEmail,
    this.appointmentReference,
    this.appointmentId,
    this.patientId,
  });

  factory TodaysCheckinModel.fromJson(Map<String, dynamic> json) {
    return TodaysCheckinModel(
      patientImage: json["patient_image"],
      patientName: json["patient_name"],
      patientEmail: json["patient_email"],
      appointmentReference: json["appointment_reference"],
      appointmentId: json["appointment_id"],
      patientId: json["patient_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "patient_image": patientImage,
    "patient_name": patientName,
    "patient_email": patientEmail,
    "appointment_reference": appointmentReference,
    "appointment_id": appointmentId,
    "patient_id": patientId,
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
