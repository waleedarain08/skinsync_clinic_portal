import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/lot_items_list_response.dart';
import '../utils/enums.dart';
import '../utils/theme.dart';
import '../view_models/product_view_model.dart';
import '../widgets/borderd_container_widget.dart';
import '../widgets/dialog_box/edit_lot_item_dialog.dart';
import '../widgets/gradient_scaffold.dart';

class LotItemsScreen extends ConsumerStatefulWidget {
  const LotItemsScreen({super.key});

  static const String routeName = '/lot-items';

  @override
  ConsumerState<LotItemsScreen> createState() => _LotItemsScreenState();
}

class _LotItemsScreenState extends ConsumerState<LotItemsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final state = ref.read(productViewModelProvider);
    if (state.activeLotId != null) {
      ref.read(productViewModelProvider.notifier).fetchLotItems(
            lotId: state.activeLotId!,
            page: 1,
            search: query,
          );
    }
  }

 Widget _buildStatusBadge(BuildContext context, String status) {
  final lotStatus = LotItemStatus.values.firstWhere(
    (e) => e.value == status.toLowerCase(),
    orElse: () => LotItemStatus.available,
  );

  Color badgeColor;

  switch (lotStatus) {
    case LotItemStatus.available:
      badgeColor = CustomColors.green;
      break;
    case LotItemStatus.allocated:
      badgeColor = CustomColors.blue;
      break;
    case LotItemStatus.used:
      badgeColor = CustomColors.grey;
      break;
    case LotItemStatus.reserved:
      badgeColor = CustomColors.amber;
      break;
    case LotItemStatus.damaged:
      badgeColor = CustomColors.red;
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: badgeColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
    ),
    child: Text(
      lotStatus.label.toUpperCase(),
      style: TextStyle(
        color: badgeColor,
        fontSize: context.sp(9),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}
  Widget _buildItemCard(BuildContext context, LotItemModel item) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    child: const Icon(
                      Icons.tag_rounded,
                      color: CustomColors.purple,
                      size: 16,
                    ),
                  ),
                  context.horizontalSpace(8),
                  _buildStatusBadge(context, item.status),
                ],
              ),
              IconButton(
                onPressed: () => EditLotItemDialog.show(context, item),
                icon: const Icon(
                  Icons.edit_outlined,
                  color: CustomColors.purple,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Edit Item',
              ),
            ],
          ),
          context.verticalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.serialNumber,
                style: context.fonts.black14w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.verticalSpace(4),
              Text(
                'Barcode: ${item.itemBarcode}',
                style: context.fonts.grey12w400,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationFooter(BuildContext context, int currentPage, int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Page Button
          IconButton(
            onPressed: currentPage > 1
                ? () => ref.read(productViewModelProvider.notifier).previousLotItemPage()
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
                ? () => ref.read(productViewModelProvider.notifier).nextLotItemPage()
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productViewModelProvider);
    final bool isDesktop = context.screenWidth > 1200;

    // Calculate grid columns based on screen width
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
        title: Text('Lot Items Catalog', style: context.fonts.black18w600),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.w(isDesktop ? 1000 : 1100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Controls (Search)
              Padding(
                padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
                child: BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 16),
                  backgroundColor: Colors.white,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items by serial number or item barcode...',
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
                ),
              ),

              // Items Content Area
              Expanded(
                child: state.loadingLotItems
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.purple,
                        ),
                      )
                    : state.lotItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.block_outlined,
                                  size: 48,
                                  color: CustomColors.grey,
                                ),
                                context.verticalSpace(16),
                                Text(
                                  'No Lot Items Found',
                                  style: context.fonts.black16w600,
                                ),
                                context.verticalSpace(4),
                                Text(
                                  'Try searching for other serial numbers or barcodes.',
                                  style: context.fonts.grey14w400,
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  padding: context.appEdgeInsets(horizontal: 16, vertical: 8),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: gridColumns,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: isDesktop ? 1.8 : 1.5,
                                  ),
                                  itemCount: state.lotItems.length,
                                  itemBuilder: (context, index) {
                                    return _buildItemCard(context, state.lotItems[index]);
                                  },
                                ),
                              ),
                              if (state.lotItemTotalPages > 1)
                                _buildPaginationFooter(
                                  context,
                                  state.lotItemPage,
                                  state.lotItemTotalPages,
                                ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}