import 'base_request.dart';

class LoginRequestModel extends BaseRequest {
  final String email;
  final String password;
  final String fcmToken;

  LoginRequestModel({required this.email, required this.password,required this.fcmToken});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      fcmToken: json['fcm_token']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password,'fcm_token': fcmToken};
  }
}
