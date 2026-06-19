import 'base_response_model.dart';

class ClinicProductsResponse extends BaseResponse<List<ClinicProduct>> {
  const ClinicProductsResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory ClinicProductsResponse.fromJson(Map<String, dynamic> json) {
    return ClinicProductsResponse(
      success: json["is_success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] != null
          ? List<ClinicProduct>.from(
              json["data"].map((x) => ClinicProduct.fromJson(x)),
            )
          : null,
    );
  }
}

class ClinicProduct {
  final int? clinicProductId;
  final int? productId;
  final String? image;
  final String? name;
  final String? unit;
  final int? totalQuantity;
  final int? originalPrice;
  final int? discount;
  final String? discountType;
  final num? discountedPrice;

  ClinicProduct({
    this.clinicProductId,
    this.productId,
    this.image,
    this.name,
    this.unit,
    this.totalQuantity,
    this.originalPrice,
    this.discount,
    this.discountType,
    this.discountedPrice,
  });

  factory ClinicProduct.fromJson(Map<String, dynamic> json) => ClinicProduct(
    clinicProductId: json["clinic_product_id"],
    productId: json["product_id"],
    image: json["image"],
    name: json["name"],
    unit: json["unit"],
    totalQuantity: json["total_quantity"],
    originalPrice: json["original_price"],
    discount: json["discount"],
    discountType: json["discount_type"],
    discountedPrice: json["discounted_price"],
  );
}