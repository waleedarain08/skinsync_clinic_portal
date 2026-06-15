import 'base_request.dart';

class VerifyOtpRequest extends BaseRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(email: json['email'], otp: json['otp']);
  }

  @override
  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}
