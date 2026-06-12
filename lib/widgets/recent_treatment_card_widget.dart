import 'package:flutter/material.dart';

import '../utils/theme.dart';

class RecentTreatmentCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String image;
  final String nextAppointment;

  const RecentTreatmentCardWidget({
    super.key,
    required this.title,
    required this.date,
    required this.image,
    required this.nextAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.r(12)),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: CustomColors.softGrey,
                    child: const Icon(Icons.broken_image, color: CustomColors.grey),
                  ),
                ),
              ),
              Positioned(
                top: context.h(12),
                right: context.w(12),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.w(10),
                    vertical: context.h(8),
                  ),
                  decoration: BoxDecoration(
                    color: CustomColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    nextAppointment,
                    style: CustomFonts.black12w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.h(10)),
        Text(
          title,
          style: CustomFonts.black18w600,
          maxLines: 1,
        ),
        SizedBox(height: context.h(6)),
        Text(
          date,
          style: CustomFonts.grey14w400,
          maxLines: 1,
        ),
        SizedBox(height: context.h(6)),
        Row(
          children: [
            Text(
              "AED 800 AED 650",
              style: CustomFonts.grey14w400,
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}
