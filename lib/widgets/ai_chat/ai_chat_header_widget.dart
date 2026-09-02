import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/theme.dart';

class AiChatHeaderWidget extends StatelessWidget {
  final String userName;
  final bool showBackButton;

  const AiChatHeaderWidget({
    super.key,
    required this.userName,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showBackButton) ...[
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: CustomColors.black,
              ),
              onPressed: () => context.pop(),
            ),
            context.horizontalSpace(8),
          ],
          Container(
            padding: context.appEdgeInsets(all: 10),
            decoration: const BoxDecoration(
              color: CustomColors.lightPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Iconsax.magicpen,
              size: context.sp(22),
              color: CustomColors.purple,
            ),
          ),
          context.horizontalSpace(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Onboarding Assistant',
                      style: context.fonts.black16w600,
                    ),
                    context.horizontalSpace(8),
                    Container(
                      padding: context.appEdgeInsets(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(context.r(12)),
                      ),
                      child: Text(
                        'Active Session',
                        style: context.fonts.purple10w700,
                      ),
                    ),
                  ],
                ),
                context.verticalSpace(2),
                Text(
                  'Assisting Dr. $userName in setup & configuration',
                  style: context.fonts.grey12w400,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
