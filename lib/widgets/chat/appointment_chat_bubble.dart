import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/responses/messages_response.dart';
import '../../screens/dashboard/appointment_detail_screen.dart';
import '../../utils/date_time_utills.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_view_model.dart';

class AppointmentChatBubble extends StatelessWidget {
  final Message message;

  const AppointmentChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final data = message.appointmentData;

    final statusText = data?.paymentType?.status ?? data?.bookingType;
    String dateStr = '';
    String timeStr = '';

    if (data != null) {
      if (data.date != null) {
        dateStr = DateTimeUtils.formatTimestamp(data.date!);
      }
      if (data.startTime != null && data.endTime != null) {
        timeStr = '${DateTimeUtils.formatTimestampToTime(data.startTime!)} - ${DateTimeUtils.formatTimestampToTime(data.endTime!)}';
      } else if (data.startTime != null) {
        timeStr = DateTimeUtils.formatTimestampToTime(data.startTime!);
      }
    }

    return Container(
      constraints: BoxConstraints(maxWidth: context.w(340)),
      padding: context.appEdgeInsets(horizontal: 14, vertical: 12),
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
                  Text('Appointment', style: context.fonts.black13w600),
                ],
              ),
              if (statusText != null && statusText.isNotEmpty)
                Container(
                  padding: context.appEdgeInsets(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(12)),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: context.fonts.purple11w600,
                  ),
                ),
            ],
          ),
          context.verticalSpace(10),
          if (data != null) ...[
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.circular(context.r(10)),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.patient?.id != null) ...[
                    _buildDetailRow(context, 'Patient ID:', data.patient!.id!.toString()),
                    context.verticalSpace(4),
                  ],
                  if (data.appointmentType?.id != null) ...[
                    _buildDetailRow(context, 'Type ID:', data.appointmentType!.id!.toString()),
                    context.verticalSpace(4),
                  ],
                  if (data.bookingType != null && data.bookingType!.isNotEmpty) ...[
                    _buildDetailRow(context, 'Booking:', data.bookingType!),
                    context.verticalSpace(4),
                  ],
                  if (dateStr.isNotEmpty) ...[
                    _buildDetailRow(context, 'Date:', dateStr),
                    context.verticalSpace(4),
                  ],
                  if (timeStr.isNotEmpty) ...[
                    _buildDetailRow(context, 'Time:', timeStr),
                    context.verticalSpace(4),
                  ],
                  if (data.doctor != null) ...[
                    _buildDetailRow(
                      context,
                      'Provider:',
                        'ID: ${data.doctor!.id} (${data.doctor!.specialization})'
                    ),
                    context.verticalSpace(4),
                  ],
                  if (data.treatments != null && data.treatments!.isNotEmpty) ...[
                    _buildDetailRow(
                      context,
                      'Treatments:',
                      data.treatments!.map((t) => 'TX: ${t.treatmentId}').join('\n'),
                    ),
                    context.verticalSpace(4),
                  ],
                  if (data.treatmentTotal != null) ...[
                    _buildDetailRow(context, 'Subtotal:', '\$${data.treatmentTotal!.toStringAsFixed(2)}'),
                    context.verticalSpace(4),
                  ],
                  if (data.discount != null && data.discount! > 0) ...[
                    _buildDetailRow(context, 'Discount:', '\$${data.discount!.toStringAsFixed(2)} (${data.discountType ?? ''})'),
                    context.verticalSpace(4),
                  ],
                  if (data.treatmentTotal != null) ...[
                    _buildDetailRow(context, 'Payable:', '\$${data.treatmentTotal!.toStringAsFixed(2)}'),
                    context.verticalSpace(4),
                  ],
                  // if (data. != null) ...[
                  //   _buildDetailRow(context, 'Paid:', '\$${data.amountPaid!.toStringAsFixed(2)}'),
                  //   context.verticalSpace(4),
                  // ],
                  if (data.paymentType != null) ...[
                    _buildDetailRow(context, 'Payment:', '${data.paymentType!.type} (${data.paymentType!.status})'),
                  ],
                ],
              ),
            ),
            context.verticalSpace(10),
            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (_, ref, _) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      ref.read(appointmentProvider.notifier).getAppointmentsDetail(id: data.id!);
                      context.push(AppointmentDetailScreen.routeName);
                    },
                    icon: Icon(
                      Iconsax.calendar_1,
                      size: context.sp(14),
                      color: CustomColors.white,
                    ),
                    label: const Text('View Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.purple,
                      foregroundColor: CustomColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.r(8)),
                      ),
                      padding: context.appEdgeInsets(vertical: 8),
                    ),
                  );
                }
              ),
            ),
          ] else if (message.content?.isNotEmpty ?? false) ...[
            Text('Appointment', style: context.fonts.black14w400),
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
          width: context.w(70),
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

