import 'package:flutter/material.dart';

import '../../models/ai_chat_message_model.dart';
import '../../utils/theme.dart';

class AiTreatmentDraftBubble extends StatelessWidget {
  final AiChatMessageModel message;

  const AiTreatmentDraftBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final draft = message.treatmentDraftData;

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
            context.verticalSpace(12),
          ],
          if (draft != null) _buildDraftCard(context, draft),
        ],
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, AiTreatmentDraftData draft) {
    return Container(
      padding: context.appEdgeInsets(all: 14),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                draft.treatmentName,
                style: context.fonts.purple14w700,
              ),
              Container(
                padding: context.appEdgeInsets(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: CustomColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.r(12)),
                ),
                child: Text(
                  'AI Draft',
                  style: context.fonts.green11w600,
                ),
              ),
            ],
          ),
          context.verticalSpace(8),
          _buildDraftRow(context, 'Category:',
              '${draft.category} (${draft.subcategory})'),
          context.verticalSpace(4),
          _buildDraftRow(context, 'Base Price:', draft.price),
          context.verticalSpace(4),
          _buildDraftRow(context, 'Downtime:', draft.downtime),
          context.verticalSpace(4),
          _buildDraftRow(context, 'Allowed Roles:', draft.allowedRoles),
        ],
      ),
    );
  }

  Widget _buildDraftRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: context.w(100),
          child: Text(
            label,
            style: context.fonts.grey12w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.fonts.black12w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
