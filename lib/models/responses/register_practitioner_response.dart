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
  final int? treatmentCount;
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
    this.treatmentCount,
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
    treatmentCount: json["treatment_count"],
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

class BasicInfo {
  final String name;
  final String role;
  final String title;
  final String? image;
  final String gender;
  final String dateOfBirth;
  final String specialization;
  final int yearsOfExperience;
  final List<String> qualifications;

  BasicInfo({
    required this.name,
    required this.role,
    required this.title,
    this.image,
    required this.gender,
    required this.dateOfBirth,
    required this.specialization,
    required this.yearsOfExperience,
    required this.qualifications,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      title: json["title"] ?? "",
      image: json["image"],
      gender: json["gender"] ?? "",
      dateOfBirth: json["date_of_birth"] ?? "",
      specialization: json["specialization"] ?? "",
      yearsOfExperience: json["years_of_experience"] ?? 0,
      qualifications: json["qualifications"] == null
          ? []
          : List<String>.from(json["qualifications"]),
    );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'title': title,
      'image': image,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'specialization': specialization,
      'years_of_experience': yearsOfExperience,
      'qualifications': qualifications,
    };
  }
}

class ContactInfo {
  final String email;
  final String phone;
  final String cc;
  final String country;
  final EmergencyContact emergencyContact;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
    required this.emergencyContact,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      cc: json["cc"] ?? "",
      country: json["country"] ?? "",
      emergencyContact: json["emergency_contact"] != null
          ? EmergencyContact.fromJson(json["emergency_contact"])
          : EmergencyContact(
              name: "",
              phone: "",
              cc: "",
              country: "",
              relationship: "",
            ),
    );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'cc': cc,
      'country': country,
      'emergency_contact': emergencyContact.toJson(),
    };
  }
}

class EmergencyContact {
  final String name;
  final String phone;
  final String cc;
  final String country;
  final String relationship;

  EmergencyContact({
    required this.name,
    required this.phone,
    required this.cc,
    required this.country,
    required this.relationship,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
    EmergencyContact(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      cc: json["cc"] ?? "",
      country: json["country"] ?? "",
      relationship: json["relationship"] ?? "",
    ); 

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'cc': cc,
      'country': country,
      'relationship': relationship,
    };
  }
}

class LicenseInfo {
  final String licenseNumber;
  final String licenseExpiryDate;
  final String issuingAuthority;
  final String indemnityInsuranceNumber;
  final String indemnityExpiryDate;
  final List<String> documents;

  LicenseInfo({
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.issuingAuthority,
    required this.indemnityInsuranceNumber,
    required this.indemnityExpiryDate,
    required this.documents,
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) => LicenseInfo(
      licenseNumber: json["license_number"] ?? "",
      licenseExpiryDate: json["license_expiry_date"] ?? "",
      issuingAuthority: json["issuing_authority"] ?? "",
      indemnityInsuranceNumber:
          json["indemnity_insurance_number"] ?? "",
      indemnityExpiryDate: json["indemnity_expiry_date"] ?? "",
      documents: json["documents"] == null
          ? []
          : List<String>.from(json["documents"]),
    );

  Map<String, dynamic> toJson() {
    return {
      'license_number': licenseNumber,
      'license_expiry_date': licenseExpiryDate,
      'issuing_authority': issuingAuthority,
      'indemnity_insurance_number': indemnityInsuranceNumber,
      'indemnity_expiry_date': indemnityExpiryDate,
      'documents': documents,
    };
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
