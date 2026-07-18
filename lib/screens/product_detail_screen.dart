import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/product_batch_list_response.dart';
import '../models/responses/product_lots_response.dart';
import '../models/responses/product_detail_response.dart';
import 'lot_items_screen.dart';
import '../utils/theme.dart';
import '../view_models/product_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/dialog_box/add_batch_dialog.dart';
import '../widgets/dialog_box/add_lot_dialog.dart';
import '../widgets/gradient_scaffold.dart';

class ProductDetailScreen extends ConsumerWidget {
  static const String routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  String _formatValue(dynamic val) {
    if (val == null) return '—';
    if (val is String && val.trim().isEmpty) return '—';
    if (val is num && val == 0) return '—';
    return val.toString();
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: context.sp(10),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      backgroundColor: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.fonts.grey12w600,
                ),
                context.verticalSpace(4),
                Text(
                  value,
                  style: context.fonts.black18w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w(200),
            child: Text(
              label,
              style: context.fonts.grey14w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.fonts.black14w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context, int currentPage, int totalPages, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Page Button
          IconButton(
            onPressed: currentPage > 1
                ? () => ref.read(productViewModelProvider.notifier).previousBatchPage()
                : null,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: currentPage > 1 ? CustomColors.purple : CustomColors.grey,
            ),
          ),
          context.horizontalSpace(16),
          // Page display
          Text(
            'Page $currentPage of $totalPages',
            style: context.fonts.black14w600,
          ),
          context.horizontalSpace(16),
          // Next Page Button
          IconButton(
            onPressed: currentPage < totalPages
                ? () => ref.read(productViewModelProvider.notifier).nextBatchPage()
                : null,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: currentPage < totalPages ? CustomColors.purple : CustomColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLotPaginationFooter(BuildContext context, int batchId, int currentPage, int totalPages, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Lot Page
          IconButton(
            onPressed: currentPage > 1
                ? () => ref.read(productViewModelProvider.notifier).previousLotPage(batchId)
                : null,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: currentPage > 1 ? CustomColors.purple : CustomColors.grey,
            ),
          ),
          context.horizontalSpace(12),
          Text(
            'Page $currentPage of $totalPages',
            style: context.fonts.black12w600,
          ),
          context.horizontalSpace(12),
          // Next Lot Page
          IconButton(
            onPressed: currentPage < totalPages
                ? () => ref.read(productViewModelProvider.notifier).nextLotPage(batchId)
                : null,
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: currentPage < totalPages ? CustomColors.purple : CustomColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider);
    final ProductDetailModel? product = state.selectedProduct;

    if (product == null) {
      return GradientScaffold(
        body: Center(
          child: Text(
            'No Product Data Found',
            style: context.fonts.black16w400,
          ),
        ),
      );
    }

    final isLowStock = product.lowStockAlert ?? false;
    final totalLotsOnPage = state.selectedProductBatches.fold<int>(0, (int sum, ProductBatchModel b) => sum + b.totalLots);

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text('Product Detail', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(1100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: context.w(120),
                        height: context.w(120),
                        decoration: BoxDecoration(
                          color: CustomColors.whiteGrey,
                          borderRadius: context.appBorderRadius(all: 12),
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: CustomColors.purple,
                        ),
                      ),
                      context.horizontalSpace(24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatValue(product.name),
                              style: context.fonts.black26w700,
                            ),
                            context.verticalSpace(4),
                            Text(
                              '${_formatValue(product.brand)} • ${_formatValue(product.manufacturer)}',
                              style: context.fonts.purple14w600,
                            ),
                            context.verticalSpace(12),
                            Row(
                              children: [
                                Text(
                                  'Global SKU: ',
                                  style: context.fonts.grey12w600,
                                ),
                                Text(
                                  _formatValue(product.globalSku),
                                  style: context.fonts.black12w600,
                                ),
                                context.horizontalSpace(24),
                                Text(
                                  'Barcode: ',
                                  style: context.fonts.grey12w600,
                                ),
                                Text(
                                  _formatValue(product.barcode),
                                  style: context.fonts.black12w600,
                                ),
                              ],
                            ),
                            context.verticalSpace(16),
                            Row(
                              children: [
                                _buildBadge(
                                  context,
                                  product.status ?? 'active',
                                  (product.status?.toLowerCase() == 'active')
                                      ? CustomColors.green
                                      : CustomColors.grey,
                                ),
                                context.horizontalSpace(12),
                                _buildBadge(
                                  context,
                                  product.usageType ?? 'treatment',
                                  CustomColors.purple,
                                ),
                                if (isLowStock) ...[
                                  context.horizontalSpace(12),
                                  _buildBadge(
                                    context,
                                    'LOW STOCK ALERT',
                                    CustomColors.red,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                context.verticalSpace(24),

                // Statistic Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Stock Remaining',
                        '${product.totalQuantityRemaining ?? 0} Units',
                        Icons.warehouse_outlined,
                        CustomColors.purple,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Tracked Batches',
                        '${state.selectedProductBatchTotalPages * 2} Batches',
                        Icons.layers_outlined,
                        CustomColors.amber,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Total Active Lots',
                        '$totalLotsOnPage Lots on Page',
                        Icons.qr_code_scanner_outlined,
                        CustomColors.green,
                      ),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Stock Status',
                        isLowStock ? 'Low Stock Warning' : 'Optimal Level',
                        Icons.health_and_safety_outlined,
                        isLowStock ? CustomColors.red : CustomColors.green,
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(24),

                // Product Information Card
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Specifications', style: context.fonts.black18w600),
                      context.verticalSpace(16),
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'No product description provided.',
                        style: context.fonts.grey14w400h16,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(color: CustomColors.border),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoRow(context, 'Unit Type', _formatValue(product.unitType)),
                                _buildInfoRow(context, 'Package Type', _formatValue(product.packageType)),
                                _buildInfoRow(context, 'Billable Unit', _formatValue(product.billableUnit)),
                              ],
                            ),
                          ),
                          context.horizontalSpace(32),
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  context,
                                  'Billable Qty Per Item',
                                  product.billableQuantityPerItem != null
                                      ? '${product.billableQuantityPerItem} ${product.billableUnit ?? ""}'
                                      : '—',
                                ),
                                _buildInfoRow(
                                  context,
                                  'Enforce Lot Tracking',
                                  (product.enforceLotTracking ?? false) ? 'YES' : 'NO',
                                ),
                                _buildInfoRow(
                                  context,
                                  'Total Quantity remaining',
                                  '${product.totalQuantityRemaining ?? 0} Units',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                context.verticalSpace(32),

                // Batches & Lots Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_outlined, color: CustomColors.purple),
                        context.horizontalSpace(8),
                        Text('Batches & Lots tracking (Paginated)', style: context.fonts.black18w600),
                      ],
                    ),
                    SizedBox(
                      width: context.w(150),
                      child: CustomPrimaryButton(
                        label: '+ Add Batch',
                        onTap: () {
                          if (product.id != null) {
                            AddBatchDialog.show(context, product.id!);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(16),

                // Batches List Loading state
                if (state.loadingSelectedProductBatches)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: CustomColors.purple,
                      ),
                    ),
                  )
                else if (state.selectedProductBatches.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: context.appEdgeInsets(all: 32),
                    decoration: BoxDecoration(
                      color: CustomColors.whiteGrey,
                      borderRadius: context.appBorderRadius(all: 12),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.layers_clear_outlined, color: CustomColors.grey, size: 40),
                          context.verticalSpace(12),
                          Text('No Batches Configured', style: context.fonts.black16w600),
                          context.verticalSpace(4),
                          Text('There are no active production batches registered for this product.', style: context.fonts.grey14w400),
                        ],
                      ),
                    ),
                  )
                else ...[
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.selectedProductBatches.length,
                    separatorBuilder: (context, index) => context.verticalSpace(16),
                    itemBuilder: (context, bIdx) {
                      final ProductBatchModel batch = state.selectedProductBatches[bIdx];

                      final bool isLotsLoading = state.batchLotLoading[batch.id] ?? false;
                      final List<LotModel> loadedLots = state.batchLots[batch.id] ?? [];
                      final int lotsCurrentPage = state.batchLotPages[batch.id] ?? 1;
                      final int lotsTotalPages = state.batchLotTotalPages[batch.id] ?? 1;

                      return BorderdContainerWidget(
                        padding: EdgeInsets.zero,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: ExpansionTile(
                            tilePadding: context.appEdgeInsets(horizontal: 20, vertical: 8),
                            childrenPadding: context.appEdgeInsets(horizontal: 20, bottom: 20),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: CustomColors.amber.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.layers_outlined, color: CustomColors.amber, size: 20),
                            ),
                            title: Text(
                              batch.batchNumber,
                              style: context.fonts.black16w600,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Mfg: ${batch.manufactureDate}',
                                    style: context.fonts.grey12w600,
                                  ),
                                  context.horizontalSpace(16),
                                  Text(
                                    'Expiry: ${batch.nearestExpiryDate}',
                                    style: context.fonts.grey12w600,
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.purple.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${batch.totalQuantityRemaining} Units Left',
                                style: context.fonts.purple12w700,
                              ),
                            ),
                            onExpansionChanged: (expanded) {
                              if (expanded) {
                                ref.read(productViewModelProvider.notifier).fetchLotsForBatch(batchId: batch.id, page: 1);
                              }
                            },
                            children: [
                              const Divider(color: CustomColors.border, height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.qr_code_scanner_outlined, size: 16, color: CustomColors.grey),
                                      context.horizontalSpace(8),
                                      Text(
                                        'Associated Lots (${batch.totalLots})',
                                        style: context.fonts.black14w600,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: context.w(120),
                                    child: CustomPrimaryButton(
                                      height: context.h(36),
                                      padding: EdgeInsets.zero,
                                      label: '+ Add Lot',
                                      onTap: () {
                                        AddLotDialog.show(context, batch.id);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              context.verticalSpace(16),

                              if (isLotsLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: CustomColors.purple,
                                    ),
                                  ),
                                )
                              else if (loadedLots.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'No lots found inside this batch.',
                                    style: context.fonts.grey14w400,
                                  ),
                                )
                              else ...[
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: loadedLots.length,
                                  separatorBuilder: (context, index) => context.verticalSpace(12),
                                  itemBuilder: (context, lIdx) {
                                    final LotModel lot = loadedLots[lIdx];

                                    return Container(
                                      padding: context.appEdgeInsets(all: 16),
                                      decoration: BoxDecoration(
                                        color: CustomColors.whiteGrey,
                                        borderRadius: context.appBorderRadius(all: 8),
                                        border: Border.all(color: CustomColors.border),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Lot: ${lot.lotNumber}',
                                                    style: context.fonts.black14w700,
                                                  ),
                                                  context.horizontalSpace(12),
                                                  _buildBadge(
                                                    context,
                                                    lot.status,
                                                    lot.status.toLowerCase() == 'active'
                                                        ? CustomColors.green
                                                        : CustomColors.grey,
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                tooltip: 'View Lot Items',
                                                icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  color: CustomColors.purple,
                                                ),
                                                onPressed: () async {
                                                  final success = await ref
                                                      .read(productViewModelProvider.notifier)
                                                      .fetchLotItems(lotId: lot.id, page: 1);
                                                  if (success && context.mounted) {
                                                    context.push(LotItemsScreen.routeName);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          context.verticalSpace(12),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('LOT BARCODE', style: context.fonts.grey10w700),
                                                    Text(lot.lotBarcode, style: context.fonts.black13w600),
                                                    context.verticalSpace(8),
                                                    Text('SUPPLIER', style: context.fonts.grey10w700),
                                                    Text(lot.supplier, style: context.fonts.black13w600),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('EXPIRATION DATE', style: context.fonts.grey10w700),
                                                    Text(lot.expirationDate, style: context.fonts.black13w600),
                                                    context.verticalSpace(8),
                                                    Text('PRICING STRUCTURE', style: context.fonts.grey10w700),
                                                    Text(
                                                      'Cost: \$${lot.clinicCost.toStringAsFixed(0)} | Retail: \$${lot.retailPricePerUnit.toStringAsFixed(0)}',
                                                      style: context.fonts.black13w600,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('QUANTITY ALLOCATION', style: context.fonts.grey10w700),
                                                    Text(
                                                      '${lot.quantityRemaining} remaining (out of ${lot.quantityReceived})',
                                                      style: context.fonts.black13w600,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                if (lotsTotalPages > 1)
                                  _buildLotPaginationFooter(
                                    context,
                                    batch.id,
                                    lotsCurrentPage,
                                    lotsTotalPages,
                                    ref,
                                  ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  
                  // Standard Footer Pagination matching Products Listing behaviour
                  if (state.selectedProductBatchTotalPages > 1)
                    _buildPaginationFooter(
                      context,
                      state.selectedProductBatchPage,
                      state.selectedProductBatchTotalPages,
                      ref,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}