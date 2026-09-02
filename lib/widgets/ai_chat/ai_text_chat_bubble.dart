import 'package:flutter/material.dart';

import '../../models/ai_chat_message_model.dart';
import '../../utils/theme.dart';

class AiTextChatBubble extends StatelessWidget {
  final AiChatMessageModel message;

  const AiTextChatBubble({super.key, required this.message});

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
      child: Text(
        message.text,
        style: isMe
            ? context.fonts.white14w600.copyWith(fontWeight: FontWeight.w400)
            : context.fonts.black14w400,
      ),
    );
  }
}
