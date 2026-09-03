import 'package:flutter/material.dart';

import '../../models/responses/messages_response.dart';
import '../../utils/date_time_utills.dart';
import '../../utils/enums.dart';
import '../../utils/theme.dart';
import 'appointment_chat_bubble.dart';
import 'document_chat_bubble.dart';
import 'media_chat_bubble.dart';
import 'normal_chat_bubble.dart';
import 'shared_request_chat_bubble.dart';

class ChatMessageBubble extends StatelessWidget {
  final Message message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: context.h(16)),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: context.h(4)),
              child: Text(
                '${message.senderName}, ${message.createdAt?.formattedDateTime}',
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
    return switch (message.type) {
      null => const SizedBox.shrink(),
      MessageType.text => NormalChatBubble(message: message),
      MessageType.media => MediaChatBubble(message: message),
      MessageType.document => DocumentChatBubble(message: message),
      MessageType.sharedRequest => SharedRequestChatBubble(message: message),
      MessageType.appointment => AppointmentChatBubble(message: message),
    };
  }
}
