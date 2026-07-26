import 'base_request.dart';

class CreateAppointmentRequest extends BaseRequest {
  final int? patientId;
  final String? patientName;
  final String? patientEmail;
  final String? patientPhone;

  CreateAppointmentRequest({
    this.patientId,
    this.patientName,
    this.patientEmail,
    this.patientPhone,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_email': patientEmail,
      'patient_phone': patientPhone,
    };
  }

  CreateAppointmentRequest copyWith({
    int? patientId,
    String? patientName,
    String? patientEmail,
    String? patientPhone,
  }) {
    return CreateAppointmentRequest(
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      patientPhone: patientPhone ?? this.patientPhone,
    );
  }
}
