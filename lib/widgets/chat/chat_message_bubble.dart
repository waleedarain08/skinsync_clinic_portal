import 'package:flutter/material.dart';

import '../../models/dummy/chat_dummy_model.dart';
import '../../utils/enums.dart';
import '../../utils/theme.dart';
import 'appointment_chat_bubble.dart';
import 'document_chat_bubble.dart';
import 'media_chat_bubble.dart';
import 'normal_chat_bubble.dart';
import 'shared_request_chat_bubble.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({super.key, required this.message});

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
            if (isMe) ...[
              context.verticalSpace(4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    message.isRead
                        ? Icons.done_all_rounded
                        : Icons.check_rounded,
                    size: context.sp(14),
                    color: CustomColors.purple,
                  ),
                  context.horizontalSpace(4),
                  Text(
                    message.isRead ? 'Read' : 'Sent',
                    style: context.fonts.purple11w600,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypedBubble(BuildContext context) {
    return switch (message.messageType) {
      ChatMessageType.text || ChatMessageType.normal => NormalChatBubble(message: message),
      ChatMessageType.media => MediaChatBubble(message: message),
      ChatMessageType.document => DocumentChatBubble(message: message),
      ChatMessageType.sharedRequest => SharedRequestChatBubble(message: message),
      ChatMessageType.appointment => AppointmentChatBubble(message: message),
    };
  }
}
