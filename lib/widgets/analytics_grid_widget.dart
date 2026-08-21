import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import 'mini_stat_card.dart';

class AnalyticsGridWidget extends StatelessWidget {
  const AnalyticsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdaptiveLayoutRowColumn(
      expandedWidget: true,
      crossAlignment: .start,
      widthBetween: 16,
      heightBetween: 16,
      children: [
        MiniStatCard(
          icon: Icons.calendar_today_outlined,
          color: Color(0xFF7DD3D3),
          value: 0,
          title: "Total Treatments",
        ),
        MiniStatCard(
          icon: Icons.schedule_outlined,
          color: Color(0xFFE89FD5),
          value: 0,
          title: "Total Providers",
        ),
        MiniStatCard(
          icon: Icons.cancel_outlined,
          color: Color(0xFFFF9B9B),
          value: 0,
          title: "Total Treatment Request",
        ),
      ],
    );
  }
}
