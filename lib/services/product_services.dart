import 'dart:async';




import '../models/requests/add_inventory_request.dart';
import '../models/responses/add_inventory_response.dart';
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
    final jsonResponse = await _api.httpRequest(
requestType: RequestType.get,
endPoint:       Endpoint.products,
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
  }

  @override
  Future<ProductDetailResponse> getProductDetail({required int id}) async {
    final jsonResponse = await _api.httpRequest(
      requestType: RequestType.get,endPoint: 
      Endpoint.updateProduct,
      pathParams: {'id': id.toString()},
    );
    final response = ProductDetailResponse.fromJson(jsonResponse);
    if (!response.isSuccess) {
      throw BadRequestException(response.message);
    }
    return response;
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


}