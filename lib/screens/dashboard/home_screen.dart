import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

import '../../widgets/gradient_scaffold.dart';
import '../../widgets/analytics_grid_widget.dart';
import '../../widgets/treatment_list_widget.dart';
import '../../widgets/recent_treatment_row_widget.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../services/locator.dart';
import '../../services/storage_service.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Matches Admin Dashboard Screen structure and styles)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: locator<SecureStorageService>().getUser(),
                    builder: (context, snapshot) {
                      final name = snapshot.data?.name ?? 'Alex';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, $name',
                            style: context.fonts.level1Heading,
                          ),
                          context.verticalSpace(6),
                          Text(
                            "Here's a summary of your MedSpa clinic performance.",
                            style: context.fonts.grey13w500,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                _buildDateFilter(context),
              ],
            ),
            context.verticalSpace(32),

            // Analytics Section (styled exactly like Admin overview panels)
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analytics", style: context.fonts.black18w600),
                  context.verticalSpace(24),
                  const AnalyticsGridWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            // Upcoming Appointments Section (styled with identical border and shadow structures)
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Treatments",
                          style: context.fonts.black18w600,
                        ),
                      ),
                      context.horizontalSpace(20),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentListWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            // AI Recommendations Section (cohesive soft lavender thematic coloring)

            // Recent Treatments Section (styled with identical border and shadow structures)
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Treatments Rquest",
                        style: context.fonts.black18w600,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentRequestRowWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
        boxShadow: AppShadows.xs(context),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: context.sp(16),
            color: CustomColors.purple,
          ),
          context.horizontalSpace(12),
          Text('Oct 2023', style: context.fonts.black14w600),
          context.horizontalSpace(8),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: context.sp(18),
            color: CustomColors.lightGrey,
          ),
        ],
      ),
    );
  }
}
