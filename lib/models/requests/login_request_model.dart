import 'base_request.dart';

class LoginRequestModel extends BaseRequest {
  final String email;
  final String password;
  final String fcmToken;
  final String? timezone;
  final String? utcOffset;

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.fcmToken,
    this.timezone,
    this.utcOffset,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      email: json['email'] as String,
      password: json['password'] as String,
      fcmToken: json['fcm_token'] as String,
      timezone: json['timezone'] as String?,
      utcOffset: json['utc_offset'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
      if (timezone != null) 'timezone': timezone,
      if (utcOffset != null) 'utc_offset': utcOffset,
    };
  }
}
