import '../product_model.dart';
import 'base_response_model.dart';

class ProductDetailResponse extends BaseApiResponseModel<ProductDetailModel> {
  const ProductDetailResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    final bool success = (json['is_success'] as bool?) ?? false;
    return ProductDetailResponse(
      success: success,
      message: json['message'] ?? '',
      data: json['data'] == null
          ? null
          : ProductDetailModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class ProductDetailModel {
  final int? id;
  final String image;
  final String name;
  final String? brand;
  final String? manufacturer;
  final String? globalSku;
  final String? barcode;
  final String? usageType;
  final String? status;
  final String description;
  final String? unitType;
  final String? packageType;
  final String? billableUnit;
  final double? billableQuantityPerItem;
  final bool? enforceLotTracking;
  final int? totalQuantityRemaining;
  final bool? lowStockAlert;

  ProductDetailModel({
    this.id,
    required this.image,
    required this.name,
    this.brand,
    this.manufacturer,
    this.globalSku,
    this.barcode,
    this.usageType,
    this.status,
    required this.description,
    this.unitType,
    this.packageType,
    this.billableUnit,
    this.billableQuantityPerItem,
    this.enforceLotTracking,
    this.totalQuantityRemaining,
    this.lowStockAlert,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'] as int?,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'],
      manufacturer: json['manufacturer'],
      globalSku: json['global_sku'] ?? json['globalSku'],
      barcode: json['barcode'],
      usageType: json['usage_type'] ?? json['usageType'],
      status: json['status'],
      description: json['description'] ?? '',
      unitType: json['unit_type'] ?? json['unitType'],
      packageType: json['package_type'] ?? json['packageType'],
      billableUnit: json['billable_unit'] ?? json['billableUnit'],
      billableQuantityPerItem: (json['billable_quantity_per_item'] as num?)?.toDouble() ?? (json['billableQuantityPerItem'] as num?)?.toDouble(),
      enforceLotTracking: json['enforce_lot_tracking'] as bool? ?? json['enforceLotTracking'] as bool?,
      totalQuantityRemaining: json['total_quantity_remaining'] as int? ?? json['totalQuantityRemaining'] as int?,
      lowStockAlert: json['low_stock_alert'] as bool? ?? json['lowStockAlert'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'image': image,
      'name': name,
      'brand': brand,
      'manufacturer': manufacturer,
      'global_sku': globalSku,
      'barcode': barcode,
      'usage_type': usageType,
      'status': status,
      'description': description,
      'unit_type': unitType,
      'package_type': packageType,
      'billable_unit': billableUnit,
      'billable_quantity_per_item': billableQuantityPerItem,
      'enforce_lot_tracking': enforceLotTracking,
      'total_quantity_remaining': totalQuantityRemaining,
      'low_stock_alert': lowStockAlert,
    };
  }

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      image: image,
      name: name,
      brand: brand,
      manufacturer: manufacturer,
      globalSku: globalSku,
      barcode: barcode,
      productPurpose: usageType,
      status: status,
      description: description,
      unitType: unitType,
      packageType: packageType,
      billableUnit: billableUnit,
      billableQuantityPerItem: billableQuantityPerItem,
      enforceLotTracking: enforceLotTracking,
      unit: unitType ?? '',
    );
  }

  ProductDetailModel copyWith({
    int? id,
    String? image,
    String? name,
    String? brand,
    String? manufacturer,
    String? globalSku,
    String? barcode,
    String? usageType,
    String? status,
    String? description,
    String? unitType,
    String? packageType,
    String? billableUnit,
    double? billableQuantityPerItem,
    bool? enforceLotTracking,
    int? totalQuantityRemaining,
    bool? lowStockAlert,
  }) {
    return ProductDetailModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      globalSku: globalSku ?? this.globalSku,
      barcode: barcode ?? this.barcode,
      usageType: usageType ?? this.usageType,
      status: status ?? this.status,
      description: description ?? this.description,
      unitType: unitType ?? this.unitType,
      packageType: packageType ?? this.packageType,
      billableUnit: billableUnit ?? this.billableUnit,
      billableQuantityPerItem: billableQuantityPerItem ?? this.billableQuantityPerItem,
      enforceLotTracking: enforceLotTracking ?? this.enforceLotTracking,
      totalQuantityRemaining: totalQuantityRemaining ?? this.totalQuantityRemaining,
      lowStockAlert: lowStockAlert ?? this.lowStockAlert,
    );
  }
}

class ProductDetailDummy {
  static ProductDetailModel getDummyProductDetail(int id) {
    return ProductDetailModel(
      id: id,
      image: '',
      name: 'Juvederm Ultra XC',
      brand: 'Allergan',
      manufacturer: 'AbbVie Inc.',
      globalSku: 'PRD-0001-JUVD',
      barcode: '5901234123457',
      usageType: 'treatment',
      status: 'active',
      description: 'Hyaluronic acid dermal filler indicated for deep injection into facial tissue for correction of moderate to severe facial wrinkles and folds.',
      unitType: 'syringe',
      packageType: 'box',
      billableUnit: 'ml',
      billableQuantityPerItem: 1.0,
      enforceLotTracking: true,
      totalQuantityRemaining: 82,
      lowStockAlert: true,
    );
  }
}