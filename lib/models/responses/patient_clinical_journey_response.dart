import 'base_response_model.dart';

class PatientClinicalJourneyResponse
    extends BaseApiResponseModel<PatientClinicalJourneyData> {
  PatientClinicalJourneyResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory PatientClinicalJourneyResponse.fromJson(Map<String, dynamic> json) {
    return PatientClinicalJourneyResponse(
      data: json['data'] != null && json['data'] is Map
          ? PatientClinicalJourneyData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map))
          : null,
      success: json['is_success'] as bool? ?? (json['success'] as bool? ?? false),
      message: json['message'] as String? ?? '',
    );
  }
}

class PatientClinicalJourneyData {
  final String? id;
  final String? status;
  final String? requestedAt;
  final PatientRequestStepDto? patientRequest;
  final DoctorFinalizedStepDto? doctorFinalized;
  final List<TreatmentBranchDto> treatmentBranches;

  PatientClinicalJourneyData({
    this.id,
    this.status,
    this.requestedAt,
    this.patientRequest,
    this.doctorFinalized,
    this.treatmentBranches = const [],
  });

  factory PatientClinicalJourneyData.fromJson(Map<String, dynamic> json) {
    final pReq = json['patient_request'] ?? json['patientRequest'];
    final dFin = json['doctor_finalized'] ?? json['doctorFinalized'];
    final tBranches = json['treatment_branches'] ?? json['treatmentBranches'];

    return PatientClinicalJourneyData(
      id: json['id']?.toString(),
      status: json['status'] as String?,
      requestedAt: (json['requested_at'] ?? json['requestedAt'] ?? json['created_at']) as String?,
      patientRequest: pReq != null && pReq is Map
          ? PatientRequestStepDto.fromJson(
              Map<String, dynamic>.from(pReq as Map))
          : null,
      doctorFinalized: dFin != null && dFin is Map
          ? DoctorFinalizedStepDto.fromJson(
              Map<String, dynamic>.from(dFin as Map))
          : null,
      treatmentBranches: tBranches != null && tBranches is List
          ? List<TreatmentBranchDto>.from(
              (tBranches as List).map(
                (x) => TreatmentBranchDto.fromJson(
                  x is Map ? Map<String, dynamic>.from(x as Map) : {},
                ),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'requested_at': requestedAt,
        'patient_request': patientRequest?.toJson(),
        'doctor_finalized': doctorFinalized?.toJson(),
        'treatment_branches': treatmentBranches.map((x) => x.toJson()).toList(),
      };
}

class PatientRequestStepDto {
  final List<String> treatments;
  final String? preferredClinic;
  final String? requestedOn;
  final String? status;

  PatientRequestStepDto({
    this.treatments = const [],
    this.preferredClinic,
    this.requestedOn,
    this.status,
  });

  factory PatientRequestStepDto.fromJson(Map<String, dynamic> json) {
    return PatientRequestStepDto(
      treatments: json['treatments'] != null && json['treatments'] is List
          ? List<String>.from((json['treatments'] as List).map((x) => x.toString()))
          : [],
      preferredClinic: (json['preferred_clinic'] ?? json['preferredClinic']) as String?,
      requestedOn: (json['requested_on'] ?? json['requestedOn'] ?? json['created_at']) as String?,
      status: json['status'] as String? ?? 'REVIEWED',
    );
  }

  Map<String, dynamic> toJson() => {
        'treatments': treatments,
        'preferred_clinic': preferredClinic,
        'requested_on': requestedOn,
        'status': status,
      };
}

class DoctorFinalizedStepDto {
  final String? doctorName;
  final String? finalizedAt;
  final String? note;

  DoctorFinalizedStepDto({
    this.doctorName,
    this.finalizedAt,
    this.note,
  });

  factory DoctorFinalizedStepDto.fromJson(Map<String, dynamic> json) {
    return DoctorFinalizedStepDto(
      doctorName: (json['doctor_name'] ?? json['doctorName'] ?? json['name']) as String?,
      finalizedAt: (json['finalized_at'] ?? json['finalizedAt'] ?? json['created_at']) as String?,
      note: (json['note'] ?? json['notes']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'doctor_name': doctorName,
        'finalized_at': finalizedAt,
        'note': note,
      };
}

class TreatmentBranchDto {
  final String? treatmentName;
  final String? area;
  final String? sessionName;
  final String? date;
  final String? appointmentKey;
  final String? doctorName;
  final String? status;

  TreatmentBranchDto({
    this.treatmentName,
    this.area,
    this.sessionName,
    this.date,
    this.appointmentKey,
    this.doctorName,
    this.status,
  });

  factory TreatmentBranchDto.fromJson(Map<String, dynamic> json) {
    return TreatmentBranchDto(
      treatmentName: (json['treatment_name'] ?? json['treatmentName'] ?? json['name'] ?? json['treatment']) as String?,
      area: (json['area'] ?? json['area_name'] ?? json['areaName']) as String?,
      sessionName: (json['session_name'] ?? json['sessionName'] ?? json['session']) as String?,
      date: json['date'] as String?,
      appointmentKey: (json['appointment_key'] ?? json['appointmentKey']) as String?,
      doctorName: (json['doctor_name'] ?? json['doctorName']) as String?,
      status: json['status'] as String? ?? 'COMPLETED',
    );
  }

  Map<String, dynamic> toJson() => {
        'treatment_name': treatmentName,
        'area': area,
        'session_name': sessionName,
        'date': date,
        'appointment_key': appointmentKey,
        'doctor_name': doctorName,
        'status': status,
      };
}
