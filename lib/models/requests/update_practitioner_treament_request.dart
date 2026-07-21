import 'base_request.dart';
import 'register_practitioner_request.dart';

class UpdatePractitionerRequest extends BaseRequest {
  final int clinicUserId;
  final List<UpdateTreatmentRequest> treatments;
  final String name;
  final String specialization;
  final String phone;
  final String? cc;
  final String? country;
  final List<Availability> availability;
  final String? image;

  UpdatePractitionerRequest({
    required this.clinicUserId,
    required this.treatments,
    required this.name,
    required this.specialization,
    required this.phone,
    this.cc,
    this.country,
    required this.availability,
    this.image,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "clinic_user_id": clinicUserId,
      "treatments": treatments.map((e) => e.toJson()).toList(),
      'name': name,
      'specialization': specialization,
      'phone': phone,
      'cc': cc,
      'country': country,
      'availability': availability.map((a) => a.toJson()).toList(),
      'image': image,
    };
  }
}

class UpdateTreatmentRequest {
  final int treatmentId;
  final List<int> treatmentsSubSecId;

  UpdateTreatmentRequest({
    required this.treatmentId,
    required this.treatmentsSubSecId,
  });

  Map<String, dynamic> toJson() {
    return {
      "treatment_id": treatmentId,
      "treatments_sub_sec_id": treatmentsSubSecId,
    };
  }
}
