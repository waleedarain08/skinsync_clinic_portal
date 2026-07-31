import 'appointment_list_response.dart';
import 'base_response_model.dart';

class AppointmentDetailResponse extends BaseApiResponseModel<AppointmentData> {
  AppointmentDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AppointmentDetailResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailResponse(
        success: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : AppointmentData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "is_success": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}
