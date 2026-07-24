import 'dart:convert';

import 'package:timetable/timetable.dart';

import 'base_response_model.dart';

class AppointmentResponse extends BaseResponse {
  final Data? data;

  AppointmentResponse({
    required super.success,
    required super.message,
    this.data,
  });

  factory AppointmentResponse.fromRawJson(String str) =>
      AppointmentResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentResponse(
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
  final int? clinicId;
  final String? clinicName;
  final int? doctorId;
  final int? appointmentTypeId;
  final AppointmentType? appointmentType;
  final String? patientName;
  final DateTime? date;
  final bool? isInviteClinic;
  final Simulations? simulations;
  final List<Treatment>? treatments;
  final int? treatmentTotal;
  final PaymentType? paymentType;
  final String? discountType;
  final int? discount;
  final String? status;
  final DateTime? createdAt;

  AppointmentData({
    this.id,
    this.appointmentKey,
    this.clinicId,
    this.clinicName,
    this.doctorId,
    this.appointmentTypeId,
    this.appointmentType,
    this.patientName,
    this.date,
    required super.start,
    required super.end,
    this.isInviteClinic,
    this.simulations,
    this.treatments,
    this.treatmentTotal,
    this.paymentType,
    this.discountType,
    this.discount,
    this.status,
    this.createdAt,
  });

  factory AppointmentData.fromJson(Map<String, dynamic> json) =>
      AppointmentData(
        id: json["id"],
        appointmentKey: json["appointment_key"],
        clinicId: json["clinic_id"],
        clinicName: json["clinic_name"],
        doctorId: json["doctor_id"],
        appointmentTypeId: json["appointment_type_id"],
        appointmentType: json["appointment_type"] == null
            ? null
            : AppointmentType.fromJson(json["appointment_type"]),
        patientName: json["patient_name"],
        date: json["date"] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000)
            : null,
        start: DateTime.fromMillisecondsSinceEpoch(json["start_time"] * 1000),
        end: DateTime.fromMillisecondsSinceEpoch(json["end_time"] * 1000),
        isInviteClinic: json["is_invite_clinic"],
        simulations: json["simulations"] == null
            ? null
            : Simulations.fromJson(json["simulations"]),
        treatments: json["treatments"] == null
            ? []
            : List<Treatment>.from(
                json["treatments"]!.map((x) => Treatment.fromJson(x)),
              ),
        treatmentTotal: json["treatment_total"],
        paymentType: json["payment_type"] == null
            ? null
            : PaymentType.fromJson(json["payment_type"]),
        discountType: json["discount_type"],
        discount: json["discount"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "appointment_key": appointmentKey,
    "clinic_id": clinicId,
    "clinic_name": clinicName,
    "doctor_id": doctorId,
    "appointment_type_id": appointmentTypeId,
    "appointment_type": appointmentType?.toJson(),
    "patient_name": patientName,
    "date": date,
    "start_time": start,
    "end_time": end,
    "is_invite_clinic": isInviteClinic,
    "simulations": simulations?.toJson(),
    "treatments": treatments == null
        ? []
        : List<dynamic>.from(treatments!.map((x) => x.toJson())),
    "treatment_total": treatmentTotal,
    "payment_type": paymentType?.toJson(),
    "discount_type": discountType,
    "discount": discount,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
  };

  AppointmentData copyWith({DateTime? date, DateTime? start, DateTime? end}) {
    return AppointmentData(
      id: id,
      appointmentKey: appointmentKey,
      appointmentType: appointmentType,
      appointmentTypeId: appointmentTypeId,
      clinicId: clinicId,
      clinicName: clinicName,
      createdAt: createdAt,
      date: date ?? this.date,
      start: start ?? this.start,
      end: end ?? this.end,
      discountType: discountType,
      discount: discount,
      doctorId: doctorId,
      isInviteClinic: isInviteClinic,
      patientName: patientName,
      paymentType: paymentType,
      simulations: simulations,
      status: status,
      treatmentTotal: treatmentTotal,
      treatments: treatments,
    );
  }
}

class AppointmentType {
  final int? id;
  final String? title;
  final String? key;
  final String? description;
  final String? timing;
  final int? maxDuration;
  final List<String>? appointmentModes;
  final String? icon;
  final String? image;
  final String? status;

  AppointmentType({
    this.id,
    this.title,
    this.key,
    this.description,
    this.timing,
    this.maxDuration,
    this.appointmentModes,
    this.icon,
    this.image,
    this.status,
  });

  factory AppointmentType.fromRawJson(String str) =>
      AppointmentType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppointmentType.fromJson(Map<String, dynamic> json) =>
      AppointmentType(
        id: json["id"],
        title: json["title"],
        key: json["key"],
        description: json["description"],
        timing: json["timing"],
        maxDuration: json["max_duration"],
        appointmentModes: json["appointment_modes"] == null
            ? []
            : List<String>.from(json["appointment_modes"]!.map((x) => x)),
        icon: json["icon"],
        image: json["image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "key": key,
    "description": description,
    "timing": timing,
    "max_duration": maxDuration,
    "appointment_modes": appointmentModes == null
        ? []
        : List<dynamic>.from(appointmentModes!.map((x) => x)),
    "icon": icon,
    "image": image,
    "status": status,
  };
}

class PaymentType {
  final String? type;
  final String? status;

  PaymentType({this.type, this.status});

  factory PaymentType.fromRawJson(String str) =>
      PaymentType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      PaymentType(type: json["type"], status: json["status"]);

  Map<String, dynamic> toJson() => {"type": type, "status": status};
}

class Simulations {
  final String? beforeImage;
  final String? afterImage;

  Simulations({this.beforeImage, this.afterImage});

  factory Simulations.fromRawJson(String str) =>
      Simulations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Simulations.fromJson(Map<String, dynamic> json) => Simulations(
    beforeImage: json["before_image"],
    afterImage: json["after_image"],
  );

  Map<String, dynamic> toJson() => {
    "before_image": beforeImage,
    "after_image": afterImage,
  };
}

class Treatment {
  final int? treatmentId;
  final int? areaId;
  final int? treatmentCost;
  final Material? material;

  Treatment({this.treatmentId, this.areaId, this.treatmentCost, this.material});

  factory Treatment.fromRawJson(String str) =>
      Treatment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
    treatmentId: json["treatment_id"],
    areaId: json["area_id"],
    treatmentCost: json["treatment_cost"],
    material: json["material"] == null
        ? null
        : Material.fromJson(json["material"]),
  );

  Map<String, dynamic> toJson() => {
    "treatment_id": treatmentId,
    "area_id": areaId,
    "treatment_cost": treatmentCost,
    "material": material?.toJson(),
  };
}

class Material {
  final int? id;
  final int? selectedQuantity;

  Material({this.id, this.selectedQuantity});

  factory Material.fromRawJson(String str) =>
      Material.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Material.fromJson(Map<String, dynamic> json) =>
      Material(id: json["id"], selectedQuantity: json["selected_quantity"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "selected_quantity": selectedQuantity,
  };
}
