import 'package:flutter/material.dart';
import '../utils/responsive.dart';

import '../utils/theme.dart';
import 'analytics_card_widget.dart';

class AnalyticsGridWidget extends StatelessWidget {
  const AnalyticsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AdaptiveLayoutRowColumn(
          expandedWidget: true,
          children: [
            AnalyticsCardWidget(
              icon: Icons.calendar_today_outlined,
              iconColor: Color(0xFF7DD3D3),
              bgColor: Color(0xFFE8F6F6),
              value: "0",
              label: "Completed Appointments",
            ),
            AnalyticsCardWidget(
              icon: Icons.schedule_outlined,
              iconColor: Color(0xFFE89FD5),
              bgColor: Color(0xFFFCEFF9),
              value: "0",
              label: "Pending Appointments",
            ),
            AnalyticsCardWidget(
              icon: Icons.cancel_outlined,
              iconColor: Color(0xFFFF9B9B),
              bgColor: Color(0xFFFFEDED),
              value: "0",
              label: "Cancelled Appointments",
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
        const AdaptiveLayoutRowColumn(
          expandedWidget: true,
          children: [
            AnalyticsCardWidget(
              icon: Icons.medical_services_outlined,
              iconColor: Color(0xFF7DD3D3),
              bgColor: Color(0xFFE8F6F6),
              value: "0",
              label: "Total Treatments",
            ),
            AnalyticsCardWidget(
              icon: Icons.star_outline,
              iconColor: Color(0xFFFFB366),
              bgColor: Color(0xFFFFF3E8),
              value: "0.0",
              label: "Ratings",
            ),
          ],
        ),
      ],
    );
  }
}
