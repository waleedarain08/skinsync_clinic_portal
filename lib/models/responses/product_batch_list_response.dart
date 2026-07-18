import 'base_response_model.dart';

class ProductBatchListResponse extends BaseApiResponseModel<List<ProductBatchModel>> {
  final int page;
  final int limit;
  final int totalPages;

  const ProductBatchListResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory ProductBatchListResponse.fromJson(Map<String, dynamic> json) {
    return ProductBatchListResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 5,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => ProductBatchModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ProductBatchModel {
  final int id;
  final String batchNumber;
  final String manufactureDate;
  final int totalLots;
  final int totalQuantityRemaining;
  final String nearestExpiryDate;

  const ProductBatchModel({
    required this.id,
    required this.batchNumber,
    required this.manufactureDate,
    required this.totalLots,
    required this.totalQuantityRemaining,
    required this.nearestExpiryDate,
  });

  factory ProductBatchModel.fromJson(Map<String, dynamic> json) {
    return ProductBatchModel(
      id: json['id'] as int? ?? 0,
      batchNumber: json['batch_number'] ?? json['batchNumber'] ?? '',
      manufactureDate: json['manufacture_date'] ?? json['manufactureDate'] ?? '',
      totalLots: json['total_lots'] as int? ?? json['totalLots'] as int? ?? 0,
      totalQuantityRemaining: json['total_quantity_remaining'] as int? ?? json['totalQuantityRemaining'] as int? ?? 0,
      nearestExpiryDate: json['nearest_expiry_date'] ?? json['nearestExpiryDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batch_number': batchNumber,
      'manufacture_date': manufactureDate,
      'total_lots': totalLots,
      'total_quantity_remaining': totalQuantityRemaining,
      'nearest_expiry_date': nearestExpiryDate,
    };
  }
}

class BatchDummyProducts {
  static List<ProductBatchModel> getDummyBatchesForPage(int productId, int page, int limit) {
    final allBatches = [
      // Page 1
      const ProductBatchModel(
        id: 1,
        batchNumber: 'BATCH-2024-001',
        manufactureDate: '2024-01-15',
        totalLots: 2,
        totalQuantityRemaining: 50,
        nearestExpiryDate: '2026-01-15',
      ),
      const ProductBatchModel(
        id: 2,
        batchNumber: 'BATCH-2024-002',
        manufactureDate: '2024-06-01',
        totalLots: 1,
        totalQuantityRemaining: 32,
        nearestExpiryDate: '2026-06-01',
      ),

      // Page 2
      const ProductBatchModel(
        id: 3,
        batchNumber: 'BATCH-2024-003 (Page 2)',
        manufactureDate: '2024-09-10',
        totalLots: 1,
        totalQuantityRemaining: 15,
        nearestExpiryDate: '2026-09-10',
      ),
      const ProductBatchModel(
        id: 4,
        batchNumber: 'BATCH-2024-004 (Page 2)',
        manufactureDate: '2024-11-20',
        totalLots: 2,
        totalQuantityRemaining: 45,
        nearestExpiryDate: '2027-01-20',
      ),
    ];

    final startIdx = (page - 1) * limit;
    if (startIdx >= allBatches.length) return [];
    final endIdx = startIdx + limit > allBatches.length ? allBatches.length : startIdx + limit;
    return allBatches.sublist(startIdx, endIdx);
  }
}