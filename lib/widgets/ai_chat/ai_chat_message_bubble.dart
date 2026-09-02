import 'package:flutter/material.dart';

import '../../models/ai_chat_message_model.dart';
import '../../utils/enums.dart';
import '../../utils/theme.dart';
import 'ai_option_selection_bubble.dart';
import 'ai_text_chat_bubble.dart';
import 'ai_treatment_draft_bubble.dart';

class AiChatMessageBubble extends StatelessWidget {
  final AiChatMessageModel message;
  final Function(String)? onOptionTap;

  const AiChatMessageBubble({
    super.key,
    required this.message,
    this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: context.h(16)),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: context.h(4)),
              child: Text(
                '${message.senderName}, ${message.time}',
                style: context.fonts.grey11w400,
              ),
            ),
            _buildTypedBubble(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTypedBubble(BuildContext context) {
    return switch (message.messageType) {
      AiChatMessageType.text || AiChatMessageType.question => AiTextChatBubble(message: message),
      AiChatMessageType.optionSelection => AiOptionSelectionBubble(
          message: message,
          onOptionTap: onOptionTap,
        ),
      AiChatMessageType.treatmentDraft => AiTreatmentDraftBubble(message: message),
    };
  }
}
