import 'base_response_model.dart';
import 'register_practitioner_response.dart';

class PractitionerDetailResponse extends BaseApiResponseModel<Practitioner> {
  PractitionerDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory PractitionerDetailResponse.fromJson(Map<String, dynamic> json) =>
      PractitionerDetailResponse(
        success: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : Practitioner.fromJson(json["data"]),
      );

  
}
