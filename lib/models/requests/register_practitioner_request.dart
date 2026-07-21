import 'package:flutter/material.dart';

import '../treatment_model.dart';
import 'base_request.dart';

class RegisterPractitionerRequest extends BaseRequest {
  final String role;
  final String name;
  final String? image;
  final String specialization;
  final ContactInfo contactInfo;
  final List<TreatmentModel> treatments;
  final List<Availability> availability;
  final int consultationFee;

  RegisterPractitionerRequest({
    required this.role,
    required this.name,
    required this.image,
    required this.specialization,
    required this.contactInfo,
    required this.treatments,
    required this.availability,
    required this.consultationFee,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'name': name,
      'image': image,
      'specialization': specialization,
      'contact_info': contactInfo.toJson(),
      'treatments': treatments.map((t) => t.toRequest()).toList(),
      'availability': availability.map((a) => a.toJson()).toList(),
      'consultation_fee': consultationFee,
    };
  }
}

class ContactInfo {
  final String email;
  final String phone;
  final String cc;
  final String country;

  const ContactInfo({
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone, 'cc': cc, 'country': country};
  }
}

class Availability {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<String> days;
  final String nextSlotAfter;

  const Availability({
    required this.startTime,
    required this.endTime,
    required this.days,
    required this.nextSlotAfter,
  });

  Map<String, dynamic> toJson() {
    return {
      'start_time': '${startTime.hour}:${startTime.minute}',
      'end_time': '${endTime.hour}:${endTime.minute}',
      'days': days,
      'next_slot_after': nextSlotAfter,
    };
  }

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      startTime: _getTimeOfDayFromString(json['start_time']),
      endTime: _getTimeOfDayFromString(json['end_time']),
      days: List<String>.from(json['days']),
      nextSlotAfter: json['next_slot_after'] ?? '',
    );
  }

  static TimeOfDay _getTimeOfDayFromString(String time) {
    final splitted = time.split(':');
    return TimeOfDay(
      hour: int.parse(splitted[0]),
      minute: int.parse(splitted[1]),
    );
  }
}
