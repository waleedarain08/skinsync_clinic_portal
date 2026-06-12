import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../../utils/assets.dart';
import '../../widgets/ai_row_widget.dart';
import '../../widgets/analytics_grid_widget.dart';
import '../../widgets/appointments_list_widget.dart';
import '../../widgets/recent_clients_widget.dart';
import '../../widgets/recent_treatment_row_widget.dart';
import '../../widgets/welcome_banner_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  HomeScreen({super.key});

  final List<Map<String, dynamic>> treatmentStats = [
    {
      'revenue': '\$28k+',
      'percentage': '88%',
      'percentageChange': '+6%',
      'mainLabel': 'Sales Improve',
      'treatmentName': 'Botox Treatment',
      'originalPrice': '\$240',
      'discountedPrice': '\$220',
      'description':
          'Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development to fill empty.',
      'buttonText': 'Update Pricing',
      'progress': 0.88,
    },
    {
      'revenue': '\$32k+',
      'percentage': '92%',
      'percentageChange': '+8%',
      'mainLabel': 'Revenue Growth',
      'treatmentName': 'Laser Treatment',
      'originalPrice': '\$350',
      'discountedPrice': '\$310',
      'description':
          'Advanced laser technology for skin rejuvenation and treatment. Experience professional care with visible results and satisfaction.',
      'buttonText': 'Update Pricing',
      'progress': 0.92,
    },
    {
      'revenue': '\$25k+',
      'percentage': '85%',
      'percentageChange': '+5%',
      'mainLabel': 'Customer Satisfaction',
      'treatmentName': 'Facial Treatment',
      'originalPrice': '\$180',
      'discountedPrice': '\$160',
      'description':
          'Rejuvenating facial treatments designed to refresh and revitalize your skin with premium products and expert techniques.',
      'buttonText': 'Update Pricing',
      'progress': 0.85,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.w(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              const WelcomeBannerWidget(),
              SizedBox(height: context.h(24)),

              // Analytics Section
              Container(
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withValues(alpha: 0.12),
                      blurRadius: context.r(8),
                      offset: Offset(0, context.h(2)),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(context.r(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Analytics",
                      style: context.fonts.black20w600.copyWith(fontSize: context.sp(22)),
                    ),
                    SizedBox(height: context.h(16)),
                    const AnalyticsGridWidget(),
                  ],
                ),
              ),
              SizedBox(height: context.h(32)),
              // Upcoming Appointments Section
              Container(
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withValues(alpha: 0.12),
                      blurRadius: context.r(8),
                      offset: Offset(0, context.h(2)),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(context.r(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Upcoming Appointments",
                            style: context.fonts.black20w600.copyWith(fontSize: context.sp(22)),
                          ),
                        ),
                        SizedBox(width: context.w(20)),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: context.fonts.black14w500.copyWith(color: CustomColors.black.withValues(alpha: 0.87)),
                              ),
                              SizedBox(width: context.w(6)),
                              Icon(
                                CupertinoIcons.arrow_right,
                                size: context.sp(14),
                                color: CustomColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(18)),
                    const AppointmentsListWidget(),
                  ],
                ),
              ),
              SizedBox(height: context.h(30)),
              const RecentClientsWidget(),
              SizedBox(height: context.h(30)),
              Container(
                padding: EdgeInsets.all(context.w(20)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withValues(alpha: 0.12),
                      blurRadius: context.r(8),
                      offset: Offset(0, context.h(2)),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(context.r(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          SvgAssets.aiStar,
                          width: context.w(19),
                          height: context.w(19),
                        ),
                        SizedBox(width: context.w(8)),
                        Text(
                          "Ai recommendations",
                          style: context.fonts.black20w600.copyWith(fontSize: context.sp(22)),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(18)),
                    AiRowWidget(stats: treatmentStats),
                  ],
                ),
              ),
              SizedBox(height: context.h(30)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(20)),
                decoration: BoxDecoration(
                  color: CustomColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.black.withValues(alpha: 0.12),
                      blurRadius: context.r(8),
                      offset: Offset(0, context.h(2)),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(context.r(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Treatments",
                          style: context.fonts.black20w600.copyWith(fontSize: context.sp(22)),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                "View All",
                                style: context.fonts.black14w500.copyWith(color: CustomColors.black.withValues(alpha: 0.87)),
                              ),
                              SizedBox(width: context.w(6)),
                              Icon(
                                CupertinoIcons.arrow_right,
                                size: context.sp(14),
                                color: CustomColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(18)),
                    const RecentTreatmentRowWidget(),
                  ],
                ),
              ),
              SizedBox(height: context.h(30)),
            ],
          ),
        ),
      ),
    );
  }
}
