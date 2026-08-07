import 'base_response_model.dart';

class AdminProductListResponse extends BaseApiResponseModel<List<AdminProduct>> {
  final int page;
  final int limit;
  final int totalPages;

  const AdminProductListResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory AdminProductListResponse.fromJson(Map<String, dynamic> json) {
    return AdminProductListResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
              .map((e) => AdminProduct.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class AdminProduct {
  final int id;
  final String image;
  final String name;
  final String? brand;
  final String? manufacturer;

  final String? usageType;


  final String description;
  final String? unitType;
  final int? boxQuantity;
  final int? itemQuantityPerBox;
  final String? packageType;

  final double? totalBillableQuantity;
 

  const AdminProduct({
    required this.id,
    required this.image,
    required this.name,
    this.brand,
    this.manufacturer,
  
    this.usageType,
  
    required this.description,
    this.unitType,
    this.boxQuantity,
    this.itemQuantityPerBox,
    this.packageType,
   
    this.totalBillableQuantity,
   
  });

  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    return AdminProduct(
      id: json['id'] as int? ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      brand: json['brand'],
      manufacturer: json['manufacturer'],
     
      usageType: json['usage_type'] ?? json['usageType'],
     
    
      description: json['description'] ?? '',
      unitType: json['unit_type'] ?? json['unitType'],
      boxQuantity: json['box_quantity'] as int? ?? json['boxQuantity'] as int?,
      itemQuantityPerBox: json['item_quantity_per_box'] as int? ?? json['itemQuantityPerBox'] as int?,
      packageType: json['package_type'] ?? json['packageType'],
     
      totalBillableQuantity: (json['total_billable_quantity'] as num?)?.toDouble() ?? (json['totalBillableQuantity'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'brand': brand,
      'manufacturer': manufacturer,
   
      'usage_type': usageType,
    
    
      'description': description,
      'unit_type': unitType,
      'box_quantity': boxQuantity,
      'item_quantity_per_box': itemQuantityPerBox,
      'package_type': packageType,
    
      'total_billable_quantity': totalBillableQuantity,
     
    };
  }
}

class AdminDummyProducts {
  static List<AdminProduct> getDummyProductsForPage(int page, int limit) {
    final allProducts = [
      // Page 1
      const AdminProduct(
        id: 1,
        image: 'https://example.com/product1.png',
        name: 'Juvederm Ultra XC',
        brand: 'Allergan',
        manufacturer: 'AbbVie Inc.',
       
        usageType: 'treatment',
      
        description: 'Hyaluronic acid filler for lip augmentation and moderate facial wrinkles.',
        unitType: 'syringe',
        boxQuantity: 10,
        itemQuantityPerBox: 2,
        packageType: 'box',
       
        totalBillableQuantity: 20.0,
      
      ),
      const AdminProduct(
        id: 2,
        image: 'https://example.com/product2.png',
        name: 'Botox Cosmetic 100U',
        brand: 'Allergan',
        manufacturer: 'AbbVie Inc.',
    
        usageType: 'treatment',
      
        description: 'OnabotulinumtoxinA injection for temporary improvement of frown lines.',
        unitType: 'vial',
        boxQuantity: 5,
        itemQuantityPerBox: 1,
        packageType: 'box',
      
        totalBillableQuantity: 500.0,
       
      ),
      const AdminProduct(
        id: 3,
        image: 'https://example.com/product3.png',
        name: 'Restylane Lyft 1mL',
        brand: 'Galderma',
        manufacturer: 'Galderma Laboratories',
       
        usageType: 'treatment',
        
        description: 'Deep hyaluronic acid filler for cheek augmentation and mid-face contouring.',
        unitType: 'syringe',
        boxQuantity: 10,
        itemQuantityPerBox: 1,
        packageType: 'box',
       
        totalBillableQuantity: 10.0,
       
      ),
  ];

    final startIdx = (page - 1) * limit;
    if (startIdx >= allProducts.length) return [];
    final endIdx = startIdx + limit > allProducts.length ? allProducts.length : startIdx + limit;
    return allProducts.sublist(startIdx, endIdx);
  }
}
