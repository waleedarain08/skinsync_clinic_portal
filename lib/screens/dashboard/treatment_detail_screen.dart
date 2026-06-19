import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme.dart';
import '../../models/treatment_model.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class TreatmentDetailScreen extends StatelessWidget {
  static const String routeName = '/treatment-detail';

  final TreatmentModel treatment;

  const TreatmentDetailScreen({
    super.key,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    final hasAreas = treatment.isArea == true;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text(treatment.name ?? 'Treatment Details', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CustomColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(800)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Treatment Overview Card
                Text(
                  'CLINICAL OVERVIEW',
                  style: context.fonts.grey11w600ls12,
                ),
                context.verticalSpace(12),
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  borderRadius: context.r(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: context.appEdgeInsets(all: 12),
                            decoration: BoxDecoration(
                              color: CustomColors.purple.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.vaccines_outlined,
                              color: CustomColors.purple,
                              size: 28,
                            ),
                          ),
                          context.horizontalSpace(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  treatment.name ?? 'N/A',
                                  style: context.fonts.black20w600,
                                ),
                                context.verticalSpace(4),
                                Container(
                                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: hasAreas
                                        ? CustomColors.purple.withValues(alpha: 0.1)
                                        : CustomColors.green.withValues(alpha: 0.1),
                                    borderRadius: context.appBorderRadius(all: 20),
                                  ),
                                  child: Text(
                                    hasAreas ? "Anatomical Structure" : "Standard Procedure",
                                    style: context.fonts.grey12w600.copyWith(
                                      color: hasAreas ? CustomColors.purple : CustomColors.green,
                                      fontSize: context.sp(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(24),
                      const Divider(),
                      context.verticalSpace(16),
                      Text(
                        'Description',
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(8),
                      Text(
                        treatment.description ?? 'No description available for this treatment.',
                        style: context.fonts.grey14w400h16,
                      ),
                    ],
                  ),
                ),
                context.verticalSpace(32),

                // Section: Financial Pricing Card
                Text(
                  'FINANCIAL STRUCTURE',
                  style: context.fonts.grey11w600ls12,
                ),
                context.verticalSpace(12),
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  borderRadius: context.r(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Base Treatment Session Rate',
                            style: context.fonts.black16w600,
                          ),
                          context.verticalSpace(4),
                          Text(
                            'Standard pricing configured for local catalog',
                            style: context.fonts.grey12w400,
                          ),
                        ],
                      ),
                      Text(
                        'AED ${treatment.price ?? 0}',
                        style: context.fonts.purple16w700.copyWith(
                          fontSize: context.sp(22),
                        ),
                      ),
                    ],
                  ),
                ),
                context.verticalSpace(32),

                // Section: Configured Sub-Areas & Syringe limits
                if (hasAreas && treatment.sideAreas != null && treatment.sideAreas!.isNotEmpty) ...[
                  Text(
                    'SUB-AREAS & METRICS',
                    style: context.fonts.grey11w600ls12,
                  ),
                  context.verticalSpace(12),
                  BorderdContainerWidget(
                    padding: context.appEdgeInsets(all: 24),
                    borderRadius: context.r(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anatomical Sub-Sections Pricing Rules',
                          style: context.fonts.black16w600,
                        ),
                        context.verticalSpace(6),
                        Text(
                          'Individual price per syringe and injection limits per area',
                          style: context.fonts.grey12w400,
                        ),
                        context.verticalSpace(24),
                        const Divider(),
                        context.verticalSpace(16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: treatment.sideAreas!.length,
                          separatorBuilder: (context, index) => const Divider(height: 24),
                          itemBuilder: (context, idx) {
                            final area = treatment.sideAreas![idx];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.subdirectory_arrow_right,
                                      color: CustomColors.purple,
                                      size: 18,
                                    ),
                                    context.horizontalSpace(8),
                                    Text(
                                      area.name ?? 'N/A',
                                      style: context.fonts.black14w600,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'AED ${area.perSyringePrice?.toStringAsFixed(0) ?? "0"} / syringe',
                                      style: context.fonts.purple14w700,
                                    ),
                                    context.verticalSpace(2),
                                    Text(
                                      'Max Syringes allowed: ${area.maxSyringe ?? 1}',
                                      style: context.fonts.grey12w400,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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
