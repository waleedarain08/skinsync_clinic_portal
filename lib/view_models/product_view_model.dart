import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../exceptions/app_exception.dart';
import '../models/product_model.dart';
import '../models/requests/add_inventory_request.dart';
import '../models/requests/add_product_request.dart';
import '../models/requests/lot_item_update_request.dart';
import '../models/requests/product_batch_request.dart';
import '../models/requests/product_lot_request.dart';
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
  final bool addProductLoading;
  final List<CatalogItem> catalog;
  final List<ClinicProduct> clinicProducts;
  final bool inventoryAdded;

  // Admin Paginated Products
  final List<AdminProduct> adminProducts;
  final int adminPage;
  final int adminTotalPages;
  final bool loadingAdminProducts;
  final bool loadingMoreAdminProducts;

  // Paginated Batch List per selected product
  final List<ProductBatchModel> selectedProductBatches;
  final int selectedProductBatchPage;
  final int selectedProductBatchTotalPages;
  final bool loadingSelectedProductBatches;

  // On-demand Batch Lots & Pagination maps
  final Map<int, List<LotModel>> batchLots;
  final Map<int, int> batchLotPages;
  final Map<int, int> batchLotTotalPages;
  final Map<int, bool> batchLotLoading;
  final Map<int, bool> batchLotLoadingMore;

  // Paginated Lot Items
  final List<LotItemModel> lotItems;
  final int lotItemPage;
  final int lotItemTotalPages;
  final bool loadingLotItems;
  final int? activeLotId;

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
    this.adminProducts = const [],
    this.adminPage = 1,
    this.adminTotalPages = 1,
    this.loadingAdminProducts = false,
    this.loadingMoreAdminProducts = false,
    this.selectedProductBatches = const [],
    this.selectedProductBatchPage = 1,
    this.selectedProductBatchTotalPages = 1,
    this.loadingSelectedProductBatches = false,
    this.batchLots = const {},
    this.batchLotPages = const {},
    this.batchLotTotalPages = const {},
    this.batchLotLoading = const {},
    this.batchLotLoadingMore = const {},
    this.lotItems = const [],
    this.lotItemPage = 1,
    this.lotItemTotalPages = 1,
    this.loadingLotItems = false,
    this.activeLotId,
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
    List<AdminProduct>? adminProducts,
    int? adminPage,
    int? adminTotalPages,
    bool? loadingAdminProducts,
    bool? loadingMoreAdminProducts,
    List<ProductBatchModel>? selectedProductBatches,
    int? selectedProductBatchPage,
    int? selectedProductBatchTotalPages,
    bool? loadingSelectedProductBatches,
    Map<int, List<LotModel>>? batchLots,
    Map<int, int>? batchLotPages,
    Map<int, int>? batchLotTotalPages,
    Map<int, bool>? batchLotLoading,
    Map<int, bool>? batchLotLoadingMore,
    List<LotItemModel>? lotItems,
    int? lotItemPage,
    int? lotItemTotalPages,
    bool? loadingLotItems,
    int? activeLotId,
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
      adminProducts: adminProducts ?? this.adminProducts,
      adminPage: adminPage ?? this.adminPage,
      adminTotalPages: adminTotalPages ?? this.adminTotalPages,
      loadingAdminProducts: loadingAdminProducts ?? this.loadingAdminProducts,
      loadingMoreAdminProducts:
          loadingMoreAdminProducts ?? this.loadingMoreAdminProducts,
      selectedProductBatches:
          selectedProductBatches ?? this.selectedProductBatches,
      selectedProductBatchPage:
          selectedProductBatchPage ?? this.selectedProductBatchPage,
      selectedProductBatchTotalPages:
          selectedProductBatchTotalPages ?? this.selectedProductBatchTotalPages,
      loadingSelectedProductBatches:
          loadingSelectedProductBatches ?? this.loadingSelectedProductBatches,
      batchLots: batchLots ?? this.batchLots,
      batchLotPages: batchLotPages ?? this.batchLotPages,
      batchLotTotalPages: batchLotTotalPages ?? this.batchLotTotalPages,
      batchLotLoading: batchLotLoading ?? this.batchLotLoading,
      batchLotLoadingMore: batchLotLoadingMore ?? this.batchLotLoadingMore,
      lotItems: lotItems ?? this.lotItems,
      lotItemPage: lotItemPage ?? this.lotItemPage,
      lotItemTotalPages: lotItemTotalPages ?? this.lotItemTotalPages,
      loadingLotItems: loadingLotItems ?? this.loadingLotItems,
      activeLotId: activeLotId ?? this.activeLotId,
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
      loadingAdminProducts: false,
      loadingMoreAdminProducts: false,
      loadingSelectedProductBatches: false,
      loadingLotItems: false,
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

  Future<bool> addBatch({
    required int productId,
    required String batchNumber,
    required String manufactureDate,
  }) async {
    final result = await runSafely(showLoading: true, () async {
      final request = ProductBatchRequest(
        productId: productId,
        batchNumber: batchNumber,
        manufactureDate: manufactureDate,
      );
      await _productRepository.addBatch(request: request);

      // Refresh batches
      await fetchProductBatches(productId: productId, page: 1);
      return true;
    });
    return result ?? false;
  }

  Future<bool> addLot({
    required int batchId,
    required String lotNumber,
    required String lotBarcode,
    required String expirationDate,
    required double clinicCost,
    required double retailPricePerUnit,
    required String supplier,
    required int quantityReceived,
  }) async {
    final result = await runSafely(showLoading: true, () async {
      final request = ProductLotRequest(
        batchId: batchId,
        lotNumber: lotNumber,
        lotBarcode: lotBarcode,
        expirationDate: expirationDate,
        clinicCost: clinicCost,
        retailPricePerUnit: retailPricePerUnit,
        supplier: supplier,
        quantityReceived: quantityReceived,
      );
      await _productRepository.addLot(request: request);

      // Refresh lots for this specific batch
      final currentPage = state.batchLotPages[batchId] ?? 1;
      await fetchLotsForBatch(batchId: batchId, page: currentPage);
      return true;
    });
    return result ?? false;
  }

  Future<bool> addProductToClinic({required AddProductRequest request}) async {
    final result = await runSafely(showLoading: true, () async {
      final response = await _productRepository.addProductToClinic(
        request: request,
      );
      if (response.success) {
        await fetchAdminProducts(page: 1, search: '');
      }
      return true;
    });
    return result ?? false;
  }

  Future<bool> updateLotItem({
    required int itemId,
    required String serialNumber,
    required String itemBarcode,
  }) async {
    final result = await runSafely(showLoading: true, () async {
      final request = LotItemUpdateRequest(
        itemId: itemId,
        serialNumber: serialNumber,
        itemBarcode: itemBarcode,
      );
      await _productRepository.updateLotItem(request: request);

      // Refresh lot items preserving current search and page
      if (state.activeLotId != null) {
        await fetchLotItems(
          lotId: state.activeLotId!,
          page: state.lotItemPage,
          search: state.searchKeyword,
        );
      }
      return true;
    });
    return result ?? false;
  }

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
        clinicProducts: result[1] as List<ClinicProduct>,
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

  // --- Admin Product List API Pagination ---

  Future<void> fetchAdminProducts({int page = 1, String search = ''}) async {
    state = state.copyWith(loadingAdminProducts: true);

    try {
      final response = await _productRepository.getAdminProductList(
        page: page,
        limit: 8,
        search: search,
      );

      state = state.copyWith(
        adminProducts: response.data ?? [],
        adminPage: response.page,
        adminTotalPages: response.totalPages,
        loadingAdminProducts: false,
      );
    } catch (e) {
      state = state.copyWith(
        loadingAdminProducts: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> goToAdminProductPage(int page, {String search = ''}) async {
    if (page >= 1 && page <= state.adminTotalPages) {
      await fetchAdminProducts(page: page, search: search);
    }
  }

  // --- Product Detail, Batches & Lots Pagination ---

  Future<void> fetchProductDetail(int productId) async {
    await runSafely(showLoading: true, () async {
      try {
        final response = await _productRepository.getProductDetail(
          id: productId,
        );
        state = state.copyWith(
          selectedProduct: response.data,
          errorMessage: null,
          batchLots: {},
          batchLotPages: {},
          batchLotTotalPages: {},
          batchLotLoading: {},
          batchLotLoadingMore: {},
        );

        // Directly trigger fetching Page 1 of Batches as soon as Product Detail API responds
        await fetchProductBatches(productId: productId, page: 1);
      } catch (e) {
        state = state.copyWith(errorMessage: e.toString());
        rethrow;
      }
    });
  }

  Future<void> fetchProductBatches({
    required int productId,
    int page = 1,
  }) async {
    state = state.copyWith(loadingSelectedProductBatches: true);
    try {
      final response = await _productRepository.getProductBatches(
        productId: productId,
        page: page,
        limit: 2, // Load 2 batches per page to demonstrate footer pagination
      );
      state = state.copyWith(
        selectedProductBatches: response.data ?? [],
        selectedProductBatchPage: response.page,
        selectedProductBatchTotalPages: response.totalPages,
        loadingSelectedProductBatches: false,
      );
    } catch (e) {
      state = state.copyWith(
        loadingSelectedProductBatches: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> goToBatchPage(int page) async {
    final product = state.selectedProduct;
    if (product == null || product.id == null) return;
    if (page >= 1 && page <= state.selectedProductBatchTotalPages) {
      await fetchProductBatches(productId: product.id!, page: page);
    }
  }

  Future<void> nextBatchPage() async {
    if (state.selectedProductBatchPage < state.selectedProductBatchTotalPages) {
      await goToBatchPage(state.selectedProductBatchPage + 1);
    }
  }

  Future<void> previousBatchPage() async {
    if (state.selectedProductBatchPage > 1) {
      await goToBatchPage(state.selectedProductBatchPage - 1);
    }
  }

  Future<void> fetchLotsForBatch({required int batchId, int page = 1}) async {
    // Show a loading indicator inside the expanded batch area
    final updatedLoading = Map<int, bool>.from(state.batchLotLoading)
      ..[batchId] = true;
    state = state.copyWith(batchLotLoading: updatedLoading);

    try {
      final response = await _productRepository.getBatchLots(
        batchId: batchId,
        page: page,
        limit: 2, // Low limit to demonstrate clean pagination!
      );

      final updatedLots = Map<int, List<LotModel>>.from(state.batchLots)
        ..[batchId] = response.data ?? [];
      final updatedPages = Map<int, int>.from(state.batchLotPages)
        ..[batchId] = response.page;
      final updatedTotalPages = Map<int, int>.from(state.batchLotTotalPages)
        ..[batchId] = response.totalPages;
      final updatedLoadingDone = Map<int, bool>.from(state.batchLotLoading)
        ..[batchId] = false;

      state = state.copyWith(
        batchLots: updatedLots,
        batchLotPages: updatedPages,
        batchLotTotalPages: updatedTotalPages,
        batchLotLoading: updatedLoadingDone,
      );
    } catch (e) {
      final updatedLoadingDone = Map<int, bool>.from(state.batchLotLoading)
        ..[batchId] = false;
      state = state.copyWith(
        batchLotLoading: updatedLoadingDone,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> goToLotPage(int batchId, int page) async {
    final totalPages = state.batchLotTotalPages[batchId] ?? 1;
    if (page >= 1 && page <= totalPages) {
      await fetchLotsForBatch(batchId: batchId, page: page);
    }
  }

  Future<void> nextLotPage(int batchId) async {
    final currentPage = state.batchLotPages[batchId] ?? 1;
    final totalPages = state.batchLotTotalPages[batchId] ?? 1;
    if (currentPage < totalPages) {
      await goToLotPage(batchId, currentPage + 1);
    }
  }

  Future<void> previousLotPage(int batchId) async {
    final currentPage = state.batchLotPages[batchId] ?? 1;
    if (currentPage > 1) {
      await goToLotPage(batchId, currentPage - 1);
    }
  }

  // --- Paginated Lot Items API Flow ---

  Future<bool> fetchLotItems({
    required int lotId,
    int page = 1,
    String search = '',
  }) async {
    state = state.copyWith(loadingLotItems: true, activeLotId: lotId);
    try {
      final response = await _productRepository.getLotItems(
        lotId: lotId,
        page: page,
        limit: 12, // Responsive grid loads 12 items per page
        search: search,
      );
      state = state.copyWith(
        lotItems: response.data ?? [],
        lotItemPage: response.page,
        lotItemTotalPages: response.totalPages,
        loadingLotItems: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        loadingLotItems: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> goToLotItemPage(int page) async {
    if (state.activeLotId == null) return;
    if (page >= 1 && page <= state.lotItemTotalPages) {
      await fetchLotItems(lotId: state.activeLotId!, page: page);
    }
  }

  Future<void> nextLotItemPage() async {
    if (state.lotItemPage < state.lotItemTotalPages) {
      await goToLotItemPage(state.lotItemPage + 1);
    }
  }

  Future<void> previousLotItemPage() async {
    if (state.lotItemPage > 1) {
      await goToLotItemPage(state.lotItemPage - 1);
    }
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
