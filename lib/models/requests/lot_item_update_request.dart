import 'base_request.dart';

class LotItemUpdateRequest extends BaseRequest {
  final int itemId;
  final String serialNumber;
  final String itemBarcode;

  LotItemUpdateRequest({
    required this.itemId,
    required this.serialNumber,
    required this.itemBarcode,
  });

  @override
  Map<String, dynamic> toJson() => {
        "serial_number": serialNumber,
        "item_barcode": itemBarcode,
      };

  LotItemUpdateRequest copyWith({
    int? itemId,
    String? serialNumber,
    String? itemBarcode,
  }) {
    return LotItemUpdateRequest(
      itemId: itemId ?? this.itemId,
      serialNumber: serialNumber ?? this.serialNumber,
      itemBarcode: itemBarcode ?? this.itemBarcode,
    );
  }
}
