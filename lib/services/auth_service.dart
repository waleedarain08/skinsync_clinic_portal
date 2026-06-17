import 'dart:async';

import '../models/requests/change_password_request.dart';
import '../models/requests/forget_password_request.dart';
import '../models/requests/login_request_model.dart';
import '../models/requests/reset_password_request.dart';
import '../models/requests/verify_otp_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/login_response_model.dart';
import '../models/responses/verify_otp_response.dart';
import '../repositories/auth_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';
import 'locator.dart';
import 'storage_service.dart';

class AuthService implements AuthRepository {
  final ApiBaseService _api;
  final SecureStorageService _secureStorage = locator<SecureStorageService>();

  AuthService({required ApiBaseService api}) : _api = api;

  @override
  Future<AuthData> login({required LoginRequestModel req}) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.login,
      requestType: RequestType.post,
      requestBody: req,
    );
    final response = LoginResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    if (response.data == null) {
      throw UnknownException(response.message);
    }

    await _secureStorage.saveToken(response.data!.accessToken!);
    await _secureStorage.saveRefreshToken(response.data!.refreshToken!);
    await _secureStorage.saveUser(response.data!.clinicUser);
    await _secureStorage.saveAccessTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.accessExpiresAt! * 1000,
      ),
    );
    await _secureStorage.saveRefreshTokenExpiry(
      DateTime.fromMillisecondsSinceEpoch(
        response.data!.refreshExpiresAt! * 1000,
      ),
    );
    return response.data!;
  }

  @override
  Future<BaseResponse> changePassword({
    required ChangePasswordRequestModel req,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.changePassword,
      requestType: RequestType.post,
      requestBody: req,
    );
    final response = BaseResponse<dynamic>.fromJson(
      jsonResponse,
      (json) => json,
    );
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<BaseResponse> forgetPassword({
    required ForgetPasswordRequest req,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.forgetPassword,
      requestType: RequestType.post,
      requestBody: req,
    );
    final response = BaseResponse<dynamic>.fromJson(
      jsonResponse,
      (json) => json,
    );
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<LoginResponseModel> getMe() async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.getMe,
      requestType: RequestType.get,
    );
    final response = BaseResponse<LoginResponseModel>.fromJson(
      jsonResponse,
      (json) => LoginResponseModel.fromJson(json as Map<String, dynamic>),
    );

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response.data!;
  }
  // @override
  // Future<BaseApiResponseModel> forgetPassword({
  //   required ForgetPasswordRequest req,
  // }) async {
  //   final response = await locator<ApiBaseService>().post(
  //     Endpoint.forgetPassword,
  //     body: req.toJson(),
  //   );
  //   final model = BaseApiResponseModel<dynamic>.fromJson(
  //     response,
  //     (json) => json,
  //   );
  //   if (!model.isSuccess) {
  //     throw Exception(model.message);
  //   }
  //   return model;
  // }

  @override
  Future<BaseResponse> resetPassword({
    required ResetPasswordRequest req,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.resetPassword,
      requestType: RequestType.post,
      requestBody: req,
    );
    final response = BaseResponse<dynamic>.fromJson(
      jsonResponse,
      (json) => json,
    );
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }

  @override
  Future<VerifyOtpResponseModel> verifyOtp({
    required VerifyOtpRequest req,
  }) async {
    final jsonResponse = await _api.httpRequest(
      endPoint: Endpoint.verifyOtp,
      requestType: RequestType.post,
      requestBody: req,
    );

    final response = VerifyOtpResponseModel.fromJson(jsonResponse);

    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }

    return response;
  }
}
