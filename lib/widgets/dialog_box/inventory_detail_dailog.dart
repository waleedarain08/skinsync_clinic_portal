// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:skinsync_clinic_portal/models/dummy/inventory.dart';
// import 'package:skinsync_clinic_portal/models/responses/clinic_products_response.dart';
//
// import '../../utils/color_constant.dart';
// import '../../utils/custom_fonts.dart';
// import '../../utils/date_time_utills.dart';
//
// class InventoryDetailDialog extends StatelessWidget {
//   final ClinicProduct item;
//   const InventoryDetailDialog({super.key, required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//       child: Container(
//         width: 600.w,
//         padding: EdgeInsets.all(24.w),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Item Details", style: CustomFonts.black20w700),
//                 IconButton(
//                   onPressed: () => Navigator.pop(context),
//                   icon: const Icon(Icons.close),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Image.asset(
//                     item.image,
//                     width: 140.w,
//                     height: 140.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(width: 24.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(item.name, style: CustomFonts.black22w600),
//                       SizedBox(height: 12.h),
//                       Text(
//                         '\$${item.originalPrice.toStringAsFixed(2)} per unit',
//                         style: CustomFonts.black16w600.copyWith(
//                           color: CustomColors.purpleColor,
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: CustomColors.blueColor.withValues(alpha: 0.1),
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         child: Text(
//                           'Current Stock: ${item.quantity}',
//                           style: CustomFonts.black14w600.copyWith(
//                             color: CustomColors.silverColor,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 30.h),
//             Text("Inventory History", style: CustomFonts.black18w600),
//             SizedBox(height: 16.h),
//             Flexible(
//               child: item.history.isEmpty
//                   ? Padding(
//                       padding: EdgeInsets.symmetric(vertical: 20.h),
//                       child: Center(
//                         child: Text(
//                           "No history available",
//                           style: CustomFonts.grey14w400,
//                         ),
//                       ),
//                     )
//                   : SizedBox(
//                       height: 300.h,
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         itemCount: item.history.length,
//                         separatorBuilder: (context, index) =>
//                             Divider(color: Colors.grey[100]),
//                         itemBuilder: (context, index) {
//                           final history = item.history[index];
//                           return ListTile(
//                             contentPadding: EdgeInsets.zero,
//                             leading: CircleAvatar(
//                               backgroundColor: CustomColors.lightBlueColor
//                                   .withValues(alpha: 0.1),
//                               child: Icon(
//                                 history.isAdded
//                                     ? Icons.add_shopping_cart
//                                     : Icons.sell,
//                                 color: CustomColors.blueColor,
//                                 size: 18.r,
//                               ),
//                             ),
//                             title: Text(
//                               history.isAdded ? "Stock Added" : "Stock Sold",
//                               style: CustomFonts.black14w600,
//                             ),
//                             subtitle: Text(
//                               history.date.formattedDateTime,
//                               style: CustomFonts.grey14w400.copyWith(
//                                 fontSize: 12.sp,
//                               ),
//                             ),
//                             trailing: Text(
//                               '${history.isAdded ? "+" : "-"}${history.quantity}',
//                               style: CustomFonts.black16w600.copyWith(
//                                 color: CustomColors.silverColor,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
