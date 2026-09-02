import 'package:flutter/material.dart';

import '../../models/dummy/chat_dummy_model.dart';
import '../../utils/theme.dart';

class MediaChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const MediaChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(480)),
      padding: context.appEdgeInsets(horizontal: 12, vertical: 12),
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
            Padding(
              padding: context.appEdgeInsets(horizontal: 4, bottom: 8),
              child: Text(
                message.text,
                style: isMe
                    ? context.fonts.white14w600
                        .copyWith(fontWeight: FontWeight.w400)
                    : context.fonts.black14w400,
              ),
            ),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: message.mediaUrl != null && message.mediaUrl!.isNotEmpty
                ? Image.network(
                    message.mediaUrl!,
                    width: double.infinity,
                    height: context.h(220),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholderImage(context),
                  )
                : _buildPlaceholderImage(context),
          ),
          if (message.mediaCaption != null &&
              message.mediaCaption!.isNotEmpty) ...[
            context.verticalSpace(8),
            Padding(
              padding: context.appEdgeInsets(horizontal: 4),
              child: Text(
                message.mediaCaption!,
                style: isMe
                    ? context.fonts.white12w400
                    : context.fonts.grey12w400,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.h(180),
      color: CustomColors.softGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: context.sp(40),
            color: CustomColors.grey,
          ),
          context.verticalSpace(8),
          Text(
            'Media Preview',
            style: context.fonts.grey12w400,
          ),
        ],
      ),
    );
  }
}
