import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/treatment_model.dart';
import '../utils/assets.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../view_models/treatment_view_model.dart';
import 'dialog_box/edit_treatment_dailogbox.dart';

class TreatmentListTile extends ConsumerWidget {
  const TreatmentListTile({super.key, required this.treatment});

  final TreatmentModel treatment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: context.isLandscape ? context.h(300) : context.h(500),
      margin: EdgeInsets.all(context.w(20)),
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.blue.withValues(alpha: 0.15),
            blurRadius: context.r(8),
            offset: Offset(0, context.h(2)),
          ),
          BoxShadow(
            color: CustomColors.lightPurple.withValues(alpha: 0.15),
            blurRadius: context.r(10),
            offset: Offset(context.h(2), 0),
          ),
        ],
        borderRadius: BorderRadius.circular(context.r(15)),
      ),
      child: AdaptiveLayoutRowColumn(
        size: MainAxisSize.max,
        expandedWidget: true,
        widthBetween: 0,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: Image.asset(
              PngAssets.treatmentImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: CustomColors.softGrey,
                child: const Icon(Icons.broken_image, color: CustomColors.grey),
              ),
            ),
          ),
          context.isLandscape
              ? treatmentResponsiveData(context, ref)
              : Expanded(child: treatmentResponsiveData(context, ref)),
        ],
      ),
    );
  }

  Widget treatmentResponsiveData(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  ref
                      .read(treatmentViewModelProvider.notifier)
                      .setTreatment(treatment.id!);
                  showDialog(
                    context: context,
                    builder: (context) => const EditTreatmentDialog(),
                  );
                },
                child: const Icon(Icons.edit),
              ),
              InkWell(
                onTap: () {
                  ref
                      .read(treatmentViewModelProvider.notifier)
                      .deleteTreatment(treatmentId: treatment.id!);
                },
                child: const Icon(Icons.delete, color: CustomColors.red),
              ),
            ],
          ),
        ),

        // Title
        Text(treatment.name ?? "N/A", style: CustomFonts.black18w600),
        SizedBox(height: context.h(20)),
        // Area
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.w(10)),
            child: Wrap(
              spacing: context.r(20),
              runSpacing: context.r(20),
              children: List.generate(
                treatment.sideAreas?.length ?? 0,
                (index) => Container(
                  margin: EdgeInsets.only(right: context.w(10)),
                  padding: EdgeInsets.all(context.w(14)),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(14)),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.blue.withValues(alpha: 0.15),
                        blurRadius: context.r(8),
                        offset: Offset(0, context.h(2)),
                      ),
                      BoxShadow(
                        color: CustomColors.lightPurple.withValues(alpha: 0.15),
                        blurRadius: context.r(10),
                        offset: Offset(context.h(2), 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment.sideAreas?[index].name ?? "N/A",
                        style: CustomFonts.black14w500.copyWith(
                          color: CustomColors.grey,
                        ),
                      ),
                      SizedBox(height: context.h(10)),

                      // Price
                      treatment.sideAreas?[index].perSyringePrice == null
                          ? const SizedBox()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: CustomFonts.black14w600,
                                    children: [
                                      TextSpan(
                                        text:
                                            "AED ${treatment.sideAreas?[index].perSyringePrice ?? ""} ",
                                        style: CustomFonts.black14w600.copyWith(
                                          color: CustomColors.blue,
                                        ),
                                      ),
                                      const TextSpan(text: " /Per Syringe"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            " Price: AED ${treatment.price ?? ""}",
            style: CustomFonts.black18w600.copyWith(color: CustomColors.purple),
          ),
        ),
      ],
    );
  }
}
