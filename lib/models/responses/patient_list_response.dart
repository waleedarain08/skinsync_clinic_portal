import 'base_response_model.dart';

class PatientListResponse extends BaseResponse<List<PatientData>> {
  final int page;
  final int limit;
  final int totalPages;
  final int totalResults;

  PatientListResponse({
    required super.success,
    required super.message,
     super.data,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalResults,
  });

  factory PatientListResponse.fromJson(Map<String, dynamic> json) {
    return PatientListResponse(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map(
                (e) => PatientData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class PatientData {
  final int id;
  final String patientName;
  final String email;
  final String? image;
  final String phoneNumber;

  PatientData({
    required this.id,
    required this.patientName,
    required this.email,
    this.image,
    required this.phoneNumber,
  });

  factory PatientData.fromJson(Map<String, dynamic> json) {
    return PatientData(
      id: json['id'] ?? 0,
      patientName: json['patient_name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      phoneNumber: json['phone_number'] ?? '',
    );
  }
}