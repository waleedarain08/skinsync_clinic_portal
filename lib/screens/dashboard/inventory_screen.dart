import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_clinic_portal/models/responses/clinic_products_response.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/view_models/inventory_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/build_textfield.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';

import '../../widgets/dailog box/add_product_dailog.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  static const String routeName = '/inventory_screen';
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryProvider.notifier).getData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddProductDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: Column(
          children: [
            SizedBox(height: context.h(20)),
            _buildHeader(context),
            SizedBox(height: context.h(24)),
            _buildSearchBar(),
            SizedBox(height: context.h(24)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(24)),
            Expanded(child: _buildInventoryGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text("Inventory", style: context.fonts.black20w600),
        const Spacer(),
        CustomPrimaryButton(
          onTap: _showAddProductDialog,
          label: 'Add Item',
          icon: Icons.add,
          height: context.h(45),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return BuildTextField(
      label: 'Search Products',
      controller: _searchController,
      hintText: 'Search by item name...',
      prefixIcon: Icon(
        Iconsax.search_normal,
        size: context.r(20),
        color: CustomColors.grey,
      ),
    );
  }

  Widget _buildInventoryGrid(BuildContext context) {
    int crossAxisCount = context.isLandscape ? 4 : 2;
    double childAspectRatio = context.isLandscape ? 1.1 : 0.7;
    return Consumer(
      builder: (_, ref, _) {
        final data = ref.watch(
          inventoryProvider.select((s) => (s.products, s.loading)),
        );
        if (data.$2) {
          return const Center(
            child: CircularProgressIndicator(color: CustomColors.purple),
          );
        }
        return GridView.builder(
          itemCount: data.$1.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: context.w(20),
            mainAxisSpacing: context.h(20),
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: _buildInventoryCard(data.$1[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildInventoryCard(ClinicProduct item) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, context.h(2)),
          ),
        ],
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(context.r(15)),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: CustomColors.softGrey,
                        height: double.infinity,
                        width: double.infinity,
                        child: const Icon(
                          Icons.broken_image,
                          color: CustomColors.grey,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: context.h(10),
                    right: context.w(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(8),
                        vertical: context.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(context.r(20)),
                      ),
                      child: Text(
                        'Qty: ${item.totalQuantity}',
                        style: context.fonts.black12w600.copyWith(
                          color: item.totalQuantity < 20
                              ? CustomColors.red
                              : CustomColors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(context.w(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.fonts.black16w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.h(8)),
                Row(
                  children: [
                    Text(
                      'AED ${item.originalPrice.toStringAsFixed(2)}',
                      style: context.fonts.black14w600.copyWith(
                        color: CustomColors.purple,
                      ),
                    ),
                    if (item.discountedPrice > 0 &&
                        item.discountedPrice != item.originalPrice) ...{
                      SizedBox(width: context.w(10)),
                      Text(
                        'AED ${item.originalPrice.toStringAsFixed(2)}',
                        style: context.fonts.black12w400.copyWith(
                          color: CustomColors.purple,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    },
                    const Spacer(),
                    Text(
                      'per unit',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
