import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'app_network_image.dart';
import 'treatment_list_widget.dart';

class FrequentlyTreatmentContainer extends StatelessWidget {
  final double? imageHeight;
  final double? width;
  final FrequentlyTreatmentModel? treatment;

  const FrequentlyTreatmentContainer({
    super.key,
    this.treatment,
    this.imageHeight,
    this.width,
  });

Widget _buildLeftIcon(BuildContext context, String imageUrl) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(context.r(10)),
      border: Border.all(
        color: Colors.white,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
        ),
      ],
    ),
    child: AppNetworkImage(
      imageUrl: imageUrl,
      width: context.w(38),
      height: context.w(38),
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(context.r(10)),
      errorIcon: Icons.broken_image,
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final treatmentName = treatment?.treatmentName ?? '';
    final areaName = treatment?.areaName ?? '';
    final treatmentImage = treatment?.treatmentImage ?? '';
    final areaImage = treatment?.icon ?? '';

    final displayTitle = areaName.isNotEmpty
        ? '$treatmentName / $areaName'
        : treatmentName;

    return GestureDetector(
      onTap: () {
        // Handle treatment tap
      },
      child: Container(
        height: imageHeight ?? context.h(155),
        width: width ?? context.w(420),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(context.r(20)),
          boxShadow: [
            BoxShadow(
              color: CustomColors.purpleColor.withValues(alpha: 0.10),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.r(20)),
          child: Stack(
            children: [
              // Treatment Background Image
              Positioned.fill(
                child: AppNetworkImage(
                  imageUrl: treatmentImage,
                  fit: BoxFit.cover,
                  placeholderColor: Colors.transparent,
                ),
              ),

              // Bottom White Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.35,
                        0.65,
                        1.0,
                      ],
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),

              // Area Image / Icon
              if (areaImage.isNotEmpty)
                Positioned(
                  top: context.h(10),
                  left: context.w(10),
                  child: _buildLeftIcon(
                    context,
                    areaImage,
                  ),
                ),

              // Treatment / Area Name
              Positioned(
                left: context.w(18),
                right: context.w(18),
                bottom: context.h(16),
                child: Text(
                  displayTitle,
                  style: CustomFonts.black18w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}