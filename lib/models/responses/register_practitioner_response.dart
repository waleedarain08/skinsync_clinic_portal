import '../requests/register_practitioner_request.dart';
import 'base_response_model.dart';

class RegisterPractitionerResponse extends BaseResponse<Practitioner> {
  const RegisterPractitionerResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory RegisterPractitionerResponse.fromJson(Map<String, dynamic> json) =>
      RegisterPractitionerResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : Practitioner.fromJson(json["data"]),
      );
}

class Practitioner {
  final int? id;
  final int? clinicId;
  final String? status;
  final BasicInfo? basicInfo;
  final ContactInfo? contactInfo;
  final LicenseInfo? licenseInfo;
  final ClinicAccess? clinicAccess;
  final AvailabilityInfo? availabilityInfo;
  final FinancialInfo? financialInfo;
  final DateTime? createdAt;

  Practitioner({
    this.id,
    this.clinicId,
    this.status,
    this.basicInfo,
    this.contactInfo,
    this.licenseInfo,
    this.clinicAccess,
    this.availabilityInfo,
    this.financialInfo,
    this.createdAt,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) => Practitioner(
    id: json["id"],
    clinicId: json["clinic_id"],
    status: json["status"],
    basicInfo: json["basic_info"] == null
        ? null
        : BasicInfo.fromJson(json["basic_info"]),
    contactInfo: json["contact_info"] == null
        ? null
        : ContactInfo.fromJson(json["contact_info"]),
    licenseInfo: json["license_info"] == null
        ? null
        : LicenseInfo.fromJson(json["license_info"]),
    clinicAccess: json["clinic_access"] == null
        ? null
        : ClinicAccess.fromJson(json["clinic_access"]),
    availabilityInfo: json["availability_info"] == null
        ? null
        : AvailabilityInfo.fromJson(json["availability_info"]),
    financialInfo: json["financial_info"] == null
        ? null
        : FinancialInfo.fromJson(json["financial_info"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
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
