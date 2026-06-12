import 'package:flutter/material.dart';

import '../utils/theme.dart';

class TreatmentCardWidget extends StatelessWidget {
  final String title;
  final String date;
  final String? price;
  final String image;

  const TreatmentCardWidget({
    super.key,
    required this.title,
    required this.date,
    this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ClipRRect(
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
        ),
        SizedBox(height: context.h(10)),
        Row(
          children: [
            Text(
              title,
              style: CustomFonts.black18w600,
            ),
            if (price != null) ...[
              SizedBox(width: context.w(8)),
              Text(
                price!,
                style: CustomFonts.black18w600,
              ),
            ],
          ],
        ),
        SizedBox(height: context.h(6)),
        Text(
          date,
          style: CustomFonts.grey14w400,
        ),
        SizedBox(height: context.h(6)),
        Row(
          children: [
            Icon(Icons.attach_file, size: context.r(14), color: CustomColors.grey),
            SizedBox(width: context.w(4)),
            Text(
              "Attached AI Model",
              style: CustomFonts.grey14w400,
            ),
          ],
        ),
      ],
    );
  }
}
