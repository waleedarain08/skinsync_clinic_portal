import 'base_request.dart';

class LoginRequestModel extends BaseRequest {
  final String email;
  final String password;

  LoginRequestModel({required this.email, required this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
