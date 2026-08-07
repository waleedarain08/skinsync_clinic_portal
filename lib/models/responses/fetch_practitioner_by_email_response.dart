import 'base_response_model.dart';
import 'register_practitioner_response.dart';

class FetchPractitionerByEmailResponse extends BaseResponse<FetchedPractitionerData> {
  const FetchPractitionerByEmailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory FetchPractitionerByEmailResponse.fromJson(Map<String, dynamic> json) =>
      FetchPractitionerByEmailResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"] == null ? null : FetchedPractitionerData.fromJson(json["data"]),
      );
}

class FetchedPractitionerData {
  final BasicInfo? basicInfo;
  final ContactInfo? contactInfo;
  final LicenseInfo? licenseInfo;

  FetchedPractitionerData({
    this.basicInfo,
    this.contactInfo,
    this.licenseInfo,
  });

  factory FetchedPractitionerData.fromJson(Map<String, dynamic> json) =>
      FetchedPractitionerData(
        basicInfo: json["basic_info"] == null
            ? null
            : BasicInfo.fromJson(json["basic_info"]),
        contactInfo: json["contact_info"] == null
            ? null
            : ContactInfo.fromJson(json["contact_info"]),
        licenseInfo: json["license_info"] == null
            ? null
            : LicenseInfo.fromJson(json["license_info"]),
      );
}
