import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../utils/clinic_dummy_data.dart';
import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/build_textfield.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../models/product_model.dart';

class ClinicAddProductScreen extends ConsumerStatefulWidget {
  const ClinicAddProductScreen({super.key});

  static const String routeName = '/clinic-add-product';

  @override
  ConsumerState<ClinicAddProductScreen> createState() => _ClinicAddProductScreenState();
}

class _ClinicAddProductScreenState extends ConsumerState<ClinicAddProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = List.from(ClinicDummyMasterProducts.masterCatalog);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredProducts = ClinicDummyMasterProducts.masterCatalog.where((product) {
        final nameMatch = product.name.toLowerCase().contains(query.toLowerCase());
        final brandMatch = (product.brand ?? '').toLowerCase().contains(query.toLowerCase());
        final skuMatch = (product.globalSku ?? '').toLowerCase().contains(query.toLowerCase());
        return nameMatch || brandMatch || skuMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.screenWidth > 1200;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Add Inventory Product', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.w(isDesktop ? 750 : 900),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Panel Card matching standard Treatment Detail look
              Padding(
                padding: context.appEdgeInsets(horizontal: 12, vertical: 16),
                child: BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 16),
                  backgroundColor: CustomColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CustomColors.purple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: CustomColors.purple,
                            ),
                          ),
                          context.horizontalSpace(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Search Master Catalog',
                                  style: context.fonts.black16w600,
                                ),
                                Text(
                                  'Find platform-wide products to configure and add to your clinic inventory.',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search master products by name, brand, global SKU...',
                          hintStyle: context.fonts.grey14w400,
                          prefixIcon: const Icon(Icons.search, color: CustomColors.grey),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: CustomColors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: context.appBorderRadius(all: 12),
                            borderSide: const BorderSide(color: CustomColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: context.appBorderRadius(all: 12),
                            borderSide: const BorderSide(color: CustomColors.purple, width: 2),
                          ),
                          filled: true,
                          fillColor: CustomColors.whiteGrey,
                          contentPadding: context.appEdgeInsets(horizontal: 16, vertical: 12),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ],
                  ),
                ),
              ),

              // Product template list
              Expanded(
                child: _filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          'No matching master products found.',
                          style: context.fonts.grey14w400,
                        ),
                      )
                    : ListView.builder(
                        padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];

                          return BorderdContainerWidget(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: context.appEdgeInsets(all: 16),
                            borderRadius: 12,
                            child: Row(
                              children: [
                                // Leading circular icon
                                Container(
                                  width: context.w(48),
                                  height: context.w(48),
                                  decoration: BoxDecoration(
                                    color: CustomColors.purple.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.inventory_2_outlined,
                                    color: CustomColors.purple,
                                  ),
                                ),
                                context.horizontalSpace(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: context.fonts.black16w600,
                                      ),
                                      context.verticalSpace(4),
                                      Row(
                                        children: [
                                          Text(
                                            product.brand ?? 'N/A',
                                            style: context.fonts.purple12w700,
                                          ),
                                          context.horizontalSpace(12),
                                          Container(
                                            width: 4,
                                            height: 4,
                                            decoration: const BoxDecoration(
                                              color: CustomColors.grey,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          context.horizontalSpace(12),
                                          Text(
                                            'SKU: ${product.globalSku ?? "N/A"}',
                                            style: context.fonts.grey12w400,
                                          ),
                                        ],
                                      ),
                                      context.verticalSpace(6),
                                      Text(
                                        product.description,
                                        style: context.fonts.grey12w400,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                context.horizontalSpace(16),
                                CustomPrimaryButton(
                                  onTap: () {
                                    _showConfigureProductDialog(context, product);
                                  },
                                  label: 'Select',
                                  width: context.w(90),
                                  height: context.h(40),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfigureProductDialog(BuildContext context, ProductModel product) {
    final formKey = GlobalKey<FormState>();
    final quantityController = TextEditingController();
    final retailPriceController = TextEditingController();
    final barcodeController = TextEditingController();
    final supplierController = TextEditingController();
    final lotController = TextEditingController();
    final expiryController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: context.w(600),
            padding: context.appEdgeInsets(all: 24),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dialog Header with Basic Admin Config Details at Top
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CustomColors.purple.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.app_registration_rounded,
                            color: CustomColors.purple,
                            size: 28,
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: context.fonts.black18w600,
                              ),
                              context.verticalSpace(4),
                              Row(
                                children: [
                                  Text(
                                    'Brand: ${product.brand ?? "N/A"}',
                                    style: context.fonts.purple12w700,
                                  ),
                                  context.horizontalSpace(12),
                                  Text(
                                    '• SKU: ${product.globalSku ?? "N/A"}',
                                    style: context.fonts.grey12w400,
                                  ),
                                ],
                              ),
                              context.verticalSpace(4),
                              Text(
                                'Packaging: ${product.packageType ?? "Standard"} (${product.unitsPerPackage ?? 1} Units per package)',
                                style: context.fonts.grey12w400.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(12),
                    Text(
                      product.description,
                      style: context.fonts.grey12w400,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: CustomColors.border, height: 1),
                    ),

                    // Title for clinic inputs
                    Text(
                      'Configure Clinic Inventory Fields:',
                      style: context.fonts.black14w600,
                    ),
                    context.verticalSpace(16),

                    // Inputs Grid
                    Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                            label: 'Quantity *',
                            controller: quantityController,
                            hintText: 'e.g. 50',
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Required';
                              if (int.tryParse(val.trim()) == null) return 'Must be an integer';
                              return null;
                            },
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: BuildTextField(
                            label: 'Retail Price (AED) *',
                            controller: retailPriceController,
                            hintText: 'e.g. 250.00',
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Required';
                              if (double.tryParse(val.trim()) == null) return 'Must be a number';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(16),

                    Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                            label: 'Barcode',
                            controller: barcodeController,
                            hintText: 'Scan or enter barcode...',
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: BuildTextField(
                            label: 'Supplier *',
                            controller: supplierController,
                            hintText: 'e.g. Medica Group',
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(16),

                    Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                            label: 'Lot Number *',
                            controller: lotController,
                            hintText: 'e.g. LOT-2026-X8',
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(const Duration(days: 365)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 3650)),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: CustomColors.purple,
                                        onPrimary: Colors.white,
                                        onSurface: CustomColors.black,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                expiryController.text = DateFormat('yyyy-MM-dd').format(picked);
                              }
                            },
                            child: IgnorePointer(
                              child: BuildTextField(
                                label: 'Expiration Date *',
                                controller: expiryController,
                                hintText: 'YYYY-MM-DD',
                                suffixIcon: const Icon(Icons.calendar_today, color: CustomColors.purple),
                                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(32),

                    // Dialog Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomOutlinedButton(
                          onTap: () {
                            Navigator.pop(dialogContext);
                          },
                          label: 'Cancel',
                          width: context.w(100),
                        ),
                        context.horizontalSpace(12),
                        CustomPrimaryButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(dialogContext);
                              _showAddSuccessDialog(product, quantityController.text);
                            }
                          },
                          label: 'Add to Inventory',
                          width: context.w(180),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddSuccessDialog(ProductModel product, String qty) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: context.appEdgeInsets(all: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 16),
                  decoration: const BoxDecoration(
                    color: CustomColors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 40, color: Colors.white),
                ),
                context.verticalSpace(24),
                Text(
                  "Product Added!",
                  style: context.fonts.black20w600,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(12),
                Text(
                  "Successfully added $qty units of ${product.name} (${product.brand}) into your clinic inventory.",
                  style: context.fonts.grey14w400,
                  textAlign: TextAlign.center,
                ),
                context.verticalSpace(24),
                SizedBox(
                  width: double.infinity,
                  child: CustomPrimaryButton(
                    onTap: () {
                      Navigator.of(ctx).pop(); // Dismiss success dialog
                      context.pop(); // Navigate back to main Inventory catalog
                    },
                    label: "Return to Inventory",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}