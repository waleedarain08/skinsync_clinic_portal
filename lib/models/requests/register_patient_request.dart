import 'base_request.dart';

class RegisterPatientRequest extends BaseRequest {
  final String email;
  final String phone;
  final String userName;
  final String cc;
  final String? timezone;
  final String? utcOffset;

  RegisterPatientRequest({
    required this.email,
    required this.phone,
    required this.userName,
    required this.cc,
    this.timezone,
    this.utcOffset,
  });

  factory RegisterPatientRequest.fromJson(Map<String, dynamic> json) {
    return RegisterPatientRequest(
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      cc: json['cc'] as String? ?? '',
      timezone: json['timezone'] as String?,
      utcOffset: json['utc_offset'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'user_name': userName,
      'cc': cc,
    };
  }
}
