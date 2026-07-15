import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../exceptions/app_exception.dart';
import '../models/product_model.dart';
import '../models/requests/add_inventory_request.dart';
import '../models/responses/brands_list_response.dart';
import '../models/responses/catalog_response.dart';
import '../models/responses/clinic_products_response.dart';
import '../models/responses/manufacturers_list_response.dart';
import '../models/responses/package_type_list_response.dart';
import '../models/responses/product_detail_response.dart';
import '../models/responses/supplier_list_response.dart';
import '../models/responses/unit_types_list_response.dart';
import '../models/responses/usage_type_list_response.dart';
import '../repositories/product_repository.dart';
import '../services/locator.dart';

import '../services/media_service.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final productViewModelProvider =
    NotifierProvider<ProductViewModel, ProductState>(ProductViewModel.new);

class ProductState {
  final List<ProductModel> products;
  final String? errorMessage;
  final int pageSize;
  final String searchKeyword;
  final ProductDetailModel? selectedProduct;
  final String? imageUrl;

  final List<BrandModel>? brands;
  final List<ManufacturersModel>? manufacturers;
  final List<UnitTypeModel>? unitTypes;

  final List<PackageTypeModel>? packageTypes;
  final List<UsageTypeModel>? usageType;
  final List<SupplierModel>? suppliers;
  final bool loading;
  final int currentPage;
  final int totalPages;
   final bool  addProductLoading;
  final List<CatalogItem> catalog;
  final List<ClinicProduct> clinicProducts;
  final bool inventoryAdded;
  ProductState({
    this.loading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.products = const [],
    this.errorMessage,
    this.pageSize = 20,
    this.searchKeyword = '',
    this.selectedProduct,
    this.brands,
    this.manufacturers,
    this.unitTypes,
    this.packageTypes,
    this.imageUrl,
    this.usageType,
    this.suppliers,
    this.addProductLoading = false,
    this.catalog = const [],
    this.clinicProducts = const [],
    this.inventoryAdded = false,
  });

  ProductState copyWith({
    bool? loading,
    List<ProductModel>? products,
    String? errorMessage,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    String? searchKeyword,
    ProductDetailModel? selectedProduct,
    List<UnitTypeModel>? unitTypes,
    List<PackageTypeModel>? packageTypes,
    String? imageUrl,
     bool? addProductLoading,
    List<CatalogItem>? catalog,
    List<ClinicProduct>? clinicProducts,
    bool? inventoryAdded,
    List<BrandModel>? brands,
    List<ManufacturersModel>? manufacturers,
    List<UsageTypeModel>? usageType,
    List<SupplierModel>? suppliers,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      pageSize: pageSize ?? this.pageSize,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      brands: brands ?? this.brands,
      manufacturers: manufacturers ?? this.manufacturers,
      imageUrl: imageUrl ?? this.imageUrl,
      unitTypes: unitTypes ?? this.unitTypes,
      packageTypes: packageTypes ?? this.packageTypes,
      usageType: usageType ?? this.usageType,
      suppliers: suppliers ?? this.suppliers,
      addProductLoading: addProductLoading ?? this.addProductLoading,
      catalog: catalog ?? this.catalog,
      clinicProducts: clinicProducts ?? this.clinicProducts,
      inventoryAdded: inventoryAdded ?? false,
    );
  }
}

class ProductViewModel extends BaseViewModel<ProductState> {
  ProductViewModel();

  @override
  ProductState build() {
    init();
    ref.onDispose(dispose);
    return ProductState();
  }

  @override
  void onError(String message) {
    state = state.copyWith(
      loading: false,
      addProductLoading: false,
      inventoryAdded: false,
    );
    super.onError(message);
  }

  final ProductRepository _productRepository = locator<ProductRepository>();

  // Maintain properties as getters from state for easy external consumption
  List<ProductModel> get products => state.products;
  bool get isLoading => state.loading;
  String? get errorMessage => state.errorMessage;
  int get currentPage => state.currentPage;
  int get pageSize => state.pageSize;
  int get totalPages => state.totalPages;
  String get searchKeyword => state.searchKeyword;
  ProductDetailModel? get selectedProduct => state.selectedProduct;

  Future<void> initialize() async {
    await fetchProducts(page: 1, limit: 20);
  }

  void setImageNull() {
    state = state.copyWith(imageUrl: '');
  }

