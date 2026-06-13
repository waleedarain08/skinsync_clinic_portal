import 'package:flutter/material.dart';

import '../app_init.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'app_loader.dart';

class TreatmentStatsCard extends StatelessWidget {
  final String revenue;
  final String percentage;
  final String percentageChange;
  final String mainLabel;
  final String treatmentName;
  final String originalPrice;
  final String discountedPrice;
  final String description;
  final String buttonText;
  final double progress;
  final Gradient cardGradient;
  final VoidCallback? onButtonPressed;

  const TreatmentStatsCard({
    super.key,
    required this.revenue,
    required this.percentage,
    required this.percentageChange,
    required this.mainLabel,
    required this.treatmentName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.description,
    required this.buttonText,
    required this.progress,
    this.cardGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xff92FFCE), Color(0xffD8FFED)],
    ),
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: navigatorKey.currentContext!.isLandscape
          ? context.r(350)
          : MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(
        vertical: context.h(25),
        horizontal: context.w(28),
      ),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(context.r(24)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Circle Progress and Stats
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Progress Indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  AppLoader(size: context.r(85), value: progress),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(revenue, style: CustomFonts.black16w600),
                      Text('Revenue', style: CustomFonts.black10w600),
                    ],
                  ),
                ],
              ),
              SizedBox(width: context.w(24)),
              // Percentage Stats
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            percentage,
                            style: CustomFonts.black20w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: context.w(6)),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: context.h(6)),
                            child: Text(
                              percentageChange,
                              style: TextStyle(
                                fontSize: context.sp(17),
                                height: 0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF66BB6A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(4)),
                    Text(
                      mainLabel,
                      style: TextStyle(
                        fontSize: context.sp(17),
                        height: 0,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(19)),
          // Treatment Name and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  treatmentName,
                  style: TextStyle(
                    fontSize: context.sp(22),
                    height: 0,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: context.w(8)),
              Flexible(
                child: Text(
                  "AED $originalPrice > AED $discountedPrice",
                  style: TextStyle(
                    fontSize: context.sp(17),
                    fontWeight: FontWeight.w500,
                    color: CustomColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          // Description
          Text(
            description,
            style: CustomFonts.grey16w400,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.h(20)),
          // Button
          GestureDetector(
            onTap: onButtonPressed,
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: context.h(16),
                horizontal: context.w(28),
              ),
              decoration: BoxDecoration(
                color: CustomColors.black,
                borderRadius: BorderRadius.circular(context.r(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      buttonText,
                      style: CustomFonts.white14w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: context.w(8)),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: CustomColors.white,
                    size: context.r(18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
