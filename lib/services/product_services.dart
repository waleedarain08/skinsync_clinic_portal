import 'dart:async';




import '../models/requests/add_inventory_request.dart';
import '../models/responses/add_inventory_response.dart';
import '../models/responses/admin_product_list_response.dart';
import '../models/responses/lot_items_list_response.dart';
import '../models/responses/product_batch_list_response.dart';
import '../models/responses/product_lots_response.dart';
import '../models/responses/brands_list_response.dart';
import '../models/responses/catalog_response.dart';
import '../models/responses/clinic_products_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/product_detail_response.dart';
import '../models/responses/product_list_response.dart';
import '../models/responses/supplier_list_response.dart';
import '../models/responses/unit_types_list_response.dart';
import '../models/responses/usage_type_list_response.dart';
import '../repositories/product_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ProductServices implements ProductRepository {
  final ApiBaseService _api;

  ProductServices({required ApiBaseService api}) : _api = api;

  // @override
  // Future<ProductModel> addProduct({required CreateProductRequest req}) async {
  //   final jsonResponse = await _api.httpRequest(
  //   requestType: RequestType.post,  endPoint:  Endpoint.products, requestBody: req.toJson());
  //   final response = ProductResponse.fromJson(jsonResponse);

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data!;
  // }

  // @override
  // Future<ProductModel> updateProduct({
  //   required int id,
  //   required CreateProductRequest req,
  // }) async {
  //   final jsonResponse = await _api.patch(
  //     Endpoint.updateProduct,
  //     body: req.toJson(),
  //     pathParams: {'id': id.toString()},
  //   );
  //   final response = ProductResponse.fromJson(jsonResponse);

  //   if (!response.isSuccess) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response.data!;
 // }

  // @override
  // Future<BaseResponse> deleteProduct({required int id}) async {
  //   final jsonResponse = await _api.delete(
  //     Endpoint.deleteProduct,
  //     pathParams: {'id': id.toString()},
  //   );
  //   final response = BaseResponse.fromJson(jsonResponse,(json) => json);

  //   if (!response.success) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response;
  // }

  @override
  Future<ProductListResponse> getProducts({
    required int page,
    required int limit,
    String search = '',
    String? selectedPurpose,
    ProductStatus? status,
    int? brandId,
  }) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.products,
        queryParams: {
          'search': search,
          'status' : status == null || status == ProductStatus.all ? '' : status.name,
          'usage' : selectedPurpose ?? '',
          'page': page.toString(),
          'limit': limit.toString(),
          if (brandId != null) 'brand': brandId.toString(),
        },
      );
      final response = ProductListResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      final list = InventoryDummyProducts.getDummyInventoryProductsForPage(page, limit);
      final filteredList = search.isEmpty
          ? list
          : list.where((p) =>
              p.name.toLowerCase().contains(search.toLowerCase()) ||
              (p.brand ?? '').toLowerCase().contains(search.toLowerCase()) ||
              (p.globalSku ?? '').toLowerCase().contains(search.toLowerCase())).toList();

      return ProductListResponse(
        success: true,
        message: 'Loaded paginated dummy inventory products',
        page: page,
        limit: limit,
        totalPages: 3, // 20 items / 8 per page = 3 pages
        data: filteredList,
      );
    }
  }

  @override
  Future<ProductDetailResponse> getProductDetail({required int id}) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.updateProduct,
        pathParams: {'id': id.toString()},
      );
      final response = ProductDetailResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      return ProductDetailResponse(
        success: true,
        message: 'Loaded dummy product detail',
        data: ProductDetailDummy.getDummyProductDetail(id),
      );
    }
  }

  @override
  Future<BrandListResponse> fetchBrand() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.getBrands);
    final response = BrandListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<ManufacturersListResponse> fetchManufacturer() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.manufacturersList);
    final response = ManufacturersListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<UnitTypesListResponse> fetchUnitTypes() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.unitTypesList);
    final response = UnitTypesListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<PackageTypeListResponse> fetchPackageTypes() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.packageTypeList);
    final response = PackageTypeListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<UsageTypeListResponse> fetchUsageTypes() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.usageType);
    final response = UsageTypeListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  @override
  Future<SupplierListResponse> fetchSuppliers() async {
    final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,endPoint: 
      Endpoint.suppliers);
    final response = SupplierListResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
  }

  // @override
  // Future<BaseResponse> updateProductStatus({
  //   required int productId,
  //   required String status,
  // }) async {
  //   final jsonResponse = await _api.httpRequest(
  //       requestType: RequestType.patch,endPoint: 
  //     Endpoint.productsStatus,
  //     requestBody: {'status': status},
  //     queryParams: {'product_id': productId.toString()},
  //   );
  //   final response = BaseResponse.fromJson(jsonResponse,(json) => json);
  //   if (!response.success) {
  //     throw BadRequestException(response.message);
  //   }
  //   return response;
  // }
 @override
  Future<List<CatalogItem>> getCatalog() async {
    final json = await _api.httpRequest(
      endPoint: Endpoint.catalog,
      requestType: RequestType.get,
    );
    final response = CatalogResponse.fromJson( json);
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data!;
  }
