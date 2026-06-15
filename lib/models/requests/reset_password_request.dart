import 'base_request.dart';

class ResetPasswordRequest extends BaseRequest {
  final String email;
  final String? resetToken;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  @override
  Map<String, dynamic> toJson() => {
    'email': email,
    'reset_token': resetToken,
    'new_password': newPassword,
  };
}
