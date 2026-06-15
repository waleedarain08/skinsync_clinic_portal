import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/responses/catalog_response.dart';
import '../../utils/enums.dart';
import '../../utils/validators.dart';
import '../../view_models/inventory_view_model.dart';
import '../custom_primary_button.dart';

import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import '../custom_dropdown_widget.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  const AddProductDialog({super.key});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  CatalogItem? _selectedProduct;
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController _discountedPriceController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  int _quantity = 1;
  DiscountType _discountType = DiscountType.per;
  final _formKey = GlobalKey<FormState>();

  void _onAddToInventory() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedProduct == null) {
      EasyLoading.showError('Please select a product!');
      return;
    }
    ref
        .read(inventoryProvider.notifier)
        .addInventoryItem(
          productId: _selectedProduct!.id!,
          quantity: _quantity,
          originalPrice: _priceController.text,
          discount: _discountController.text,
          discountType: _discountType,
          discountedPrice: _discountedPriceController.text,
        );
  }

  void _increment() {
    setState(() {
      _quantity++;
      _quantityController.text = _quantity.toString();
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _quantityController.text = _quantity.toString();
      });
    }
  }

  void _calculateDiscountedPrice() {
    double originalPrice = double.tryParse(_priceController.text) ?? 0.0;
    double discount = double.tryParse(_discountController.text) ?? 0.0;
    double discountedPrice = originalPrice;

    if (_discountType == DiscountType.per) {
      discountedPrice = originalPrice - (originalPrice * discount / 100);
    } else {
      discountedPrice = originalPrice - discount;
    }

    if (discountedPrice < 0) discountedPrice = 0;

    _discountedPriceController.text = discountedPrice.toStringAsFixed(2);
  }

  void _listener(InventoryState? prev, InventoryState next) {
    if (next.inventoryAdded) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _discountedPriceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(inventoryProvider, _listener);
    final bool isLandscape = context.isLandscape;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? context.w(100) : context.w(20),
        vertical: context.h(40),
      ),
      child: Container(
        width: isLandscape ? context.w(500) : double.infinity,
        padding: EdgeInsets.all(context.r(24)),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Add Inventory Item", style: CustomFonts.black20w600),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(context.r(4)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: Icon(
                          Icons.close,
                          size: context.r(20),
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(24)),

                Text("Product", style: CustomFonts.black14w500),
                SizedBox(height: context.h(10)),
                Consumer(
                  builder: (_, ref, _) {
                    final catalog = ref.read(
                      inventoryProvider.select((s) => s.catalog),
                    );
                    return CustomDropdown<CatalogItem>(
                      builder: (catalogItem) => Text(
                        catalogItem.name ?? 'N/A',
                        style: CustomFonts.black14w500,
                      ),
                      hint: 'Select Product',
                      value: _selectedProduct,
                      items: catalog,
                      onChanged: (newCatalog) {
                        setState(() {
                          _selectedProduct = newCatalog;
                        });
                      },
                    );
                  },
                ),
                SizedBox(height: context.h(20)),
                Text("Quantity", style: CustomFonts.black14w500),
                SizedBox(height: context.h(10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildQtyBtn(Icons.remove, _decrement),
                    SizedBox(width: context.w(15)),
                    Expanded(
                      child: TextFormField(
                        style: CustomFonts.black14w400,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Quantity is required!';
                          }
                          final quantity = int.tryParse(value);
                          if (quantity == null || quantity <= 0) {
                            return 'Invalid quantity!';
                          }
                          return null;
                        },
                        controller: _quantityController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          _quantity = int.tryParse(val) ?? 1;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: context.h(14),
                          ),
                          filled: true,
                          fillColor: CustomColors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(8)),
                            borderSide: const BorderSide(color: CustomColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(8)),
                            borderSide: const BorderSide(color: CustomColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(context.r(8)),
                            borderSide: const BorderSide(color: CustomColors.purple),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(15)),
                    _buildQtyBtn(Icons.add, _increment),
                  ],
                ),

                SizedBox(height: context.h(20)),
                BuildTextField(
                  label: 'Original Price',
                  controller: _priceController,
                  validator: Validators.empty,
                  hintText: 'Enter original price',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => _calculateDiscountedPrice(),
                ),

                SizedBox(height: context.h(20)),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: BuildTextField(
                        label: 'Discount',
                        controller: _discountController,
                        hintText: 'Enter discount',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) => _calculateDiscountedPrice(),
                      ),
                    ),
                    SizedBox(width: context.w(15)),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type", style: CustomFonts.black14w500),
                          SizedBox(height: context.h(10)),
                          CustomDropdown<DiscountType>(
                            builder: (type) => Text(
                              switch (type) {
                                DiscountType.per => 'Percentage',
                                DiscountType.flat => 'Flat',
                              },
                              style: CustomFonts.black14w500,
                            ),
                            hint: 'Select Type',
                            value: _discountType,
                            items: DiscountType.values,
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _discountType = val;
                                  _calculateDiscountedPrice();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.h(20)),
                BuildTextField(
                  label: 'Discounted Price',
                  validator: (value) {
                    final discountValue = num.tryParse(
                      _discountController.text,
                    );
                    if (discountValue == null || discountValue <= 0) {
                      return null;
                    }
                    return Validators.empty(value);
                  },
                  controller: _discountedPriceController,
                  hintText: '0.00',
                  readOnly: true,
                ),

                SizedBox(height: context.h(32)),
                Consumer(
                  builder: (_, ref, _) {
                    final loading = ref.watch(
                      inventoryProvider.select((s) => s.addProductLoading),
                    );
                    return CustomPrimaryButton(
                      onTap: _onAddToInventory,
                      label: "Add to Inventory",
                      isLoading: loading,
                      width: double.infinity,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.r(8)),
      child: Container(
        height: context.h(48),
        width: context.h(48),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.border),
          borderRadius: BorderRadius.circular(context.r(8)),
          color: CustomColors.white,
        ),
        child: Icon(icon, size: context.r(20), color: CustomColors.black),
      ),
    );
  }
}
