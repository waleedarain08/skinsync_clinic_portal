import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import '../utils/theme.dart';
import 'treatment_stats_card_widget.dart';

class AiRowWidget extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const AiRowWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutList(
      horizontalHeight: context.r(400),
      spaceHeight: context.h(20),
      spaceWidth: context.w(20),
      isScrollVertical: false,
      children: [
        TreatmentStatsCard(
          cardGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffD8F7FF), Color(0xff8BE7FF)],
          ),
          revenue: stats[2]['revenue'],
          percentage: stats[2]['percentage'],
          percentageChange: stats[2]['percentageChange'],
          mainLabel: stats[2]['mainLabel'],
          treatmentName: stats[2]['treatmentName'],
          originalPrice: stats[2]['originalPrice'],
          discountedPrice: stats[2]['discountedPrice'],
          description: stats[2]['description'],
          buttonText: stats[2]['buttonText'],
          progress: stats[2]['progress'],
          onButtonPressed: () {},
        ),
        TreatmentStatsCard(
          cardGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff88E3FB), Color(0xffEEA1F0)],
          ),
          revenue: stats[1]['revenue'],
          percentage: stats[1]['percentage'],
          percentageChange: stats[1]['percentageChange'],
          mainLabel: stats[1]['mainLabel'],
          treatmentName: stats[1]['treatmentName'],
          originalPrice: stats[1]['originalPrice'],
          discountedPrice: stats[1]['discountedPrice'],
          description: stats[1]['description'],
          buttonText: stats[1]['buttonText'],
          progress: stats[1]['progress'],
          onButtonPressed: () {},
        ),
        TreatmentStatsCard(
          cardGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffD8FFED), Color(0xff92FFCE)],
          ),
          revenue: stats[0]['revenue'],
          percentage: stats[0]['percentage'],
          percentageChange: stats[0]['percentageChange'],
          mainLabel: stats[0]['mainLabel'],
          treatmentName: stats[0]['treatmentName'],
          originalPrice: stats[0]['originalPrice'],
          discountedPrice: stats[0]['discountedPrice'],
          description: stats[0]['description'],
          buttonText: stats[0]['buttonText'],
          progress: stats[0]['progress'],
          onButtonPressed: () {},
        ),
      ],
    );
  }
}
