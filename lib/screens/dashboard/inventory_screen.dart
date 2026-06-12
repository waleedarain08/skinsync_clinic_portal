import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_clinic_portal/models/responses/clinic_products_response.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/view_models/inventory_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/build_textfield.dart';

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

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddProductDialog();
      },
    );
  }

  // void _showInventoryDetailDialog(InventoryItem item) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return InventoryDetailDialog(item: item);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildHeader(context),
            SizedBox(height: 24.h),
            _buildSearchBar(),
            SizedBox(height: 24.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 24.h),
            Expanded(child: _buildInventoryGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text("Inventory", style: CustomFonts.black20w600),
        const Spacer(),
        ElevatedButton(
          onPressed: _showAddProductDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            elevation: 0,
          ),
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.white, size: 20.r),
              SizedBox(width: 8.w),
              Text('Add Item', style: CustomFonts.white14w600),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return BuildTextField(
      label: 'Search Products',
      controller: _searchController,
      hintText: 'Search by item name...',
      prefixIcon: Icon(Iconsax.search_normal, size: 20.r, color: Colors.grey),
      // onChanged: _filterInventory,
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
          return Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          itemCount: data.$1.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              // onTap: () => _showInventoryDetailDialog(_filteredItems[index]),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: CustomColors.paleBlue.withValues(alpha: 0.2),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
          BoxShadow(
            color: CustomColors.lightPurple.withValues(alpha: 0.1),
            blurRadius: 10.r,
            offset: Offset(2.h, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE8E8E8),
                        height: double.infinity,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Qty: ${item.totalQuantity}',
                        style: CustomFonts.black12w600.copyWith(
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
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: CustomFonts.black16w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      '\$${item.originalPrice.toStringAsFixed(2)}',
                      style: CustomFonts.black14w600.copyWith(
                        color: CustomColors.purple,
                      ),
                    ),
                    if (item.discountedPrice > 0 &&
                        item.discountedPrice != item.originalPrice) ...{
                      SizedBox(width: 10.w),
                      Text(
                        '\$${item.originalPrice.toStringAsFixed(2)}',
                        style: CustomFonts.black12w400.copyWith(
                          color: CustomColors.purple,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    },
                    Spacer(),
                    Text(
                      'per unit',
                      style: CustomFonts.grey14w500.copyWith(fontSize: 12.sp),
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
