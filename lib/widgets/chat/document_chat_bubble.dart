import 'package:flutter/material.dart';

import '../../models/chat_message_model.dart';
import '../../utils/theme.dart';

class DocumentChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const DocumentChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(480)),
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
            context.verticalSpace(10),
          ],
          Container(
            padding: context.appEdgeInsets(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? CustomColors.white.withValues(alpha: 0.15)
                  : CustomColors.softGrey,
              borderRadius: BorderRadius.circular(context.r(10)),
              border: Border.all(
                color: isMe
                    ? CustomColors.white.withValues(alpha: 0.3)
                    : CustomColors.border,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf_rounded,
                  size: context.sp(26),
                  color: isMe ? CustomColors.white : CustomColors.purple,
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.documentName ?? 'Document.pdf',
                        style: isMe
                            ? context.fonts.white12w700
                            : context.fonts.black12w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (message.documentSize != null)
                        Text(
                          message.documentSize!,
                          style: isMe
                              ? context.fonts.white10w600
                              : context.fonts.grey10w400,
                        ),
                    ],
                  ),
                ),
                context.horizontalSpace(8),
                Icon(
                  Icons.download_rounded,
                  size: context.sp(20),
                  color: isMe ? CustomColors.white : CustomColors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
