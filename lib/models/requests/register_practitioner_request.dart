import 'package:flutter/material.dart';
import 'base_request.dart';

class RegisterPractitionerRequest extends BaseRequest {
  final BasicInfo basicInfo;
  final ContactInfo contactInfo;
  final LicenseInfo licenseInfo;
  final ClinicAccess clinicAccess;
  final AvailabilityInfo availabilityInfo;
  final FinancialInfo financialInfo;

  RegisterPractitionerRequest({
    required this.basicInfo,
    required this.contactInfo,
    required this.licenseInfo,
    required this.clinicAccess,
    required this.availabilityInfo,
    required this.financialInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'basic_info': basicInfo.toJson(),
      'contact_info': contactInfo.toJson(),
      'license_info': licenseInfo.toJson(),
      'clinic_access': clinicAccess.toJson(),
      'availability_info': availabilityInfo.toJson(),
      'financial_info': financialInfo.toJson(),
    };
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

class ClinicAccess {
  final List<int> treatmentIds;
  final bool canPerformConsultation;
  final bool canPerformTreatment;
  final bool isVirtualEnabled;
  final bool acceptsWalkIn;
  final List<String> allowedBookingMethods;

  ClinicAccess({
    required this.treatmentIds,
    required this.canPerformConsultation,
    required this.canPerformTreatment,
    required this.isVirtualEnabled,
    required this.acceptsWalkIn,
    required this.allowedBookingMethods,
  });

  factory ClinicAccess.fromJson(Map<String, dynamic> json) => ClinicAccess(
      treatmentIds: json["treatment_ids"] == null
          ? []
          : List<int>.from(json["treatment_ids"]),
      canPerformConsultation:
          json["can_perform_consultation"] ?? false,
      canPerformTreatment:
          json["can_perform_treatment"] ?? false,
      isVirtualEnabled:
          json["is_virtual_enabled"] ?? false,
      acceptsWalkIn:
          json["accepts_walk_in"] ?? false,
      allowedBookingMethods:
          json["allowed_booking_methods"] == null
              ? []
              : List<String>.from(
                  json["allowed_booking_methods"],
                ),
    );

  Map<String, dynamic> toJson() {
    return {
      'treatment_ids': treatmentIds,
      'can_perform_consultation': canPerformConsultation,
      'can_perform_treatment': canPerformTreatment,
      'is_virtual_enabled': isVirtualEnabled,
      'accepts_walk_in': acceptsWalkIn,
      'allowed_booking_methods': allowedBookingMethods,
    };
  }
}

class AvailabilityInfo {
  final List<Availability> availability;
  final int slotDurationMinutes;
  final int bufferTimeMinutes;

  AvailabilityInfo({
    required this.availability,
    required this.slotDurationMinutes,
    required this.bufferTimeMinutes,
  });

  factory AvailabilityInfo.fromJson(Map<String, dynamic> json) =>
    AvailabilityInfo(
      availability: json["availability"] == null
          ? []
          : List<Availability>.from(
              (json["availability"] as List)
                  .map((e) => Availability.fromJson(e)),
            ),
      slotDurationMinutes:
          json["slot_duration_minutes"] ?? 0,
      bufferTimeMinutes:
          json["buffer_time_minutes"] ?? 0,
    );

  Map<String, dynamic> toJson() {
    return {
      'availability': availability.map((e) => e.toRequestJson()).toList(),
      'slot_duration_minutes': slotDurationMinutes,
      'buffer_time_minutes': bufferTimeMinutes,
    };
  }
}

class Availability {
  final int startTime; // Timestamp (milliseconds)
  final int endTime; // Timestamp (milliseconds)
  final List<String> days;
  final int? nextSlotAfter;
  final int slotDurationMinutes;
  final int bufferTimeMinutes;

  Availability({
    required this.startTime,
    required this.endTime,
    required this.days,
    this.nextSlotAfter,
    this.slotDurationMinutes = 30,
    this.bufferTimeMinutes = 10,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      startTime: _parseTimestamp(json['start_time']),
      endTime: _parseTimestamp(json['end_time']),
      days: List<String>.from(json['days'] ?? []),
      nextSlotAfter: json['next_slot_after'],
      slotDurationMinutes: json['slot_duration_minutes'] ?? 30,
      bufferTimeMinutes: json['buffer_time_minutes'] ?? 10,
    );
  }

  static int _parseTimestamp(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      // Try parsing HH:mm if it's still coming as string from backend
      try {
        final parts = value.split(':');
        if (parts.length == 2) {
          final now = DateTime.now();
          return DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(parts[0]),
            int.parse(parts[1]),
          ).millisecondsSinceEpoch;
        }
      } catch (_) {}
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'days': days,
      'next_slot_after': nextSlotAfter,
      'slot_duration_minutes': slotDurationMinutes,
      'buffer_time_minutes': bufferTimeMinutes,
    };
  }

  String uiFormat(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(endTime);
    return "${TimeOfDay.fromDateTime(start).format(context)} - ${TimeOfDay.fromDateTime(end).format(context)}";
  }

  String uiTimeRange(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(startTime);
    final end = DateTime.fromMillisecondsSinceEpoch(endTime);
    return "${TimeOfDay.fromDateTime(start).format(context)} - ${TimeOfDay.fromDateTime(end).format(context)}";
  }

  // Keeping old toJson for compatibility if needed elsewhere
  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'days': days,
      //    'next_slot_after': nextSlotAfter,
    };
  }
}

class FinancialInfo {
  final int consultationFee;
  final double treatmentCommission;
  final String commissionType;

  FinancialInfo({
    required this.consultationFee,
    required this.treatmentCommission,
    required this.commissionType,
  });

  factory FinancialInfo.fromJson(Map<String, dynamic> json) =>
    FinancialInfo(
      consultationFee: json["consultation_fee"] ?? 0,
      treatmentCommission:
          (json["treatment_commission"] as num?)?.toDouble() ?? 0.0,
      commissionType: json["commission_type"] ?? "",
    );

  Map<String, dynamic> toJson() {
    return {
      'consultation_fee': consultationFee,
      'treatment_commission': treatmentCommission,
      'commission_type': commissionType,
    };
  }
}
