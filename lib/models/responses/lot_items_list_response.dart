import 'base_response_model.dart';

class LotItemsListResponse extends BaseApiResponseModel<List<LotItemModel>> {
  final int page;
  final int limit;
  final int totalPages;

  const LotItemsListResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory LotItemsListResponse.fromJson(Map<String, dynamic> json) {
    return LotItemsListResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 12,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => LotItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class LotItemModel {
  final int id;
  final String serialNumber;
  final String itemBarcode;
  final String status;

  const LotItemModel({
    required this.id,
    required this.serialNumber,
    required this.itemBarcode,
    required this.status,
  });

  factory LotItemModel.fromJson(Map<String, dynamic> json) {
    return LotItemModel(
      id: json['id'] as int? ?? 0,
      serialNumber: json['serial_number'] ?? json['serialNumber'] ?? '',
      itemBarcode: json['item_barcode'] ?? json['itemBarcode'] ?? '',
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial_number': serialNumber,
      'item_barcode': itemBarcode,
      'status': status,
    };
  }

  LotItemModel copyWith({
    int? id,
    String? serialNumber,
    String? itemBarcode,
    String? status,
  }) {
    return LotItemModel(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      itemBarcode: itemBarcode ?? this.itemBarcode,
      status: status ?? this.status,
    );
  }
}

class LotItemsDummy {
  static List<LotItemModel> getDummyLotItems(int lotId, int page, int limit, String search) {
    final allItems = <LotItemModel>[];
    
    // Generate 45 total dummy items
    final statuses = ['available', 'used', 'reserved', 'damaged'];
    for (int i = 1; i <= 45; i++) {
      final snIndex = (i % 1000).toString().padLeft(4, '0');
      final bcIndex = i.toString().padLeft(3, '0');
      final lotPrefix = lotId.toString().padLeft(3, '0');
      
      allItems.add(
        LotItemModel(
          id: i,
          serialNumber: 'SN-2024-$lotPrefix-$snIndex',
          itemBarcode: 'ITEM5901234$lotPrefix$bcIndex',
          status: statuses[i % statuses.length],
        ),
      );
    }

    // Filter by search query locally
    final filtered = search.isEmpty
        ? allItems
        : allItems.where((item) =>
            item.serialNumber.toLowerCase().contains(search.toLowerCase()) ||
            item.itemBarcode.toLowerCase().contains(search.toLowerCase())).toList();

    final startIdx = (page - 1) * limit;
    if (startIdx >= filtered.length) return [];
    final endIdx = startIdx + limit > filtered.length ? filtered.length : startIdx + limit;
    return filtered.sublist(startIdx, endIdx);
  }

  static int getTotalPages(int lotId, int limit, String search) {
    final allItems = <LotItemModel>[];
    final statuses = ['available', 'used', 'reserved', 'damaged'];
    for (int i = 1; i <= 45; i++) {
      final snIndex = (i % 1000).toString().padLeft(4, '0');
      final bcIndex = i.toString().padLeft(3, '0');
      final lotPrefix = lotId.toString().padLeft(3, '0');
      
      allItems.add(
        LotItemModel(
          id: i,
          serialNumber: 'SN-2024-$lotPrefix-$snIndex',
          itemBarcode: 'ITEM5901234$lotPrefix$bcIndex',
          status: statuses[i % statuses.length],
        ),
      );
    }

    final filtered = search.isEmpty
        ? allItems
        : allItems.where((item) =>
            item.serialNumber.toLowerCase().contains(search.toLowerCase()) ||
            item.itemBarcode.toLowerCase().contains(search.toLowerCase())).toList();

    return (filtered.length / limit).ceil();
  }
}