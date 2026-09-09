import 'base_request.dart';

class RegisterPatientRequest extends BaseRequest {
  final String email;
  final String phone;
  final String userName;
  final String cc;

  RegisterPatientRequest({
    required this.email,
    required this.phone,
    required this.userName,
    required this.cc,
  });

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
