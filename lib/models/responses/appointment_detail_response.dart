import '../treatment_detail_model.dart';
import 'base_response_model.dart';

class AppointmentDetailResponse
    extends BaseApiResponseModel<AppointmentDetailData> {
  AppointmentDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null
            ? null
            : AppointmentDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "is_success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class AppointmentDetailData {
  final int? id;
  final String? appointmentKey;
  // final Clinic? clinic;
  final Doctor? doctor;
  final Patient? patient;
  final AppointmentType? appointmentType;
  final int? date;
  final int? startTime;
  final int? endTime;
  final bool? isInviteClinic;
  final Simulations? simulations;
  final List<TreatmentDetail>? treatments;
  final double? treatmentTotal;
  final PaymentType? paymentType;
  final String? discountType;
  final double? discount;
  final String? bookingType;
  final String? status;
  final String? customMessage;
  final DateTime? createdAt;

  AppointmentDetailData({
    this.id,
    this.appointmentKey,
    //  this.clinic,
    this.doctor,
    this.patient,
    this.appointmentType,
    this.date,
    this.startTime,
    this.endTime,
    this.isInviteClinic,
    this.simulations,
    this.treatments,
    this.treatmentTotal,
    this.paymentType,
    this.discountType,
    this.discount,
    this.bookingType,
    this.status,
    this.customMessage,
    this.createdAt,
  });

  factory AppointmentDetailData.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailData(
        id: json["id"],
        appointmentKey: json["appointment_key"],
        doctor: json["doctor"] == null
            ? (json["practitioners"] != null &&
                    (json["practitioners"] as List).isNotEmpty
                ? Doctor.fromJson(
                    (json["practitioners"] as List).first is Map
                        ? (json["practitioners"] as List).first
                        : {})
                : null)
            : Doctor.fromJson(
                json["doctor"] is Map ? json["doctor"] : {}),
        patient: json["patient"] == null
            ? null
            : Patient.fromJson(json["patient"] is Map ? json["patient"] : {}),
        appointmentType: json["appointment_type"] == null
            ? (json["appointment_type_id"] != null
                ? AppointmentType(id: json["appointment_type_id"])
                : null)
            : AppointmentType.fromJson(
                json["appointment_type"] is Map ? json["appointment_type"] : {}),
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        isInviteClinic: json["is_invite_clinic"],
        simulations: json["simulations"] == null
            ? null
            : Simulations.fromJson(
                json["simulations"] is Map ? json["simulations"] : {}),
        treatments: (json["treatments"] ?? json["treatment"]) == null
            ? []
            : List<TreatmentDetail>.from(
                ((json["treatments"] ?? json["treatment"]) as List).map(
                  (x) => TreatmentDetail.fromJson(
                      x is Map ? x as Map<String, dynamic> : {}),
                ),
              ),
        treatmentTotal:
            (json["treatment_total"] ?? json["payable"])?.toDouble(),
        paymentType: json["payment_type"] == null
            ? null
            : PaymentType.fromJson(
                json["payment_type"] is Map ? json["payment_type"] : {}),
        discountType: json["discount_type"],
        discount: json["discount"]?.toDouble(),
        bookingType: json["booking_type"],
        status: json["status"],
        customMessage: json["custom_message"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appointment_key": appointmentKey,
        // "clinic": clinic?.toJson(),
        "doctor": doctor?.toJson(),
        "patient": patient?.toJson(),
        "appointment_type": appointmentType?.toJson(),
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "is_invite_clinic": isInviteClinic,
        "simulations": simulations?.toJson(),
        "treatments": treatments == null
            ? []
            : List<dynamic>.from(treatments!.map((x) => x.toJson())),
        "treatment_total": treatmentTotal,
        "payment_type": paymentType?.toJson(),
        "discount_type": discountType,
        "discount": discount,
        "booking_type": bookingType,
        "status": status,
        "custom_message": customMessage,
        "created_at": createdAt?.toIso8601String(),
      };

  AppointmentDetailData copyWith({
    int? id,
    String? appointmentKey,
    Doctor? doctor,
    Patient? patient,
    AppointmentType? appointmentType,
    int? date,
    int? startTime,
    int? endTime,
    bool? isInviteClinic,
    Simulations? simulations,
    List<TreatmentDetail>? treatments,
    double? treatmentTotal,
    PaymentType? paymentType,
    String? discountType,
    double? discount,
    String? bookingType,
    String? status,
    String? customMessage,
    DateTime? createdAt,
  }) {
    return AppointmentDetailData(
      id: id ?? this.id,
      appointmentKey: appointmentKey ?? this.appointmentKey,
      doctor: doctor ?? this.doctor,
      patient: patient ?? this.patient,
      appointmentType: appointmentType ?? this.appointmentType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isInviteClinic: isInviteClinic ?? this.isInviteClinic,
      simulations: simulations ?? this.simulations,
      treatments: treatments ?? this.treatments,
      treatmentTotal: treatmentTotal ?? this.treatmentTotal,
      paymentType: paymentType ?? this.paymentType,
      discountType: discountType ?? this.discountType,
      discount: discount ?? this.discount,
      bookingType: bookingType ?? this.bookingType,
      status: status ?? this.status,
      customMessage: customMessage ?? this.customMessage,
      createdAt: createdAt ?? this.createdAt,
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
            : List<String>.from(json["appointment_modes"].map((x) => x)),
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
        "appointment_modes": appointmentModes,
        "icon": icon,
        "image": image,
        "status": status,
      };
}

class Doctor {
  final int? id;
  final String? name;
  final String? email;
  final String? image;
  final String? title;
  final String? gender;
  final String? specialization;
  final int? yearsOfExperience;
  final dynamic qualifications;
  final String? phone;
  final String? cc;
  final String? country;
  final dynamic consultationFee;

  Doctor({
    this.id,
    this.name,
    this.email,
    this.image,
    this.title,
    this.gender,
    this.specialization,
    this.yearsOfExperience,
    this.qualifications,
    this.phone,
    this.cc,
    this.country,
    this.consultationFee,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        image: json["image"],
        title: json["title"],
        gender: json["gender"],
        specialization: json["specialization"],
        yearsOfExperience: json["years_of_experience"],
        qualifications: json["qualifications"],
        phone: json["phone"],
        cc: json["cc"],
        country: json["country"],
        consultationFee: json["consultation_fee"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "image": image,
        "title": title,
        "gender": gender,
        "specialization": specialization,
        "years_of_experience": yearsOfExperience,
        "qualifications": qualifications,
        "phone": phone,
        "cc": cc,
        "country": country,
        "consultation_fee": consultationFee,
      };
}

class Patient {
  final int? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? location;
  final String? bio;
  final String? cc;
  final String? country;

  Patient({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.location,
    this.bio,
    this.cc,
    this.country,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        profileImageUrl: json["profile_image_url"],
        location: json["location"],
        bio: json["bio"],
        cc: json["cc"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_number": phoneNumber,
        "profile_image_url": profileImageUrl,
        "location": location,
        "bio": bio,
        "cc": cc,
        "country": country,
      };
}

class PaymentType {
  final String? type;
  final String? status;

  PaymentType({
    this.type,
    this.status,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
      };
}

class Simulations {
  final String? frontImageBefore;
  final String? frontImageAfter;
  final String? rightImageBefore;
  final String? rightImageAfter;
  final String? leftImageBefore;
  final String? leftImageAfter;

  Simulations({
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
  });

  factory Simulations.fromJson(Map<String, dynamic> json) => Simulations(
        frontImageBefore: json["front_image_before"],
        frontImageAfter: json["front_image_after"],
        rightImageBefore: json["right_image_before"],
        rightImageAfter: json["right_image_after"],
        leftImageBefore: json["left_image_before"],
        leftImageAfter: json["left_image_after"],
      );

  Map<String, dynamic> toJson() => {
        "front_image_before": frontImageBefore,
        "front_image_after": frontImageAfter,
        "right_image_before": rightImageBefore,
        "right_image_after": rightImageAfter,
        "left_image_before": leftImageBefore,
        "left_image_after": leftImageAfter,
      };
}
