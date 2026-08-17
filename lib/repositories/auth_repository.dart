import '../models/requests/change_password_request.dart';
import '../models/requests/forget_password_request.dart';
import '../models/requests/login_request_model.dart';
import '../models/requests/reset_password_request.dart';
import '../models/requests/verify_otp_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/clinic_model.dart';
import '../models/responses/login_response_model.dart';
import '../models/responses/verify_otp_response.dart';

abstract class AuthRepository {
  Future<AuthData> login({required LoginRequestModel req});

  Future<BaseResponse> changePassword({
    required ChangePasswordRequestModel req,
  });

  Future<BaseResponse> forgetPassword({required ForgetPasswordRequest req});

  Future<VerifyOtpResponseModel> verifyOtp({required VerifyOtpRequest req});

  Future<BaseResponse> resetPassword({required ResetPasswordRequest req});

  Future<LoginResponseModel> getMe();

  Future<BaseResponse<Clinic>> updateClinicProfile({required Clinic req});
}
