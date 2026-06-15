import 'base_request.dart';

class ChangePasswordRequestModel extends BaseRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequestModel(
      currentPassword: json['old_password'],
      newPassword: json['new_password'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'current_password': currentPassword,
    'new_password': newPassword,
  };
}
