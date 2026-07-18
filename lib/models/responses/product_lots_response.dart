import 'base_response_model.dart';

class ProductLotsResponse extends BaseApiResponseModel<List<LotModel>> {
  final int page;
  final int limit;
  final int totalPages;

  const ProductLotsResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory ProductLotsResponse.fromJson(Map<String, dynamic> json) {
    return ProductLotsResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 5,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => LotModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class LotModel {
  final int id;
  final String lotNumber;
  final String lotBarcode;
  final String expirationDate;
  final double clinicCost;
  final double retailPricePerUnit;
  final String supplier;
  final int quantityReceived;
  final int quantityRemaining;
  final String status;

  const LotModel({
    required this.id,
    required this.lotNumber,
    required this.lotBarcode,
    required this.expirationDate,
    required this.clinicCost,
    required this.retailPricePerUnit,
    required this.supplier,
    required this.quantityReceived,
    required this.quantityRemaining,
    required this.status,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'] as int? ?? 0,
      lotNumber: json['lot_number'] ?? json['lotNumber'] ?? '',
      lotBarcode: json['lot_barcode'] ?? json['lotBarcode'] ?? '',
      expirationDate: json['expiration_date'] ?? json['expirationDate'] ?? '',
      clinicCost: (json['clinic_cost'] as num?)?.toDouble() ?? (json['clinicCost'] as num?)?.toDouble() ?? 0.0,
      retailPricePerUnit: (json['retail_price_per_unit'] as num?)?.toDouble() ?? (json['retailPricePerUnit'] as num?)?.toDouble() ?? 0.0,
      supplier: json['supplier'] ?? '',
      quantityReceived: json['quantity_received'] as int? ?? json['quantityReceived'] as int? ?? 0,
      quantityRemaining: json['quantity_remaining'] as int? ?? json['quantityRemaining'] as int? ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lot_number': lotNumber,
      'lot_barcode': lotBarcode,
      'expiration_date': expirationDate,
      'clinic_cost': clinicCost,
      'retail_price_per_unit': retailPricePerUnit,
      'supplier': supplier,
      'quantity_received': quantityReceived,
      'quantity_remaining': quantityRemaining,
      'status': status,
    };
  }

  LotModel copyWith({
    int? id,
    String? lotNumber,
    String? lotBarcode,
    String? expirationDate,
    double? clinicCost,
    double? retailPricePerUnit,
    String? supplier,
    int? quantityReceived,
    int? quantityRemaining,
    String? status,
  }) {
    return LotModel(
      id: id ?? this.id,
      lotNumber: lotNumber ?? this.lotNumber,
      lotBarcode: lotBarcode ?? this.lotBarcode,
      expirationDate: expirationDate ?? this.expirationDate,
      clinicCost: clinicCost ?? this.clinicCost,
      retailPricePerUnit: retailPricePerUnit ?? this.retailPricePerUnit,
      supplier: supplier ?? this.supplier,
      quantityReceived: quantityReceived ?? this.quantityReceived,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      status: status ?? this.status,
    );
  }
}

class BatchLotsDummy {
  static List<LotModel> getDummyLotsForBatch(int batchId, int page, int limit) {
    // Generates distinct lots based on Batch ID and Page
    if (batchId == 1) {
      if (page == 1) {
        return [
          const LotModel(
            id: 1,
            lotNumber: 'LOT-2024-001-A',
            lotBarcode: 'LOT5901234123457A',
            expirationDate: '2026-01-15',
            clinicCost: 300.00,
            retailPricePerUnit: 500.00,
            supplier: 'MedSupply Co.',
            quantityReceived: 50,
            quantityRemaining: 32,
            status: 'active',
          ),
          const LotModel(
            id: 2,
            lotNumber: 'LOT-2024-001-B',
            lotBarcode: 'LOT5901234123457B',
            expirationDate: '2026-03-10',
            clinicCost: 310.00,
            retailPricePerUnit: 520.00,
            supplier: 'PharmaDist Ltd.',
            quantityReceived: 30,
            quantityRemaining: 18,
            status: 'active',
          ),
        ];
      } else {
        return [
          const LotModel(
            id: 11,
            lotNumber: 'LOT-2024-001-C (Page 2)',
            lotBarcode: 'LOT5901234123457A2',
            expirationDate: '2026-04-20',
            clinicCost: 305.00,
            retailPricePerUnit: 510.00,
            supplier: 'GlobalCare Distributors',
            quantityReceived: 40,
            quantityRemaining: 12,
            status: 'active',
          ),
        ];
      }
    } else if (batchId == 2) {
      return [
        const LotModel(
          id: 3,
          lotNumber: 'LOT-2024-002-A',
          lotBarcode: 'LOT5901234123457C',
          expirationDate: '2026-06-01',
          clinicCost: 295.00,
          retailPricePerUnit: 495.00,
          supplier: 'MedSupply Co.',
          quantityReceived: 100,
          quantityRemaining: 32,
          status: 'active',
        ),
      ];
    } else {
      return [
        LotModel(
          id: batchId * 10,
          lotNumber: 'LOT-GENERIC-$batchId-A',
          lotBarcode: 'BARCODE-$batchId',
          expirationDate: '2026-12-31',
          clinicCost: 280.00,
          retailPricePerUnit: 450.00,
          supplier: 'Generic Pharma Inc.',
          quantityReceived: 80,
          quantityRemaining: 45,
          status: 'active',
        )
      ];
    }
  }
}