  void clearDropdowns() {
    state = state.copyWith(
      brands: [],
      manufacturers: [],
      unitTypes: [],
      packageTypes: [],
      usageType: [],
      suppliers: [],
    );
  }

  void clearMetadata() {
    state = ProductState(
      loading: state.loading,
      currentPage: state.currentPage,
      totalPages: state.totalPages,
      products: state.products,
      errorMessage: state.errorMessage,
      pageSize: state.pageSize,
      searchKeyword: state.searchKeyword,
      selectedProduct: state.selectedProduct,
      imageUrl: state.imageUrl,
      brands: null,
      manufacturers: null,
      unitTypes: null,
      packageTypes: null,
      usageType: null,
      suppliers: null,
    );
  }

 Future<void> getData() async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(loading: true);
      final result = await Future.wait([
        _productRepository.getCatalog(),
       _productRepository.getClinicProducts(),
      ]);
      state = state.copyWith(
        loading: false,
        catalog: result[0] as List<CatalogItem>,
       clinicProducts : result[1] as List<ClinicProduct>,
      );
    });
  }

  Future<void> addInventoryItem({
    required int productId,
    required int quantity,
    required String originalPrice,
    required String discount,
    required DiscountType discountType,
    required String discountedPrice,
  }) async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(addProductLoading: true);
      final newProduct = await _productRepository.addInventoryItem(
        AddInventoryRequest(
          productId: productId,
          quantity: quantity,
          originalPrice: num.parse(originalPrice),
          discount: num.parse(discount),
          discountType: discountType,
          discountedPrice: num.parse(discountedPrice),
        ),
      );
      final clinicProducts = List.of(state.clinicProducts);
      clinicProducts.removeWhere(
        (p) => p.clinicProductId == newProduct.clinicProductId,
      );
      state = state.copyWith(
        loading: false,
        addProductLoading: false,
        clinicProducts: [...clinicProducts, newProduct],
        inventoryAdded: true,
      );
    });
  }


  

  Future<void> fetchProducts({
    String search = '',
    int page = 1,
    int limit = 20,
    String? selectedPurpose = '',
    ProductStatus status = ProductStatus.all,
    int? brandId,
  }) async {
    await runSafely(() async {
      state = state.copyWith(loading: true);
      try {
        final response = await _productRepository.getProducts(
          search: search,
          page: page,
          limit: limit,
          selectedPurpose: selectedPurpose,
          status: status,
          brandId: brandId,
        );
        state = state.copyWith(
          products: (response.data ?? [])
              .map((e) => e.toProductModel())
              .toList(),
          currentPage: response.page,
          pageSize: response.limit,
          totalPages: response.totalPages,
          searchKeyword: search,
          errorMessage: null,
        );
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchProductDetail(int productId) async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.getProductDetail(
          id: productId,
        );
        state = state.copyWith(
          selectedProduct: response.data,
          errorMessage: null,
        );
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> searchProducts(String keyword) async {
    await fetchProducts(search: keyword, page: 1, limit: state.pageSize);
  }

  Future<void> nextPage() async {
    if (state.currentPage < state.totalPages) {
      await fetchProducts(
        search: state.searchKeyword,
        page: state.currentPage + 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 1) {
      await fetchProducts(
        search: state.searchKeyword,
        page: state.currentPage - 1,
        limit: state.pageSize,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 1 && page <= state.totalPages) {
      await fetchProducts(
        search: state.searchKeyword,
        page: page,
        limit: state.pageSize,
      );
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts(
      search: state.searchKeyword,
      page: state.currentPage,
      limit: state.pageSize,
    );
  }

  final MediaService _mediaService = MediaService();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage({
    bool showLoading = true,
    bool showError = true,
  }) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    await runSafely(() async {
      final String? url = await _mediaService.uploadImage(
        'products/image',
        image,
      );

      if (url == null) {
        throw const UnknownException(message: 'Failed to upload image');
      }

      log('Product image uploaded: $url');

      state = state.copyWith(imageUrl: url);
    }, showLoading: showLoading);
  }
  // List<DropdownMenuItem<int>> getProductDropdownItems() {
  //   return state.products
  //       .map(
  //         (prod) =>
  //             DropdownMenuItem(value: prod.id ?? 0, child: Text(prod.name)),
  //       )
  //       .toList();
  // }

  // CRUD Actions backed by the actual API repository
  // Future<bool?> createProduct(ProductModel req) async {
  //   return await runSafely<bool?>(showLoading: true, () async {
  //     final createRequest = CreateProductRequest(
  //       image: req.image,
  //       name: req.name,
  //       brand: req.brand,
  //       manufacturer: req.manufacturer,
  //       globalSku: req.globalSku,
  //       barcode: req.barcode,
  //       usageType: req.productPurpose ?? req.usageType,
  //       category: req.category,
  //       selectedCategoryIds: req.selectedCategoryIds,
  //       status: req.status,
  //       description: req.description,
  //       unitType: req.unitType,
  //       boxQuantity: req.boxQuantity,
  //       itemQuantityPerBox: req.itemQuantityPerBox,
  //       packageType: req.packageType,
  //       billableUnit: req.billableUnit,
  //       billableQuantityPerItem: req.billableQuantityPerItem,
  //       totalBillableQuantity: req.totalBillableQuantity,
  //       enforceLotTracking: req.enforceLotTracking,
  //       clinicCost: req.clinicCost,
  //       retailPricePerUnit: req.retailPricePerUnit,
  //       supplier: req.supplier,
  //       lotNumber: req.lotNumber,
  //       expirationDate: req.expirationDate?.toIso8601String(),
  //     );
  //     await _productRepository.addProduct(req: createRequest);
  //     await refreshProducts();
  //     EasyLoading.showSuccess('Product created successfully');
  //     return true;
  //   });
  // }

  // Future<bool> updateProduct(ProductModel req) async {
  //   return await runSafely<bool>(showLoading: true, () async {
  //         final updateRequest = CreateProductRequest(
  //           image: req.image,
  //           name: req.name,
  //           brand: req.brand,
  //           manufacturer: req.manufacturer,
  //           globalSku: req.globalSku,
  //           barcode: req.barcode,
  //           usageType: req.productPurpose ?? req.usageType,
  //           category: req.category,
  //           selectedCategoryIds: req.selectedCategoryIds,
  //           status: req.status,
  //           description: req.description,
  //           unitType: req.unitType,
  //           boxQuantity: req.boxQuantity,
  //           itemQuantityPerBox: req.itemQuantityPerBox,
  //           packageType: req.packageType,
  //           billableUnit: req.billableUnit,
  //           billableQuantityPerItem: req.billableQuantityPerItem,
  //           totalBillableQuantity: req.totalBillableQuantity,
  //           enforceLotTracking: req.enforceLotTracking,
  //           clinicCost: req.clinicCost,
  //           retailPricePerUnit: req.retailPricePerUnit,
  //           supplier: req.supplier,
  //           lotNumber: req.lotNumber,
  //           expirationDate: req.expirationDate?.toIso8601String(),
  //         );
  //         await _productRepository.updateProduct(
  //           id: req.id!,
  //           req: updateRequest,
  //         );
  //         await refreshProducts();
  //         EasyLoading.showSuccess('Product updated successfully');
  //         return true;
  //       }) ??
  //       false;
  // }

  // Future<bool> deleteProduct(int id) async {
  //   return await runSafely<bool>(showLoading: true, () async {
  //         await _productRepository.deleteProduct(id: id);
  //         await refreshProducts();
  //         EasyLoading.showSuccess('Product deleted successfully');
  //         return true;
  //       }) ??
  //       false;
  // }

  // Future<bool> updateProductStatus(int productId, String status) async {
  //   return await runSafely<bool>(showLoading: true, () async {
  //         await _productRepository.updateProductStatus(
  //           productId: productId,
  //           status: status,
  //         );
  //         await refreshProducts();
  //         if (state.selectedProduct?.id == productId) {
  //           await fetchProductDetail(productId);
  //         }
  //         EasyLoading.showSuccess('Product status updated successfully');
  //         return true;
  //       }) ??
  //       false;
  // }

  Future<void> fetchBrand() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchBrand();
        state = state.copyWith(brands: response.data, errorMessage: null);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchManufacturer() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchManufacturer();
        state = state.copyWith(
          manufacturers: response.data,
          errorMessage: null,
        );
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchUnitTypes() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchUnitTypes();
        state = state.copyWith(unitTypes: response.data, errorMessage: null);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchPackageTypes() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchPackageTypes();
        state = state.copyWith(packageTypes: response.data, errorMessage: null);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchUsageType() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchUsageTypes();
        state = state.copyWith(usageType: response.data, errorMessage: null);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchSuppliers() async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.fetchSuppliers();
        state = state.copyWith(suppliers: response.data, errorMessage: null);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }
}
