import 'dart:ui' as ui;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/requests/reset_password_request.dart';
import '../models/requests/verify_otp_request.dart';
import '../models/responses/clinic_model.dart';
import '../models/user_model.dart';
import '../models/requests/change_password_request.dart';
import '../models/requests/forget_password_request.dart';
import '../models/requests/login_request_model.dart';
import '../repositories/auth_repository.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import 'base_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel._(),
);

class AuthViewModel extends BaseViewModel<AuthState> {
  AuthViewModel._();

  @override
  AuthState build() {
    init();
    ref.onDispose(dispose);
    return AuthState(country: CountryCode.fromCountryCode('US'));
  }

  final AuthRepository _authRepository = locator<AuthRepository>();
  final SecureStorageService _storageServices = locator<SecureStorageService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> initialize() async {
    // Ensure state is available
    await Future.delayed(Duration.zero);
    final token = _storageServices.token;

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  void toggleObscureCurrent() =>
      state = state.copyWith(obscureCurrent: !state.obscureCurrent);

  void toggleObscureNew() =>
      state = state.copyWith(obscureNew: !state.obscureNew);

  void toggleObscureConfirm() =>
      state = state.copyWith(obscureConfirm: !state.obscureConfirm);

  void resetPasswordChanged() => state = state.copyWith(passwordChanged: false);

  void clearPasswordFields() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }

  Future<bool> callGetMe() async {
    return await runSafely<bool?>(() async {
          final response = await _authRepository.getMe();
          state = state.copyWith(user: response.data!.clinicUser);
          return true;
        }) ??
        false;
  }

  Future<bool> login({required LoginRequestModel loginReq}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.login(req: loginReq);
          state = state.copyWith(user: response.clinicUser);
          return true;
        }) ??
        false;
  }

  Future<bool> changePassword() async {
    return await runSafely<bool?>(showLoading: true, () async {
          final req = ChangePasswordRequestModel(
            currentPassword: currentPasswordController.text.trim(),
            newPassword: confirmPasswordController.text.trim(),
          );
          await _authRepository.changePassword(req: req);
          state = state.copyWith(passwordChanged: true);
          clearPasswordFields();

          return true;
        }) ??
        false;
  }

  Future<bool> forgetPassword({required String email}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final req = ForgetPasswordRequest(email: email);
          final response = await _authRepository.forgetPassword(req: req);
          EasyLoading.showSuccess(response.message);
          state = state.copyWith(passwordChanged: true);
          clearPasswordFields();

          return true;
        }) ??
        false;
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.verifyOtp(
            req: VerifyOtpRequest(email: email, otp: otp),
          );
          state = state.copyWith(resetToken: response.resetToken);
          return true;
        }) ??
        false;
  }

  void saveSignature(ui.Image image) {
    state = state.copyWith(signature: image);
  }

  void clearSignature() {
    state = state.copyWith(signature: null);
  }

  Future<bool> createNewPassword({
    required String email,
    required String newPassword,
  }) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final req = ResetPasswordRequest(
            email: email,
            resetToken: state.resetToken,
            newPassword: newPassword,
          );
          final response = await _authRepository.resetPassword(req: req);
          EasyLoading.showSuccess(response.message);
          state = state.copyWith(passwordChanged: true);
          clearPasswordFields();

          return true;
        }) ??
        false;
  }

  Future<bool> getClinicDetail() async {
    return await runSafely<bool?>(() async {
          final clinic = await _authRepository.getClinicDetail();
          state = state.copyWith(clinicDetail: clinic);
          return true;
        }) ??
        false;
  }

  Future<bool> updateClinicProfile({required Clinic updateReq}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _authRepository.updateClinicProfile(
            req: updateReq,
          );
          if (response.success && response.data != null) {
            state = state.copyWith(clinicDetail: response.data);
            EasyLoading.showSuccess(response.message);
            return true;
          }
          return false;
        }) ??
        false;
  }

  void disposeControllers() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  void navigateDailogIndexToNext(int value) {
    state = state.copyWith(navigateDailogIndex: value);
  }

  void resetnavigateDailogIndex() {
    state = state.copyWith(navigateDailogIndex: 1);
  }

  void setCountry(CountryCode? country) {
    state = state.copyWith(country: country);
  }
}

class AuthState {
  final bool loading;
  final bool isAuthenticated;
  final UserModel? user;
  final Clinic? clinicDetail;

  final String? error;
  final bool passwordChanged;
  final bool obscureCurrent;
  final bool obscureNew;
  final bool obscureConfirm;
  final String resetToken;
  final ui.Image? signature;
  final int navigateDailogIndex;
  final CountryCode? country;

  AuthState({
    this.loading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
    this.clinicDetail,
    this.passwordChanged = false,
    this.obscureCurrent = true,
    this.obscureNew = true,
    this.obscureConfirm = true,
    this.resetToken = '',
    this.signature,
    this.navigateDailogIndex = 0,
    this.country,
  });

  AuthState copyWith({
    bool? loading,
    bool? isAuthenticated,
    String? error,
    UserModel? user,
    Clinic? clinicDetail,
    String? resetToken,
    bool? passwordChanged,
    bool? obscureCurrent,
    bool? obscureNew,
    bool? obscureConfirm,
    ui.Image? signature,
    int? navigateDailogIndex,
    CountryCode? country,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      clinicDetail: clinicDetail ?? this.clinicDetail,
      error: error,
      passwordChanged: passwordChanged ?? this.passwordChanged,
      obscureCurrent: obscureCurrent ?? this.obscureCurrent,
      obscureNew: obscureNew ?? this.obscureNew,
      obscureConfirm: obscureConfirm ?? this.obscureConfirm,
      resetToken: resetToken ?? this.resetToken,
      signature: signature ?? this.signature,
      navigateDailogIndex: navigateDailogIndex ?? this.navigateDailogIndex,
      country: country ?? this.country,
    );
  }
}
