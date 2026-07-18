
import '../models/requests/add_inventory_request.dart';
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
import '../utils/enums.dart';

abstract class ProductRepository {
  Future<LotItemsListResponse> getLotItems({
    required int lotId,
    required int page,
    required int limit,
    String search = '',
  });

  Future<ProductBatchListResponse> getProductBatches({
    required int productId,
    required int page,
    required int limit,
  });

  Future<ProductLotsResponse> getBatchLots({
    required int batchId,
    required int page,
    required int limit,
  });

  Future<AdminProductListResponse> getAdminProductList({
    required int page,
    required int limit,
    String search = '',
  });
  // Future<ProductModel> addProduct({required CreateProductRequest req});
  // Future<ProductModel> updateProduct({required int id, required CreateProductRequest req});
  // Future<BaseApiResponseModel> deleteProduct({required int id});
  Future<ProductListResponse> getProducts({
    required int page,
    required int limit,
    String search = '',
    String? selectedPurpose,
    ProductStatus? status,
    int? brandId,
  });
  Future<ProductDetailResponse> getProductDetail({required int id});
  Future<BrandListResponse> fetchBrand();
  Future<ManufacturersListResponse> fetchManufacturer();
  Future<UnitTypesListResponse> fetchUnitTypes();
  Future<PackageTypeListResponse> fetchPackageTypes();
  Future<UsageTypeListResponse> fetchUsageTypes();
  Future<SupplierListResponse> fetchSuppliers();
   Future<List<CatalogItem>> getCatalog();
    Future<List<ClinicProduct>> getClinicProducts();
    Future<ClinicProduct> addInventoryItem(AddInventoryRequest request);
 // Future<BaseApiResponseModel> updateProductStatus({required int productId, required String status});
}