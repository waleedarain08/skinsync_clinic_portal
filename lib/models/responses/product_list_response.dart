import '../product_model.dart';
import 'base_response_model.dart';

class ProductListResponse extends BaseApiResponseModel<List<ProductListItemModel>> {
  final int page;
  final int limit;
  final int totalPages;

  const ProductListResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => ProductListItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ProductListItemModel {
  final int id;
  final String name;
  final String image;
  final String? brand;
  final String? globalSku;
  final String? usageType;
  final String? status;
  final String? unitType;
  final int totalQuantityRemaining;
  final String? nearestExpiryDate;
  final int totalLots;
  final bool lowStockAlert;

  const ProductListItemModel({
    required this.id,
    required this.name,
    required this.image,
    this.brand,
    this.globalSku,
    this.usageType,
    this.status,
    this.unitType,
    required this.totalQuantityRemaining,
    this.nearestExpiryDate,
    required this.totalLots,
    required this.lowStockAlert,
  });

  factory ProductListItemModel.fromJson(Map<String, dynamic> json) {
    return ProductListItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      brand: json['brand'],
      globalSku: json['global_sku'] ?? json['globalSku'],
      usageType: json['usage_type'] ?? json['usageType'],
      status: json['status'],
      unitType: json['unit_type'] ?? json['unitType'],
      totalQuantityRemaining: json['total_quantity_remaining'] as int? ?? json['totalQuantityRemaining'] as int? ?? 0,
      nearestExpiryDate: json['nearest_expiry_date'] ?? json['nearestExpiryDate'],
      totalLots: json['total_lots'] as int? ?? json['totalLots'] as int? ?? 0,
      lowStockAlert: json['low_stock_alert'] as bool? ?? json['lowStockAlert'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'brand': brand,
      'global_sku': globalSku,
      'usage_type': usageType,
      'status': status,
      'unit_type': unitType,
      'total_quantity_remaining': totalQuantityRemaining,
      'nearest_expiry_date': nearestExpiryDate,
      'total_lots': totalLots,
      'low_stock_alert': lowStockAlert,
    };
  }

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      image: image,
      name: name,
      brand: brand,
      globalSku: globalSku,
      usageType: usageType,
      status: status,
      unitType: unitType,
      totalQuantityRemaining: totalQuantityRemaining,
      nearestExpiryDate: nearestExpiryDate,
      totalLots: totalLots,
      lowStockAlert: lowStockAlert,
      description: '',
      unit: '',
    );
  }
}

