import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'treatment_container.dart';

class TreatmentListWidget extends ConsumerWidget {
  const TreatmentListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatmentList =
        ref.watch(authViewModelProvider).dashboard?.treatments ?? [];

    // Return centered empty state card when treatment list is empty
    if (treatmentList.isEmpty) {
      return Center(
        child: _buildHorizontalEmptyState(
          context: context,
          height: context.h(110),
          width: context.w(420),
          icon: Icons.healing_outlined,
          title: 'No Treatments Available',
          subtitle: 'There are no active treatments recorded at the moment.',
        ),
      );
    }

    // Render list view when data exists
    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        treatmentList.length,
        (index) {
          return TreatmentContainer(
            treatment: treatmentList[index],
          );
        },
      ),
    );
  }

  Widget _buildHorizontalEmptyState({
    required BuildContext context,
    required double height,
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const myLocalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        CustomColors.lightPurple,
        CustomColors.purpleColor,
      ],
    );

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(24)),
        gradient: myLocalGradient,
        border: Border.all(
          color: CustomColors.lightPurple.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(22)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(8),
              ),
              child: Row(
                children: [
                  Container(
                    height: context.w(44),
                    width: context.w(44),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CustomColors.purpleColor.withValues(
                          alpha: 0.15,
                        ),
                        width: context.w(1),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: CustomColors.purpleColor,
                        size: context.sp(20),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: CustomFonts.black14w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          subtitle,
                          style: CustomFonts.grey12w400,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}