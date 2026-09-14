import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/responses/messages_response.dart';
import '../../screens/dashboard/appointment_screen.dart';
import '../../utils/theme.dart';

class AppointmentChatBubble extends StatelessWidget {
  final Message message;

  const AppointmentChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final data = message.appointmentData;

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(450)),
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
          color: CustomColors.purple.withValues(alpha: 0.3),
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
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.calendar_tick,
                      size: context.sp(16),
                      color: CustomColors.purple,
                    ),
                  ),
                  context.horizontalSpace(8),
                  Text('Appointment Confirmed',
                      style: context.fonts.black13w600),
                ],
              ),
              if (data != null && data.status.isNotEmpty)
                Container(
                  padding: context.appEdgeInsets(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Text(
                    data.status.toUpperCase(),
                    style: context.fonts.purple11w600,
                  ),
                ),
            ],
          ),
          context.verticalSpace(12),
          if (data != null) ...[
            Container(
              padding: context.appEdgeInsets(all: 12),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.circular(context.r(10)),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.patientName.isNotEmpty) ...[
                    _buildDetailRow(context, 'Patient:', data.patientName),
                    context.verticalSpace(6),
                  ],
                  if (data.serviceName.isNotEmpty) ...[
                    _buildDetailRow(context, 'Service:', data.serviceName),
                    context.verticalSpace(6),
                  ],
                  if (data.date.isNotEmpty) ...[
                    _buildDetailRow(
                      context,
                      'Date & Time:',
                      data.time.isNotEmpty
                          ? '${data.date} at ${data.time}'
                          : data.date,
                    ),
                    context.verticalSpace(6),
                  ],
                  if (data.practitionerName.isNotEmpty) ...[
                    _buildDetailRow(
                        context, 'Provider:', data.practitionerName),
                  ],
                ],
              ),
            ),
            context.verticalSpace(12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(AppointmentScreen.routeName);
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
          ] else if (message.content?.isNotEmpty ?? false) ...[
            Text(message.content!, style: context.fonts.black14w400),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: context.w(85),
          child: Text(label, style: context.fonts.grey12w500),
        ),
        Expanded(
          child: Text(
            value,
            style: context.fonts.black12w600,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
