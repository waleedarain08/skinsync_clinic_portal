import '../requests/register_practitioner_request.dart';
import 'base_response_model.dart';

class RegisterPractitionerResponse extends BaseResponse<Practitioner> {
  const RegisterPractitionerResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory RegisterPractitionerResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return RegisterPractitionerResponse(
      success: json["is_success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? null
          : Practitioner.fromJson(json["data"]),
    );
  }
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
  final List<Treatment> treatments;
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
    this.treatments = const [],
    this.createdAt,
  });

  factory Practitioner.fromJson(Map<String, dynamic> json) {
    return Practitioner(
      id: json["id"],
      clinicId: json["clinic_id"],
      status: json["status"],

      basicInfo: json["basic_info"] is Map<String, dynamic>
          ? BasicInfo.fromJson(json["basic_info"])
          : null,

      contactInfo: json["contact_info"] is Map<String, dynamic>
          ? ContactInfo.fromJson(json["contact_info"])
          : null,

      licenseInfo: json["license_info"] is Map<String, dynamic>
          ? LicenseInfo.fromJson(json["license_info"])
          : null,

      clinicAccess: json["clinic_access"] is Map<String, dynamic>
          ? ClinicAccess.fromJson(json["clinic_access"])
          : null,

      availabilityInfo: json["availability_info"] is Map<String, dynamic>
          ? AvailabilityInfo.fromJson(json["availability_info"])
          : null,

      financialInfo: json["financial_info"] is Map<String, dynamic>
          ? FinancialInfo.fromJson(json["financial_info"])
          : null,

      treatmentCount: json["treatment_count"],

      treatments: json["treatments"] == null
          ? []
          : List<Treatment>.from(
              (json["treatments"] as List).map(
                (x) => Treatment.fromJson(x),
              ),
            ),

      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"]),
    );
  }
}

class Treatment {
  final int? treatmentId;
  final String? treatmentName;
  final List<SideArea> sideAreas;

  Treatment({
    this.treatmentId,
    this.treatmentName,
    this.sideAreas = const [],
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      treatmentId: json["treatment_id"],
      treatmentName: json["treatment_name"],
      sideAreas: json["side_areas"] == null
          ? []
          : List<SideArea>.from(
              (json["side_areas"] as List).map(
                (x) => SideArea.fromJson(x),
              ),
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
    this.name = "",
    this.role = "",
    this.title = "",
    this.image,
    this.gender = "",
    this.dateOfBirth = "",
    this.specialization = "",
    this.yearsOfExperience = 0,
    this.qualifications = const [],
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
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
  }

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
    this.email = "",
    this.phone = "",
    this.cc = "",
    this.country = "",
    EmergencyContact? emergencyContact,
  }) : emergencyContact = emergencyContact ??
            EmergencyContact();

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      cc: json["cc"] ?? "",
      country: json["country"] ?? "",
      emergencyContact: json["emergency_contact"] != null
          ? EmergencyContact.fromJson(json["emergency_contact"])
          : EmergencyContact(),
    );
  }

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
    this.name = "",
    this.phone = "",
    this.cc = "",
    this.country = "",
    this.relationship = "",
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      cc: json["cc"] ?? "",
      country: json["country"] ?? "",
      relationship: json["relationship"] ?? "",
    );
  }

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
    this.licenseNumber = "",
    this.licenseExpiryDate = "",
    this.issuingAuthority = "",
    this.indemnityInsuranceNumber = "",
    this.indemnityExpiryDate = "",
    this.documents = const [],
  });

  factory LicenseInfo.fromJson(Map<String, dynamic> json) {
    return LicenseInfo(
      licenseNumber: json["license_number"] ?? "",
      licenseExpiryDate: json["license_expiry_date"] ?? "",
      issuingAuthority: json["issuing_authority"] ?? "",
      indemnityInsuranceNumber:
          json["indemnity_insurance_number"] ?? "",
      indemnityExpiryDate:
          json["indemnity_expiry_date"] ?? "",
      documents: json["documents"] == null
          ? []
          : List<String>.from(json["documents"]),
    );
  }

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

  SideArea({
    this.sideAreaId,
    this.sideAreaName,
  });

  factory SideArea.fromJson(Map<String, dynamic> json) {
    return SideArea(
      sideAreaId: json["side_area_id"],
      sideAreaName: json["side_area_name"],
    );
  }
}