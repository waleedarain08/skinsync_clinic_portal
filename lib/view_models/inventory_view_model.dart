import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_clinic_portal/models/requests/add_inventory_request.dart';
import 'package:skinsync_clinic_portal/models/responses/clinic_products_response.dart';

import '../models/responses/catalog_response.dart';
import '../services/inventory_service.dart';
import '../services/locator.dart';
import '../utils/enums.dart';
import 'base_view_model.dart';

final inventoryProvider =
    NotifierProvider.autoDispose<InventoryViewModel, InventoryState>(
  () => InventoryViewModel(),
);

class InventoryViewModel extends BaseViewModel<InventoryState> {
  InventoryViewModel();

  @override
  InventoryState build() {
    init();
    ref.onDispose(dispose);
    return const InventoryState();
  }

  Future<void> getData() async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(loading: true);
      final result = await Future.wait([
        locator<InventoryService>().getCatalog(),
        locator<InventoryService>().getClinicProducts(),
      ]);
      state = state.copyWith(
        loading: false,
        catalog: result[0] as List<CatalogItem>,
        products: result[1] as List<ClinicProduct>,
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
      final newProduct = await locator<InventoryService>().addInventoryItem(
        AddInventoryRequest(
          productId: productId,
          quantity: quantity,
          originalPrice: num.parse(originalPrice),
          discount: num.parse(discount),
          discountType: discountType,
          discountedPrice: num.parse(discountedPrice),
        ),
      );
      final products = List.of(state.products);
      products.removeWhere(
        (p) => p.clinicProductId == newProduct.clinicProductId,
      );
      state = state.copyWith(
        loading: false,
        addProductLoading: false,
        products: [...products, newProduct],
        inventoryAdded: true,
      );
    });
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
}

class InventoryState {
  final bool loading, addProductLoading;
  final List<CatalogItem> catalog;
  final List<ClinicProduct> products;
  final bool inventoryAdded;

  const InventoryState({
    this.loading = false,
    this.addProductLoading = false,
    this.catalog = const [],
    this.products = const [],
    this.inventoryAdded = false,
  });

  InventoryState copyWith({
    bool? loading,
    bool? addProductLoading,
    List<CatalogItem>? catalog,
    List<ClinicProduct>? products,
    bool? inventoryAdded,
  }) {
    return InventoryState(
      loading: loading ?? this.loading,
      addProductLoading: addProductLoading ?? this.addProductLoading,
      catalog: catalog ?? this.catalog,
      products: products ?? this.products,
      inventoryAdded: inventoryAdded ?? false,
    );
  }
}
