import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../main.dart';
import '../models/responses/login_response_model.dart';
import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';
import 'app_network_image.dart';

class TreatmentContainer extends StatelessWidget {
  final double? imageHeight;
  final double? width;
  final DashboardTreatmentModel? treatment;

  const TreatmentContainer({
    super.key,
    this.treatment,
    this.imageHeight,
    this.width,
  });

  Widget? _buildLeftIcon(BuildContext context, String? iconKey) {
    if (iconKey == null || iconKey.isEmpty) {
      return null;
    }

    return Container(
      margin: EdgeInsets.only(bottom: context.h(4)),
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
        imageUrl: iconKey,
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
    final titleText = treatment?.name ?? '';

    final subtitleText = treatment?.shortDescription ?? '';

    final bgImage = treatment?.image ?? '';

    final iconKey = treatment?.icon;

    final iconWidget = _buildLeftIcon(
      context,
      iconKey,
    );

    final globalSku = treatment?.sku ?? '';

    return GestureDetector(
      onTap: () {
        // Handle treatment tap here.
        //
        // Example:
        //
        // if (treatment == null) return;
        //
        // Navigator.pushNamed(
        //   context,
        //   TreatmentDetailScreen.routeName,
        //   arguments: treatment,
        // );
      },
      child: Container(
        height: imageHeight ?? context.h(300),
        width: width ?? context.w(400),
        margin: EdgeInsets.only(
          bottom: context.h(16),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            context.r(20),
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.purpleColor.withValues(
                alpha: 0.12,
              ),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.05,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            context.r(20),
          ),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: AppNetworkImage(
                  imageUrl: bgImage,
                  fit: BoxFit.cover,
                  placeholderColor: Colors.transparent,
                ),
              ),

              // White Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(
                          alpha: 0.20,
                        ),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),

              // Content
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.w(22),
                    context.h(12),
                    context.w(22),
                    context.h(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            Text(
                              titleText,
                              style: CustomFonts.black22w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (subtitleText.isNotEmpty) ...[
                              SizedBox(
                                height: context.h(6),
                              ),
                              Text(
                                subtitleText,
                                style: CustomFonts.grey12w400,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ],

                            if (globalSku.isNotEmpty) ...[
                              SizedBox(
                                height: context.h(6),
                              ),
                              Text(
                                "SKU: $globalSku",
                                style:
                                    CustomFonts.grey12w400.copyWith(
                                  fontSize: context.sp(10),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(
                        width: context.w(10),
                      ),

                      // Arrow
                      Container(
                        padding: EdgeInsets.all(
                          context.w(10),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(
                            alpha: 0.05,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black12,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.02,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.black87,
                          size: context.sp(22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Treatment Icon
              if (iconWidget != null)
                Positioned(
                  top: context.h(12),
                  left: context.w(12),
                  child: iconWidget,
                ),

              // Info Button
              if (treatment != null)
                Visibility(
                  visible: !isDeploymentMode,
                  child: Positioned(
                    top: context.h(12),
                    right: context.w(12),
                    child: GestureDetector(
                      onTap: () {
                        // Handle info button tap.
                        //
                        // Example:
                        //
                        // Navigator.pushNamed(
                        //   context,
                        //   TreatmentDetailScreen.routeName,
                        //   arguments: treatment,
                        // );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(
                          context.w(6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(
                            alpha: 0.4,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: context.sp(16),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}