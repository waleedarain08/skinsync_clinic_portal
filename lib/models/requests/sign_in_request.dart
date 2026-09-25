class SignInRequest {
  String email;
  String password;
  String deviceToken;
  String deviceType;
  String role = 'user';
  String? timezone;
  String? utcOffset;

  SignInRequest({
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.deviceType,
    this.timezone,
    this.utcOffset,
  });

  factory SignInRequest.fromJson(Map<String, dynamic> json) {
    return SignInRequest(
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      deviceToken: json['deviceToken'] as String? ?? '',
      deviceType: json['deviceType'] as String? ?? '',
      timezone: json['timezone'] as String?,
      utcOffset: json['utc_offset'] as String?,
    )..role = json['role'] as String? ?? 'user';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['deviceToken'] = deviceToken;
    data['deviceType'] = deviceType;
    data['role'] = role;
    if (timezone != null) data['timezone'] = timezone;
    if (utcOffset != null) data['utc_offset'] = utcOffset;
    return data;
  }
}
