import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'mini_stat_card.dart';

class AnalyticsGridWidget extends StatelessWidget {
  const AnalyticsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AdaptiveLayoutRowColumn(
          expandedWidget: true,
          children: [
            MiniStatCard(
              icon: Icons.calendar_today_outlined,
              color: Color(0xFF7DD3D3),
              value: 0,
              title: "Completed Appointments",
            ),
            MiniStatCard(
              icon: Icons.schedule_outlined,
              color: Color(0xFFE89FD5),
              value: 0,
              title: "Pending Appointments",
            ),
            MiniStatCard(
              icon: Icons.cancel_outlined,
              color: Color(0xFFFF9B9B),
              value: 0,
              title: "Cancelled Appointments",
            ),
          ],
        ),
        SizedBox(height: context.h(20)),
        const AdaptiveLayoutRowColumn(
          expandedWidget: true,
          children: [
            MiniStatCard(
              icon: Icons.medical_services_outlined,
              color: Color(0xFF7DD3D3),
              value: 0,
              title: "Total Treatments",
            ),
            MiniStatCard(
              icon: Icons.star_outline,
              color: Color(0xFFFFB366),
              value: 0,
              title: "Ratings",
            ),
          ],
        ),
      ],
    );
  }
}
