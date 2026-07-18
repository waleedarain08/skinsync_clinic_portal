import 'base_request.dart';

class ProductBatchRequest extends BaseRequest {
  final int productId;
  final String batchNumber;
  final String manufactureDate;

  ProductBatchRequest({
    required this.productId,
    required this.batchNumber,
    required this.manufactureDate,
  });

  @override
  Map<String, dynamic> toJson() => {
        "batch_number": batchNumber,
        "manufacture_date": manufactureDate,
      };

  ProductBatchRequest copyWith({
    int? productId,
    String? batchNumber,
    String? manufactureDate,
  }) {
    return ProductBatchRequest(
      productId: productId ?? this.productId,
      batchNumber: batchNumber ?? this.batchNumber,
      manufactureDate: manufactureDate ?? this.manufactureDate,
    );
  }
}
