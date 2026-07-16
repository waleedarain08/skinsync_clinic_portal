// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'borderd_container_widget.dart';
//
// import '../models/treatment_model.dart';
// import '../utils/theme.dart';
// import '../view_models/treatment_view_model.dart';
// // import 'dialog_box/edit_treatment_dailogbox.dart';
//
// class TreatmentListTile extends ConsumerWidget {
//   const TreatmentListTile({super.key, required this.treatment});
//
//   final TreatmentModel treatment;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final hasAreas = treatment.isArea == true;
//
//     return BorderdContainerWidget(
//       margin: EdgeInsets.only(bottom: context.h(15)),
//       child: Row(
//         children: [
//           // Left Icon Container (using Vaccines icon in purple matching the portal theme)
//           Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(context.r(10)),
//               color: CustomColors.purple.withValues(alpha: 0.15),
//             ),
//             padding: EdgeInsets.all(context.w(12)),
//             margin: EdgeInsets.symmetric(horizontal: context.w(14)),
//             child: const Icon(
//               Icons.vaccines_outlined,
//               color: CustomColors.purple,
//             ),
//           ),
//
//           // Middle Expanded Info Section
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         treatment.name ?? "N/A",
//                         style: CustomFonts.black16w600,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     SizedBox(width: context.w(10)),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(context.r(10)),
//                         color: hasAreas
//                             ? CustomColors.purple.withValues(alpha: 0.1)
//                             : CustomColors.green.withValues(alpha: 0.1),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: context.w(9),
//                         vertical: context.w(4),
//                       ),
//                       child: Text(
//                         hasAreas ? "Anatomical" : "Standard",
//                         style: CustomFonts.black12w600.copyWith(
//                           color: hasAreas ? CustomColors.purple : CustomColors.green,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: context.h(8)),
//                 Text(
//                   treatment.description ?? "No description available.",
//                   style: CustomFonts.grey13w500,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: context.h(8)),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.layers_outlined,
//                       size: 17,
//                       color: CustomColors.grey,
//                     ),
//                     SizedBox(width: context.w(5)),
//                     Text(
//                       hasAreas
//                           ? "${treatment.sideAreas?.length ?? 0} Sub-Areas Configured"
//                           : "Single Standard Area",
//                       style: CustomFonts.black14w500.copyWith(color: CustomColors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           // Right Column for Price and Operations (Edit / Delete)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 'AED ${treatment.price ?? 0}',
//                 style: CustomFonts.black16w600.copyWith(
//                   color: CustomColors.purple,
//                 ),
//               ),
//               SizedBox(height: context.h(14)),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       ref
//                           .read(treatmentViewModelProvider.notifier)
//                           .setTreatment(treatment.id!);
//                       showDialog(
//                         context: context,
//                         builder: (context) => const EditTreatmentDialog(),
//                       );
//                     },
//                     borderRadius: BorderRadius.circular(context.r(4)),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(4)),
//                       child: const Icon(Icons.edit_outlined, size: 18, color: CustomColors.grey),
//                     ),
//                   ),
//                   SizedBox(width: context.w(4)),
//                   InkWell(
//                     onTap: () {
//                       ref
//                           .read(treatmentViewModelProvider.notifier)
//                           .deleteTreatment(treatmentId: treatment.id!);
//                     },
//                     borderRadius: BorderRadius.circular(context.r(4)),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: context.w(6), vertical: context.h(4)),
//                       child: const Icon(Icons.delete_outline_rounded, size: 18, color: CustomColors.red),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
