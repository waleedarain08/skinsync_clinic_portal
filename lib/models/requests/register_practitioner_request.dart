import 'package:flutter/material.dart';
import 'base_request.dart';

class RegisterPractitionerRequest extends BaseRequest {
  // final BasicInfo basicInfo;
  // final ContactInfo contactInfo;
  // final LicenseInfo licenseInfo;
  final ClinicAccess clinicAccess;
  final AvailabilityInfo availabilityInfo;
  final FinancialInfo financialInfo;

  RegisterPractitionerRequest({
    // required this.basicInfo,
    // required this.contactInfo,
    // required this.licenseInfo,
    required this.clinicAccess,
    required this.availabilityInfo,
    required this.financialInfo,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      // 'basic_info': basicInfo.toJson(),
      // 'contact_info': contactInfo.toJson(),
      // 'license_info': licenseInfo.toJson(),
      'clinic_access': clinicAccess.toJson(),
      'availability_info': availabilityInfo.toJson(),
      'financial_info': financialInfo.toJson(),
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
