import 'base_response_model.dart';

class TreatmentHistoryDetailResponse extends BaseApiResponseModel<Map<String, dynamic>> {
  TreatmentHistoryDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory TreatmentHistoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      TreatmentHistoryDetailResponse(
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
        data: json["data"],
      );
}
