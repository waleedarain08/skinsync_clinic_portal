import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/chat_appointment_model.dart';
import '../../models/chat_message_model.dart';
import '../../screens/dashboard/appointment_screen.dart';
import '../../utils/theme.dart';

class AppointmentChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const AppointmentChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final data = message.appointmentData;

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
          color: CustomColors.blue.withValues(alpha: 0.4),
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
                      color: CustomColors.softGrey,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.calendar,
                      size: context.sp(16),
                      color: CustomColors.blue,
                    ),
                  ),
                  context.horizontalSpace(8),
                  Text(
                    'Appointment Details',
                    style: context.fonts.black13w600,
                  ),
                ],
              ),
              if (data != null)
                Container(
                  padding: context.appEdgeInsets(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: CustomColors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Text(
                    data.status,
                    style: context.fonts.green11w600,
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
                  _buildDetailRow(context, 'Service:', data.serviceName),
                  context.verticalSpace(4),
                  _buildDetailRow(context, 'Date & Time:', '${data.date} at ${data.time}'),
                  context.verticalSpace(4),
                  _buildDetailRow(context, 'Provider:', data.practitionerName),
                ],
              ),
            ),
            context.verticalSpace(12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(AppointmentScreen.routeName);
                },
                icon: Icon(
                  Iconsax.calendar_1,
                  size: context.sp(16),
                  color: CustomColors.white,
                ),
                label: const Text('View Appointment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.purple,
                  foregroundColor: CustomColors.white,
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
