import 'base_request.dart';

class ForgetPasswordRequest extends BaseRequest {
  final String email;

  ForgetPasswordRequest({required this.email});

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordRequest(email: json['email']);
  }

  @override
  Map<String, dynamic> toJson() => {'email': email};
}
