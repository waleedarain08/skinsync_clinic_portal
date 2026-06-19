import 'base_response_model.dart';
import 'clinic_products_response.dart';

class AddInventoryResponse extends BaseResponse<ClinicProduct?> {
  AddInventoryResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory AddInventoryResponse.fromJson(Map<String, dynamic> json) =>
      AddInventoryResponse(
        data: json["data"] == null
            ? null
            : ClinicProduct.fromJson(json["data"]),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );
}
