import 'base_response_model.dart';

class PatientTreatmentProgressResponse
    extends BaseApiResponseModel<List<PatientTreatmentProgressData>> {
  PatientTreatmentProgressResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory PatientTreatmentProgressResponse.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentProgressResponse(
      data: json['data'] != null
          ? List<PatientTreatmentProgressData>.from(
              (json['data'] as List)
                  .map((x) => PatientTreatmentProgressData.fromJson(x)),
            )
          : [],
      success: json['is_success'] as bool? ?? (json['success'] as bool? ?? false),
      message: json['message'] as String? ?? '',
    );
  }
}

class PatientTreatmentProgressData {
  final int? id;
  final String? treatmentName;
  final String? areaName;
  final double? progress;
  final int? completedSteps;
  final int? totalSteps;
  final String? status;
  final List<ProgressEventData> events;

  PatientTreatmentProgressData({
    this.id,
    this.treatmentName,
    this.areaName,
    this.progress,
    this.completedSteps,
    this.totalSteps,
    this.status,
    this.events = const [],
  });

  factory PatientTreatmentProgressData.fromJson(Map<String, dynamic> json) {
    return PatientTreatmentProgressData(
      id: json['id'] as int?,
      treatmentName: json['treatment_name'] as String? ?? 'Treatment',
      areaName: json['area_name'] as String? ?? 'Area',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      completedSteps: json['completed_steps'] as int? ?? 0,
      totalSteps: json['total_steps'] as int? ?? 0,
      status: json['status'] as String? ?? 'IN PROGRESS',
      events: json['events'] != null
          ? List<ProgressEventData>.from(
              (json['events'] as List).map((x) => ProgressEventData.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'treatment_name': treatmentName,
        'area_name': areaName,
        'progress': progress,
        'completed_steps': completedSteps,
        'total_steps': totalSteps,
        'status': status,
        'events': events.map((x) => x.toJson()).toList(),
      };
}

class ProgressEventData {
  final String title;
  final String? date;
  final String? time;
  final String? doctorName;
  final String? clinicName;
  final bool isCompleted;

  ProgressEventData({
    required this.title,
    this.date,
    this.time,
    this.doctorName,
    this.clinicName,
    required this.isCompleted,
  });

  factory ProgressEventData.fromJson(Map<String, dynamic> json) {
    return ProgressEventData(
      title: json['title'] as String? ?? 'Event Step',
      date: json['date'] as String?,
      time: json['time'] as String?,
      doctorName: json['doctor_name'] as String?,
      clinicName: json['clinic_name'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'time': time,
        'doctor_name': doctorName,
        'clinic_name': clinicName,
        'is_completed': isCompleted,
      };
}
