import '../user_model.dart';
import 'base_response_model.dart';

class LoginResponseModel extends BaseResponse<AuthData> {
  const LoginResponseModel({
    required super.status,
    required super.message,
    super.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : AuthData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class AuthData {
  final String? accessToken;
  final String? refreshToken;
  final int? accessExpiresAt;
  final int? refreshExpiresAt;
  final UserModel? clinicUser;

  AuthData({
    this.accessToken,
    this.refreshToken,
    this.accessExpiresAt,
    this.refreshExpiresAt,
    this.clinicUser,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    accessExpiresAt: json["access_expires_at"],
    refreshExpiresAt: json["refresh_expires_at"],
    clinicUser: json["clinic_user"] == null
        ? null
        : UserModel.fromJson(json["clinic_user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "access_expires_at": accessExpiresAt,
    "refresh_expires_at": refreshExpiresAt,
    "clinic_user": clinicUser?.toJson(),
  };
}
