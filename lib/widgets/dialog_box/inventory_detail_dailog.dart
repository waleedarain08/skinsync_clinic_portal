// import 'package:flutter/material.dart';
// import '../../models/responses/clinic_products_response.dart';
// import '../../utils/theme.dart';
// import 'standard_dialog.dart';
//
// class InventoryDetailDialog extends StatelessWidget {
//   final ClinicProduct item;
//   const InventoryDetailDialog({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return StandardDialog(
//       title: "Item Details",
//       width: 600.w,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: context.appBorderRadius(all: 12),
//                 child: Image.network(
//                   item.image ?? '',
//                   width: 140.w,
//                   height: 140.w,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     width: 140.w,
//                     height: 140.w,
//                     color: CustomColors.whiteGrey,
//                     child: Icon(
//                       Icons.image_not_supported,
//                       color: CustomColors.lightGrey,
//                       size: 40.sp,
//                     ),
//                   ),
//                 ),
//               ),
//               context.horizontalSpace(24),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(item.name ?? 'N/A', style: context.fonts.black20w600),
//                     context.verticalSpace(12),
//                     Text(
//                       'AED ${item.originalPrice?.toStringAsFixed(2) ?? '0.00'} per unit',
//                       style: context.fonts.purple16w600,
//                     ),
//                     context.verticalSpace(12),
//                     Container(
//                       padding: context.appEdgeInsets(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: CustomColors.blue.withValues(alpha: 0.1),
//                         borderRadius: context.appBorderRadius(all: 20),
//                       ),
//                       child: Text(
//                         'Current Stock: ${item.quantity ?? 0}',
//                         style: context.fonts.black14w600.copyWith(
//                           color: CustomColors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           context.verticalSpace(30),
//           Text("Inventory History", style: context.fonts.black16w600),
//           context.verticalSpace(16),
//           if (item.history == null || item.history!.isEmpty)
//             Padding(
//               padding: context.appEdgeInsets(vertical: 20),
//               child: Center(
//                 child: Text(
//                   "No history available",
//                   style: context.fonts.grey14w400,
//                 ),
//               ),
//             )
//           else
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: 300.h),
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: item.history!.length,
//                 separatorBuilder: (context, index) =>
//                     const Divider(color: CustomColors.border),
//                 itemBuilder: (context, index) {
//                   final history = item.history![index];
//                   final bool isAdded = history.isAdded ?? true;
//                   return ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: CircleAvatar(
//                       backgroundColor:
//                           (isAdded ? CustomColors.green : CustomColors.amber)
//                               .withValues(alpha: 0.1),
//                       child: Icon(
//                         isAdded ? Icons.add_shopping_cart : Icons.sell,
//                         color: isAdded
//                             ? CustomColors.green
//                             : CustomColors.amber,
//                         size: 18.sp,
//                       ),
//                     ),
//                     title: Text(
//                       isAdded ? "Stock Added" : "Stock Sold",
//                       style: context.fonts.black14w600,
//                     ),
//                     subtitle: Text(
//                       history.date ?? 'N/A',
//                       style: context.fonts.grey12w400,
//                     ),
//                     trailing: Text(
//                       '${isAdded ? "+" : "-"}${history.quantity}',
//                       style: context.fonts.black16w600.copyWith(
//                         color: isAdded
//                             ? CustomColors.green
//                             : CustomColors.amber,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