@override
  Future<List<ClinicProduct>> getClinicProducts() async {
    final json = await _api.httpRequest(
      endPoint: Endpoint.clinicProducts,
      requestType: RequestType.get,
    );
    final response = ClinicProductsResponse.fromJson(json);
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data ?? [];
  }

  @override
  Future<ClinicProduct> addInventoryItem(AddInventoryRequest request) async {
    final json = await _api.httpRequest(
      endPoint: Endpoint.clinicProducts,
      requestType: RequestType.post,
      requestBody: request,
    );
    final response = AddInventoryResponse.fromJson(json);
    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }
    return response.data!;
  }

  @override
  Future<AdminProductListResponse> getAdminProductList({
    required int page,
    required int limit,
    String search = '',
  }) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.adminProductList,
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
          'search': search,
        },
      );
      final response = AdminProductListResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      // Sliced mock paginated list
      final list = AdminDummyProducts.getDummyProductsForPage(page, limit);
      final filteredList = search.isEmpty
          ? list
          : list.where((p) =>
              p.name.toLowerCase().contains(search.toLowerCase()) ||
              (p.brand ?? '').toLowerCase().contains(search.toLowerCase()) ||
              (p.globalSku ?? '').toLowerCase().contains(search.toLowerCase())).toList();

      return AdminProductListResponse(
        success: true,
        message: 'Loaded paginated dummy admin products',
        page: page,
        limit: limit,
        totalPages: 3, // 20 items / 8 per page = 3 pages
        data: filteredList,
      );
    }
  }

  @override
  Future<ProductLotsResponse> getBatchLots({
    required int batchId,
    required int page,
    required int limit,
  }) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.batchLots,
        pathParams: {'batchId': batchId.toString()},
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      final response = ProductLotsResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      final list = BatchLotsDummy.getDummyLotsForBatch(batchId, page, limit);
      return ProductLotsResponse(
        success: true,
        message: 'Loaded paginated dummy lots',
        page: page,
        limit: limit,
        totalPages: (batchId == 1) ? 2 : 1,
        data: list,
      );
    }
  }

  @override
  Future<ProductBatchListResponse> getProductBatches({
    required int productId,
    required int page,
    required int limit,
  }) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.productBatches,
        pathParams: {'productId': productId.toString()},
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      final response = ProductBatchListResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      final list = BatchDummyProducts.getDummyBatchesForPage(productId, page, limit);
      return ProductBatchListResponse(
        success: true,
        message: 'Loaded paginated dummy batches',
        page: page,
        limit: limit,
        totalPages: 2,
        data: list,
      );
    }
  }

  @override
  Future<LotItemsListResponse> getLotItems({
    required int lotId,
    required int page,
    required int limit,
    String search = '',
  }) async {
    try {
      final jsonResponse = await _api.httpRequest(
        requestType: RequestType.get,
        endPoint: Endpoint.lotItems,
        pathParams: {'lotId': lotId.toString()},
        queryParams: {
          'page': page.toString(),
          'limit': limit.toString(),
          'search': search,
        },
      );
      final response = LotItemsListResponse.fromJson(jsonResponse);
      if (!response.isSuccess) {
        throw BadRequestException(response.message);
      }
      return response;
    } catch (e) {
      final list = LotItemsDummy.getDummyLotItems(lotId, page, limit, search);
      final totalPages = LotItemsDummy.getTotalPages(lotId, limit, search);
      return LotItemsListResponse(
        success: true,
        message: 'Loaded paginated dummy lot items',
        page: page,
        limit: limit,
        totalPages: totalPages,
        data: list,
      );
    }
  }

}