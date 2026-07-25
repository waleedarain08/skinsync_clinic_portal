import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../utils/theme.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_outlined_button.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/dialog_box/standard_dialog.dart';
import '../widgets/number_paginator.dart';
import '../models/responses/admin_product_list_response.dart';
import '../view_models/product_view_model.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  static const String routeName = '/clinic-add-product';

  @override
  ConsumerState<AddProductScreen> createState() => _ClinicAddProductScreenState();
}

class _ClinicAddProductScreenState extends ConsumerState<AddProductScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<AdminProduct> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productViewModelProvider.notifier).fetchAdminProducts(page: 1, search: '');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    ref.read(productViewModelProvider.notifier).fetchAdminProducts(page: 1, search: query);
  }

  void _toggleSelection(AdminProduct product) {
    setState(() {
      final index = _selectedProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _selectedProducts.removeAt(index);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  Widget _buildProductCard(BuildContext context, AdminProduct product) {
    final isSelected = _selectedProducts.any((p) => p.id == product.id);

    return InkWell(
      onTap: () => _toggleSelection(product),
      borderRadius: BorderRadius.circular(12),
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 12),
        backgroundColor: Colors.white,
        borderColor: isSelected ? CustomColors.purple : CustomColors.border,
        borderWidth: isSelected ? 1.5 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: context.w(36),
                  height: context.w(36),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColors.green.withValues(alpha: 0.1)
                        : CustomColors.purple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected
                        ? Icons.check_circle_outline
                        : Icons.inventory_2_outlined,
                    color: isSelected ? CustomColors.green : CustomColors.purple,
                    size: 18,
                  ),
                ),
                context.horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: context.fonts.black13w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.brand ?? 'N/A',
                        style: context.fonts.purple11w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            context.verticalSpace(4),
            _buildCompactDetail(context, 'SKU', product.globalSku ?? 'N/A'),
            _buildCompactDetail(context, 'Category', product.category ?? 'N/A'),
            _buildCompactDetail(
              context,
              'Usage',
              (product.usageType ?? 'N/A').toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDetail(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.fonts.grey10w400),
          Text(value, style: context.fonts.black12w600),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context, int currentPage, int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: NumberPaginator(
          totalPages: totalPages,
          currentPage: currentPage - 1,
          onPageChanged: (pageIndex) {
            ref.read(productViewModelProvider.notifier).goToAdminProductPage(
              pageIndex + 1,
              search: _searchQuery,
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewModelProvider);
    
    int gridColumns = 1;
    if (context.screenWidth > 1200) {
      gridColumns = 4;
    } else if (context.screenWidth > 900) {
      gridColumns = 3;
    } else if (context.screenWidth > 600) {
      gridColumns = 2;
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text('Add Inventory Product', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Panel & Selection Display
          Padding(
            padding: context.appEdgeInsets(horizontal: 24, vertical: 16),
            child: BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 16),
              backgroundColor: CustomColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CustomColors.purple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search_rounded, color: CustomColors.purple),
                          ),
                          context.horizontalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Search Master Catalog', style: context.fonts.black16w600),
                              Text('Select platform products to add to inventory.', style: context.fonts.grey12w400),
                            ],
                          ),
                        ],
                      ),
                      if (_selectedProducts.isNotEmpty)
                        CustomPrimaryButton(
                          onTap: _showConfirmationDialog,
                          label: 'Add ${_selectedProducts.length} Products',
                          width: context.w(180),
                          height: context.h(40),
                          icon: Icons.add_to_photos_outlined,
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
                  if (_selectedProducts.isNotEmpty) ...[
                    context.verticalSpace(16),
                    const Divider(color: CustomColors.border, height: 1),
                    context.verticalSpace(12),
                    Row(
                      children: [
                        Text('Selected Items (${_selectedProducts.length}):', style: context.fonts.black12w600),
                        const Spacer(),
                        TextButton(
                          onPressed: () => setState(() => _selectedProducts.clear()),
                          child: Text('Clear All', style: context.fonts.purple12w700.copyWith(color: CustomColors.red)),
                        ),
                      ],
                    ),
                    context.verticalSpace(8),
                    Container(
                      constraints: BoxConstraints(maxHeight: context.h(100)),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedProducts.map((product) {
                            return Chip(
                              backgroundColor: CustomColors.purple.withValues(alpha: 0.1),
                              side: BorderSide(color: CustomColors.purple.withValues(alpha: 0.2)),
                              label: Text(product.name, style: context.fonts.purple11w600),
                              onDeleted: () => _toggleSelection(product),
                              deleteIcon: const Icon(Icons.close, size: 14, color: CustomColors.purple),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Grid of Products
          Expanded(
            child: state.loadingAdminProducts
                ? const Center(child: CircularProgressIndicator(color: CustomColors.purple))
                : state.adminProducts.isEmpty
                    ? Center(child: Text('No matching master products found.', style: context.fonts.grey14w400))
                    : Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              padding: context.appEdgeInsets(horizontal: 24, vertical: 8),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridColumns,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: context.screenWidth > 600 ? 1.6 : 1.1,
                              ),
                              itemCount: state.adminProducts.length,
                              itemBuilder: (context, index) => _buildProductCard(context, state.adminProducts[index]),
                            ),
                          ),
                          if (state.adminTotalPages > 1)
                            _buildPaginationFooter(context, state.adminPage, state.adminTotalPages),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return StandardDialog(
          title: "Confirm Selection",
          showCloseButton: false,
          width: 450.w,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                "You have selected ${_selectedProducts.length} products. Do you want to add them to your clinic inventory?",
                style: context.fonts.grey14w400,
                textAlign: TextAlign.center,
              ),
              context.verticalSpace(12),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: context.h(150)),
                child: Container(
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: _selectedProducts.length,
                    separatorBuilder: (context, index) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final p = _selectedProducts[index];
                      return Row(
                        children: [
                          const Icon(Icons.check_circle, color: CustomColors.green, size: 16),
                          context.horizontalSpace(8),
                          Expanded(
                            child: Text(
                              p.name,
                              style: context.fonts.black12w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            CustomOutlinedButton(
              onTap: () => Navigator.of(ctx).pop(),
              label: "Cancel",
              width: context.w(100),
            ),
            CustomPrimaryButton(
              onTap: () {
                Navigator.of(ctx).pop();
                context.pop();
              },
              label: "Add Now",
              width: context.w(140),
            ),
          ],
        );
      },
    );
  }
}
