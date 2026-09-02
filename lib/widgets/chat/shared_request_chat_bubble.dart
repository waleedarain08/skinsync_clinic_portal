import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/dummy/chat_dummy_model.dart';
import '../../screens/dashboard/shared_treatment_request_screen.dart';
import '../../utils/theme.dart';

class SharedRequestChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const SharedRequestChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final data = message.sharedRequestData;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(500)),
      padding: context.appEdgeInsets(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.r(16)),
          topRight: Radius.circular(context.r(16)),
          bottomLeft: Radius.circular(isMe ? context.r(16) : context.r(2)),
          bottomRight: Radius.circular(isMe ? context.r(2) : context.r(16)),
        ),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: context.appEdgeInsets(all: 6),
                    decoration: const BoxDecoration(
                      color: CustomColors.lightPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.profile_2user,
                      size: context.sp(16),
                      color: CustomColors.purple,
                    ),
                  ),
                  context.horizontalSpace(8),
                  Text(
                    'Shared Treatment Request',
                    style: context.fonts.purple13w700,
                  ),
                ],
              ),
              if (data != null)
                Container(
                  padding: context.appEdgeInsets(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: CustomColors.palePurple,
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Text(
                    data.status,
                    style: context.fonts.purple11w600,
                  ),
                ),
            ],
          ),
          context.verticalSpace(10),
          if (message.text.isNotEmpty) ...[
            Text(
              message.text,
              style: context.fonts.black14w400,
            ),
            context.verticalSpace(10),
          ],
          if (data != null) ...[
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(10)),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(context, 'Patient:', data.patientName),
                  context.verticalSpace(4),
                  _buildDetailRow(context, 'Treatment:', data.treatmentName),
                  context.verticalSpace(4),
                  _buildDetailRow(context, 'Clinic:', data.clinicName),
                  context.verticalSpace(4),
                  _buildDetailRow(context, 'Shared Date:', data.dateShared),
                ],
              ),
            ),
            context.verticalSpace(12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    SharedTreatmentRequestScreen.routeName,
                    queryParameters: {'showBackButton': 'true'},
                  );
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  size: context.sp(16),
                  color: CustomColors.purple,
                ),
                label: Text(
                  'View Shared Request',
                  style: context.fonts.purple13w700,
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: CustomColors.purple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  padding: context.appEdgeInsets(vertical: 10),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: context.w(80),
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
