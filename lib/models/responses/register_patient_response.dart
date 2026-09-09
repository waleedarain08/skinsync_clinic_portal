import 'base_response_model.dart';

class RegisterPatientResponse extends BaseResponse<RegisterPatientData> {
  RegisterPatientResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory RegisterPatientResponse.fromJson(Map<String, dynamic> json) {
    return RegisterPatientResponse(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? RegisterPatientData.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RegisterPatientData {
  final int id;
  final bool isFirstLogin;
  final bool detailAvailable;
  final String phoneNumber;
  final String cc;
  final String name;
  final String email;

  RegisterPatientData({
    required this.id,
    required this.isFirstLogin,
    required this.detailAvailable,
    required this.phoneNumber,
    required this.cc,
    required this.name,
    required this.email,
  });

  factory RegisterPatientData.fromJson(Map<String, dynamic> json) {
    return RegisterPatientData(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      isFirstLogin: json['is_first_login'] ?? false,
      detailAvailable: json['detail_available'] ?? false,
      phoneNumber: (json['phone_number'] ?? '').toString().trim(),
      cc: (json['cc'] ?? '').toString().trim(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
