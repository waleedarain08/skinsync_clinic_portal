import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/responses/catalog_response.dart';
import '../../utils/enums.dart';
import '../../utils/validators.dart';
import '../../view_models/product_view_model.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import '../build_textfield.dart';
import '../custom_dropdown_widget.dart';
import 'standard_dialog.dart';

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

  int _quantity = 1;
  DiscountType _discountType = DiscountType.per;
  final _formKey = GlobalKey<FormState>();

  void _onAddToInventory() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      EasyLoading.showError('Please select a product!');
      return;
    }
    ref
        .read(productViewModelProvider.notifier)
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

  void _listener(ProductState? prev, ProductState next) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productViewModelProvider, _listener);
    final loading = ref.watch(
      productViewModelProvider.select((s) => s.addProductLoading),
    );

    return StandardDialog(
      title: "Add Inventory Item",
      width: 520.w,
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Product", style: context.fonts.black14w600),
              context.verticalSpace(8),
              Consumer(
                builder: (_, ref, _) {
                  final catalog = ref.read(
                    productViewModelProvider.select((s) => s.catalog),
                  );
                  return CustomDropdown<CatalogItem>(
                    builder: (catalogItem) => Text(
                      catalogItem.name ?? 'N/A',
                      style: context.fonts.black14w500,
                    ),
                    hint: 'Select Product',
                    value: _selectedProduct,
                    items: catalog,
                    onChanged: (newCatalog) =>
                        setState(() => _selectedProduct = newCatalog),
                  );
                },
              ),
              context.verticalSpace(20),
              Text("Quantity", style: context.fonts.black14w600),
              context.verticalSpace(8),
              Row(
                children: [
                  _buildQtyBtn(Icons.remove, _decrement),
                  context.horizontalSpace(12),
                  Expanded(
                    child: TextFormField(
                      style: context.fonts.black14w400,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Quantity is required!';
                        final quantity = int.tryParse(value);
                        if (quantity == null || quantity <= 0)
                          return 'Invalid quantity!';
                        return null;
                      },
                      controller: _quantityController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => _quantity = int.tryParse(val) ?? 1,
                      decoration: AppDecorations.input(context, hint: "0"),
                    ),
                  ),
                  context.horizontalSpace(12),
                  _buildQtyBtn(Icons.add, _increment),
                ],
              ),
              context.verticalSpace(20),
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
              context.verticalSpace(20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
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
                  context.horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Type", style: context.fonts.black14w600),
                        context.verticalSpace(8),
                        CustomDropdown<DiscountType>(
                          builder: (type) => Text(
                            type == DiscountType.per ? 'Percentage' : 'Flat',
                            style: context.fonts.black14w500,
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
              context.verticalSpace(20),
              BuildTextField(
                label: 'Discounted Price',
                validator: (value) {
                  final discountValue = num.tryParse(_discountController.text);
                  if (discountValue == null || discountValue <= 0) return null;
                  return Validators.empty(value);
                },
                controller: _discountedPriceController,
                hintText: '0.00',
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        CustomPrimaryButton(
          label: loading ? "Adding..." : "Add to Inventory",
          onTap: loading ? null : _onAddToInventory,
          width: 180.w,
        ),
      ],
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 8),
      child: Container(
        height: 48.h,
        width: 48.h,
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.border),
          borderRadius: context.appBorderRadius(all: 8),
        ),
        child: Icon(icon, color: CustomColors.black, size: 20.sp),
      ),
    );
  }
}
