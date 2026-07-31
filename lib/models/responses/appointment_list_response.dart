import 'dart:convert';

import 'package:timetable/timetable.dart';

import 'base_response_model.dart';

class AppointmentListResponse extends BaseResponse<Data> {
  AppointmentListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AppointmentListResponse.fromRawJson(String str) =>
      AppointmentListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentListResponse(
        success: json["is_success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "is_success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final List<AppointmentData>? items;
  final int? limit;
  final int? page;
  final int? total;
  final int? totalPages;

  Data({this.items, this.limit, this.page, this.total, this.totalPages});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null
            ? []
            : List<AppointmentData>.from(
                json["items"]!.map((x) => AppointmentData.fromJson(x)),
              ),
        limit: json["limit"],
        page: json["page"],
        total: json["total"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "limit": limit,
        "page": page,
        "total": total,
        "total_pages": totalPages,
      };
}

class AppointmentData extends Event {
  final int? id;
  final String? appointmentKey;
  final String? appointmentType;
  final String? patientName;
  final String? patientImage;
  final String? doctorName;
  final String? doctorImage;
  final String? paymentStatus;
  final String? status;
  final int? treatmentCount;
  final String? bookingType;
  final DateTime? date;

  AppointmentData({
    this.id,
    this.appointmentKey,
    this.appointmentType,
    this.patientName,
    this.patientImage,
    this.doctorName,
    this.doctorImage,
    this.paymentStatus,
    this.status,
    this.treatmentCount,
    this.bookingType,
    this.date,
    required super.start,
    required super.end,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) {
    final slot = json["slot"] as Map<String, dynamic>?;
    return AppointmentData(
      id: json["id"],
      appointmentKey: json["appointment_key"],
      appointmentType: json["appointment_type"],
      patientName: json["patient_name"],
      patientImage: json["patient_image"],
      doctorName: json["doctor_name"],
      doctorImage: json["doctor_image"],
      paymentStatus: json["payment_status"],
      status: json["status"],
      treatmentCount: json["treatment_count"],
      bookingType: json["booking_type"],
      date: json["date"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000)
          : null,
      start: slot != null
          ? DateTime.fromMillisecondsSinceEpoch(slot["start_time"] * 1000)
          : DateTime.now(),
      end: slot != null
          ? DateTime.fromMillisecondsSinceEpoch(slot["end_time"] * 1000)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "appointment_key": appointmentKey,
        "appointment_type": appointmentType,
        "patient_name": patientName,
        "patient_image": patientImage,
        "doctor_name": doctorName,
        "doctor_image": doctorImage,
        "payment_status": paymentStatus,
        "status": status,
        "treatment_count": treatmentCount,
        "booking_type": bookingType,
        "date": date != null ? date!.millisecondsSinceEpoch ~/ 1000 : null,
        "slot": {
          "start_time": start.millisecondsSinceEpoch ~/ 1000,
          "end_time": end.millisecondsSinceEpoch ~/ 1000,
        },
      };

  AppointmentData copyWith({
    int? id,
    String? appointmentKey,
    String? appointmentType,
    String? patientName,
    String? patientImage,
    String? doctorName,
    String? doctorImage,
    String? paymentStatus,
    String? status,
    int? treatmentCount,
    String? bookingType,
    DateTime? date,
    DateTime? start,
    DateTime? end,
  }) {
    return AppointmentData(
      id: id ?? this.id,
      appointmentKey: appointmentKey ?? this.appointmentKey,
      appointmentType: appointmentType ?? this.appointmentType,
      patientName: patientName ?? this.patientName,
      patientImage: patientImage ?? this.patientImage,
      doctorName: doctorName ?? this.doctorName,
      doctorImage: doctorImage ?? this.doctorImage,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      status: status ?? this.status,
      treatmentCount: treatmentCount ?? this.treatmentCount,
      bookingType: bookingType ?? this.bookingType,
      date: date ?? this.date,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}
