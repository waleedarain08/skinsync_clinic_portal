import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/dialog_box/standard_dialog.dart';
import '../models/responses/admin_product_list_response.dart';
import '../view_models/product_view_model.dart';

class ClinicAddProductScreen extends ConsumerStatefulWidget {
  const ClinicAddProductScreen({super.key});

  static const String routeName = '/clinic-add-product';

  @override
  ConsumerState<ClinicAddProductScreen> createState() => _ClinicAddProductScreenState();
}

class _ClinicAddProductScreenState extends ConsumerState<ClinicAddProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewModelProvider.notifier).fetchAdminProducts(isRefresh: true, search: '');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(productViewModelProvider.notifier).fetchMoreAdminProducts(search: _searchQuery);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    ref.read(productViewModelProvider.notifier).fetchAdminProducts(isRefresh: true, search: query);
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w(180),
            child: Text(
              label,
              style: context.fonts.grey12w400,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              style: context.fonts.black14w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = context.screenWidth > 1200;
    final state = ref.watch(productViewModelProvider);

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
                                  'Find platform-wide products to add directly to your clinic inventory.',
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
                child: state.loadingAdminProducts
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.purple,
                        ),
                      )
                    : state.adminProducts.isEmpty
                        ? Center(
                            child: Text(
                              'No matching master products found.',
                              style: context.fonts.grey14w400,
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: context.appEdgeInsets(horizontal: 12, vertical: 8),
                            itemCount: state.adminProducts.length + (state.loadingMoreAdminProducts ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.adminProducts.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: CustomColors.purple,
                                    ),
                                  ),
                                );
                              }

                              final product = state.adminProducts[index];

                              return BorderdContainerWidget(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: context.appEdgeInsets(all: 0),
                                borderRadius: 12,
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: context.appEdgeInsets(all: 16),
                                    childrenPadding: context.appEdgeInsets(horizontal: 16, bottom: 16),
                                    leading: Container(
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
                                    title: Column(
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
                                              product.manufacturer ?? 'N/A',
                                              style: context.fonts.grey12w400,
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
                                      ],
                                    ),
                                    children: [
                                      const Divider(color: CustomColors.border, height: 24),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildDetailRow(context, 'Usage Type', (product.usageType ?? '').toUpperCase()),
                                          _buildDetailRow(context, 'Category', product.category ?? ''),
                                          _buildDetailRow(context, 'Status', (product.status ?? '').toUpperCase()),
                                          _buildDetailRow(context, 'Description', product.description),
                                          _buildDetailRow(context, 'Unit Type', (product.unitType ?? '').toUpperCase()),
                                          _buildDetailRow(context, 'Box Quantity', product.boxQuantity?.toString() ?? '0'),
                                          _buildDetailRow(context, 'Item Qty Per Box', product.itemQuantityPerBox?.toString() ?? '0'),
                                          _buildDetailRow(context, 'Package Type', (product.packageType ?? '').toUpperCase()),
                                          _buildDetailRow(context, 'Billable Unit', product.billableUnit ?? ''),
                                          _buildDetailRow(context, 'Billable Qty Per Item', product.billableQuantityPerItem?.toString() ?? '0'),
                                          _buildDetailRow(context, 'Total Billable Qty', product.totalBillableQuantity?.toString() ?? '0'),
                                          _buildDetailRow(context, 'Enforce Lot Tracking', product.enforceLotTracking ? 'YES' : 'NO'),
                                        ],
                                      ),
                                      const Divider(color: CustomColors.border, height: 24),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          CustomPrimaryButton(
                                            onTap: () {
                                              _showAddSuccessDialog(product);
                                            },
                                            label: 'Select',
                                            width: context.w(120),
                                            height: context.h(40),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

  void _showAddSuccessDialog(AdminProduct product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StandardDialog(
          title: "Product Added!",
          showCloseButton: false,
          width: 450.w,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: .center,
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
                "Successfully added ${product.name} (${product.brand}) into your clinic inventory.",
                style: context.fonts.grey14w400,
                textAlign: TextAlign.center,
              ),

            ],
          ),
          actions: [
            Expanded(
              child: CustomPrimaryButton(
                onTap: () {
                  Navigator.of(ctx).pop(); // Dismiss success dialog
                  context.pop(); // Navigate back to main Inventory catalog
                },
                label: "Return to Inventory",
              ),
            ),
          ],
        );
      },
    );
  }
}