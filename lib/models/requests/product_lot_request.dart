import 'base_request.dart';

class ProductLotRequest extends BaseRequest {
  final int batchId;
  final String lotNumber;
  final String lotBarcode;
  final String expirationDate;
  final double clinicCost;
  final double retailPricePerUnit;
  final String supplier;
  final int quantityReceived;

  ProductLotRequest({
    required this.batchId,
    required this.lotNumber,
    required this.lotBarcode,
    required this.expirationDate,
    required this.clinicCost,
    required this.retailPricePerUnit,
    required this.supplier,
    required this.quantityReceived,
  });

  @override
  Map<String, dynamic> toJson() => {
        "lot_number": lotNumber,
        "lot_barcode": lotBarcode,
        "expiration_date": expirationDate,
        "clinic_cost": clinicCost,
        "retail_price_per_unit": retailPricePerUnit,
        "supplier": supplier,
        "quantity_received": quantityReceived,
      };

  ProductLotRequest copyWith({
    int? batchId,
    String? lotNumber,
    String? lotBarcode,
    String? expirationDate,
    double? clinicCost,
    double? retailPricePerUnit,
    String? supplier,
    int? quantityReceived,
  }) {
    return ProductLotRequest(
      batchId: batchId ?? this.batchId,
      lotNumber: lotNumber ?? this.lotNumber,
      lotBarcode: lotBarcode ?? this.lotBarcode,
      expirationDate: expirationDate ?? this.expirationDate,
      clinicCost: clinicCost ?? this.clinicCost,
      retailPricePerUnit: retailPricePerUnit ?? this.retailPricePerUnit,
      supplier: supplier ?? this.supplier,
      quantityReceived: quantityReceived ?? this.quantityReceived,
    );
  }
}
