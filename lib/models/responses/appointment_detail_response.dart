import 'base_response_model.dart';

class AppointmentDetailResponse extends BaseApiResponseModel<AppointmentDetailData> {
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
}

class AppointmentDetailData {
  final int? id;
  final String? appointmentKey;
  final Clinic? clinic;
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
  final DateTime? createdAt;

  AppointmentDetailData({
    this.id,
    this.appointmentKey,
    this.clinic,
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
    this.createdAt,
  });

  factory AppointmentDetailData.fromJson(Map<String, dynamic> json) => AppointmentDetailData(
        id: json["id"],
        appointmentKey: json["appointment_key"],
        clinic: json["clinic"] == null ? null : Clinic.fromJson(json["clinic"]),
        doctor: json["doctor"] == null ? null : Doctor.fromJson(json["doctor"]),
        patient: json["patient"] == null ? null : Patient.fromJson(json["patient"]),
        appointmentType: json["appointment_type"] == null
            ? null
            : AppointmentType.fromJson(json["appointment_type"]),
        date: json["date"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        isInviteClinic: json["is_invite_clinic"],
        simulations: json["simulations"] == null ? null : Simulations.fromJson(json["simulations"]),
        treatments: json["treatments"] == null
            ? []
            : List<TreatmentDetail>.from(json["treatments"].map((x) => TreatmentDetail.fromJson(x))),
        treatmentTotal: json["treatment_total"]?.toDouble(),
        paymentType: json["payment_type"] == null ? null : PaymentType.fromJson(json["payment_type"]),
        discountType: json["discount_type"],
        discount: json["discount"]?.toDouble(),
        bookingType: json["booking_type"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      );
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

  factory AppointmentType.fromJson(Map<String, dynamic> json) => AppointmentType(
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
}

class Clinic {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? logo;
  final String? banner;
  final String? website;
  final String? description;
  final double? consultationFee;
  final double? initialDeposit;
  final String? cc;
  final String? country;
  final double? latitude;
  final double? longitude;

  Clinic({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.banner,
    this.website,
    this.description,
    this.consultationFee,
    this.initialDeposit,
    this.cc,
    this.country,
    this.latitude,
    this.longitude,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        logo: json["logo"],
        banner: json["banner"],
        website: json["website"],
        description: json["description"],
        consultationFee: json["consultation_fee"]?.toDouble(),
        initialDeposit: json["initial_deposit"]?.toDouble(),
        cc: json["cc"],
        country: json["country"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );
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
}

class TreatmentDetail {
  final int? treatmentId;
  final String? treatmentName;
  final int? areaId;
  final String? areaName;
  final double? treatmentCost;
  final MaterialDetail? material;

  TreatmentDetail({
    this.treatmentId,
    this.treatmentName,
    this.areaId,
    this.areaName,
    this.treatmentCost,
    this.material,
  });

  factory TreatmentDetail.fromJson(Map<String, dynamic> json) => TreatmentDetail(
        treatmentId: json["treatment_id"],
        treatmentName: json["treatment_name"],
        areaId: json["area_id"],
        areaName: json["area_name"],
        treatmentCost: json["treatment_cost"]?.toDouble(),
        material: json["material"] == null ? null : MaterialDetail.fromJson(json["material"]),
      );
}

class MaterialDetail {
  final int? id;
  final int? selectedQuantity;

  MaterialDetail({
    this.id,
    this.selectedQuantity,
  });

  factory MaterialDetail.fromJson(Map<String, dynamic> json) => MaterialDetail(
        id: json["id"],
        selectedQuantity: json["selected_quantity"],
      );
}
