import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/color_constant.dart';
import '../utils/custom_fonts.dart';

class TodaysCheckInTile extends StatelessWidget {
  final String patientImage;
  final String name;
  final String email;
  final int appointmentId;
  final String appointmentRef;

  const TodaysCheckInTile({
    super.key,
    required this.patientImage,
    required this.name,
    required this.appointmentId,
    required this.email,
    required this.appointmentRef,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () async {
            // Navigation logic
          },
          child: Container(
            width: context.w(280),
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.r(12)),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Patient Avatar (Iconsax User Icon)
                Container(
                  width: context.r(44),
                  height: context.r(44),
                  decoration: BoxDecoration(
                    color: CustomColors.lightPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.user,
                    color: CustomColors.lightPurple,
                    size: context.sp(22),
                  ),
                ),
                SizedBox(width: context.w(10)),

                // Patient Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: CustomFonts.black16w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        email,
                        style: CustomFonts.grey14w400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(4)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(3),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.purple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(context.r(6)),
                        ),
                        child: Text(
                          'Ref: $appointmentRef',
                          style: TextStyle(
                            color: CustomColors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}