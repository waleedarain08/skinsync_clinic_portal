import '../requests/register_doctor_request.dart';
import 'base_response_model.dart';

class RegisterDoctorResponse extends BaseResponse<Doctor> {
  const RegisterDoctorResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory RegisterDoctorResponse.fromJson(Map<String, dynamic> json) =>
      RegisterDoctorResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : Doctor.fromJson(json["data"]),
      );
}

class Doctor {
  final int? id;
  final int? clinicId;
  final String? email;
  final String? name;
  final String? role;
  final String? password;
  final String? status;
  final String? image;
  final String? specialization;
  final String? phone;
  final String? cc;
  final String? country;
  final List<Treatment>? treatments;
  final List<Availability>? availability;

  const Doctor({
    this.id,
    this.clinicId,
    this.email,
    this.name,
    this.role,
    this.password,
    this.status,
    this.image,
    this.specialization,
    this.phone,
    this.cc,
    this.country,
    this.treatments,
    this.availability,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json["id"],
    clinicId: json["clinic_id"],
    email: json["email"],
    name: json["name"],
    role: json["role"] != null ? json["role"] : null,
    password: json["password"],
    status: json["status"],
    image: json["image"],
    specialization: json["specialization"],
    phone: json["phone"],
    cc: json["cc"],
    country: json["country"],
    treatments: json["treatments"] == null
        ? []
        : List<Treatment>.from(
            (json["treatments"] as List).map((x) => Treatment.fromJson(x)),
          ),
    availability: json['availability'] != null
        ? List<Availability>.from(
            (json['availability'] as List).map((x) => Availability.fromJson(x)),
          )
        : null,
  );
}

class Treatment {
  final int? treatmentId;
  final String? treatmentName;
  final List<SideArea>? sideAreas;

  Treatment({this.treatmentId, this.treatmentName, this.sideAreas});

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      treatmentId: json["treatment_id"],
      treatmentName: json["treatment_name"],
      sideAreas: json["side_areas"] == null
          ? []
          : List<SideArea>.from(
              (json["side_areas"] as List).map((x) => SideArea.fromJson(x)),
            ),
    );
  }
}

class SideArea {
  final int? sideAreaId;
  final String? sideAreaName;

  SideArea({this.sideAreaId, this.sideAreaName});

  factory SideArea.fromJson(Map<String, dynamic> json) {
    return SideArea(
      sideAreaId: json["side_area_id"],
      sideAreaName: json["side_area_name"],
    );
  }
}