class InventoryDummyProducts {
  static List<ProductListItemModel> getDummyInventoryProductsForPage(int page, int limit) {
    final allProducts = [
      // Page 1
      const ProductListItemModel(
        id: 1,
        name: 'Juvederm Ultra XC',
        image: '',
        brand: 'Allergan',
        globalSku: 'PRD-0001-JUVD',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 82,
        nearestExpiryDate: '2026-01-15',
        totalLots: 3,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 2,
        name: 'Botox Cosmetic 100U',
        image: '',
        brand: 'Allergan',
        globalSku: 'PRD-0002-BOTOX',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 8,
        nearestExpiryDate: '2025-08-30',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 3,
        name: 'Restylane Lyft 1mL',
        image: '',
        brand: 'Galderma',
        globalSku: 'PRD-0003-REST',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 45,
        nearestExpiryDate: '2026-04-12',
        totalLots: 2,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 4,
        name: 'Sculptra Aesthetic',
        image: '',
        brand: 'Galderma',
        globalSku: 'PRD-0004-SCULP',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 5,
        nearestExpiryDate: '2025-11-20',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 5,
        name: 'Dysport 300U',
        image: '',
        brand: 'Galderma',
        globalSku: 'PRD-0005-DYSP',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 120,
        nearestExpiryDate: '2027-02-15',
        totalLots: 4,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 6,
        name: 'Xeomin 100U',
        image: '',
        brand: 'Merz Aesthetics',
        globalSku: 'PRD-0006-XEOM',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 3,
        nearestExpiryDate: '2025-07-10',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 7,
        name: 'Radiesse (+) 1.5cc',
        image: '',
        brand: 'Merz Aesthetics',
        globalSku: 'PRD-0007-RADI',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 30,
        nearestExpiryDate: '2026-09-05',
        totalLots: 2,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 8,
        name: 'Belotero Balance 1mL',
        image: '',
        brand: 'Merz Aesthetics',
        globalSku: 'PRD-0008-BELO',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 18,
        nearestExpiryDate: '2026-05-18',
        totalLots: 2,
        lowStockAlert: false,
      ),

      // Page 2
      const ProductListItemModel(
        id: 9,
        name: 'Revanesse Versa 1mL',
        image: '',
        brand: 'Prollenium',
        globalSku: 'PRD-0009-VERS',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 60,
        nearestExpiryDate: '2026-10-22',
        totalLots: 3,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 10,
        name: 'Teosyal Redensity II',
        image: '',
        brand: 'Teoxane',
        globalSku: 'PRD-0010-TEOS',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 4,
        nearestExpiryDate: '2025-12-05',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 11,
        name: 'Profhilo 2mL',
        image: '',
        brand: 'IBSA',
        globalSku: 'PRD-0011-PROF',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 25,
        nearestExpiryDate: '2026-08-14',
        totalLots: 2,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 12,
        name: 'Juvéderm Voluma XC',
        image: '',
        brand: 'Allergan',
        globalSku: 'PRD-0012-VOLU',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 90,
        nearestExpiryDate: '2027-01-30',
        totalLots: 4,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 13,
        name: 'Kybella 4x2mL',
        image: '',
        brand: 'Allergan',
        globalSku: 'PRD-0013-KYBE',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 2,
        nearestExpiryDate: '2025-10-10',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 14,
        name: 'Restylane Kysse 1mL',
        image: '',
        brand: 'Galderma',
        globalSku: 'PRD-0014-KYSS',
        usageType: 'treatment',
        status: 'active',
        unitType: 'syringe',
        totalQuantityRemaining: 55,
        nearestExpiryDate: '2026-11-04',
        totalLots: 3,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 15,
        name: 'Sculptra (Reconstituted)',
        image: '',
        brand: 'Galderma',
        globalSku: 'PRD-0015-SCULP-REC',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 15,
        nearestExpiryDate: '2026-03-25',
        totalLots: 2,
        lowStockAlert: false,
      ),

      // Page 3
      const ProductListItemModel(
        id: 16,
        name: 'Perfect Derma Peel',
        image: '',
        brand: 'Perfect Derma',
        globalSku: 'PRD-0016-PEEL',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 1,
        nearestExpiryDate: '2025-09-12',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 17,
        name: 'VI Peel Purify',
        image: '',
        brand: 'VI Peel',
        globalSku: 'PRD-0017-VIPE',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 12,
        nearestExpiryDate: '2026-02-14',
        totalLots: 1,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 18,
        name: 'Aquagold Fine Touch',
        image: '',
        brand: 'Aquagold',
        globalSku: 'PRD-0018-GOLD',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 7,
        nearestExpiryDate: '2025-11-01',
        totalLots: 1,
        lowStockAlert: true,
      ),
      const ProductListItemModel(
        id: 19,
        name: 'SurgiMend Collagen 2x2',
        image: '',
        brand: 'SurgiMend',
        globalSku: 'PRD-0019-SURG',
        usageType: 'treatment',
        status: 'active',
        unitType: 'item',
        totalQuantityRemaining: 32,
        nearestExpiryDate: '2027-04-05',
        totalLots: 3,
        lowStockAlert: false,
      ),
      const ProductListItemModel(
        id: 20,
        name: 'HylaActive 30mL',
        image: '',
        brand: 'Dp Derm',
        globalSku: 'PRD-0020-HYLA',
        usageType: 'treatment',
        status: 'active',
        unitType: 'vial',
        totalQuantityRemaining: 40,
        nearestExpiryDate: '2026-07-28',
        totalLots: 2,
        lowStockAlert: false,
      ),
    ];

    final startIdx = (page - 1) * limit;
    if (startIdx >= allProducts.length) return [];
    final endIdx = startIdx + limit > allProducts.length ? allProducts.length : startIdx + limit;
    return allProducts.sublist(startIdx, endIdx);
  }
}