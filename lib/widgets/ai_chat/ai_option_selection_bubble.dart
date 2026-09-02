import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/ai_chat_message_model.dart';
import '../../utils/theme.dart';

class AiOptionSelectionBubble extends StatelessWidget {
  final AiChatMessageModel message;
  final Function(String)? onOptionTap;

  const AiOptionSelectionBubble({
    super.key,
    required this.message,
    this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(520)),
      padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? CustomColors.purple : CustomColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(16)),
          topRight: Radius.circular(context.r(16)),
          bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
          bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
        ),
        border: Border.all(
          color: isMe ? CustomColors.purple : CustomColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.text.isNotEmpty) ...[
            Text(
              message.text,
              style: isMe
                  ? context.fonts.white14w600
                      .copyWith(fontWeight: FontWeight.w400)
                  : context.fonts.black14w400,
            ),
          ],
          if (message.options != null && message.options!.isNotEmpty) ...[
            context.verticalSpace(12),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: message.options!.map((option) {
                return InkWell(
                  onTap: () => onOptionTap?.call(option),
                  borderRadius: BorderRadius.circular(context.r(20)),
                  child: Container(
                    padding: context.appEdgeInsets(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: CustomColors.lightPurple,
                      borderRadius: BorderRadius.circular(context.r(20)),
                      border: Border.all(
                        color: CustomColors.purple.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.add,
                          size: context.sp(14),
                          color: CustomColors.purple,
                        ),
                        context.horizontalSpace(6),
                        Text(
                          option,
                          style: context.fonts.purple12w600,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
