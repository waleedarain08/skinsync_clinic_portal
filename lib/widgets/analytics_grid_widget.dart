import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/responsive.dart';
import '../view_models/auth_view_model.dart';
import 'mini_stat_card.dart';

class AnalyticsGridWidget extends StatelessWidget {
  const AnalyticsGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,_) {
        final dashboard = ref.watch(authViewModelProvider).dashboard;
        return  AdaptiveLayoutRowColumn(
          expandedWidget: true,
          crossAlignment: .start,
          widthBetween: 16,
          heightBetween: 16,
          children: [
            MiniStatCard(
              icon: Icons.calendar_today_outlined,
              color:const Color(0xFF7DD3D3),
              value: dashboard?.totalTreatment ?? 0,
              title: "Total Treatments",
            ),
            MiniStatCard(
              icon: Icons.schedule_outlined,
              color: const Color(0xFFE89FD5),
              value: dashboard?.totalPractitioner ?? 0,
              title: "Total Providers",
            ),
            MiniStatCard(
              icon: Icons.cancel_outlined,
              color:const Color(0xFFFF9B9B),
              value: dashboard?.totalTreatmentRequest ?? 0,
              title: "Total Treatment Request",
            ),
          ],
        );
      }
    );
  }
}
