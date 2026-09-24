import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class ProgressEvent {
  final String title;
  final String? date;
  final String? time;
  final String? doctorName;
  final String? clinicName;
  final bool isCompleted;

  ProgressEvent({
    required this.title,
    this.date,
    this.time,
    this.doctorName,
    this.clinicName,
    required this.isCompleted,
  });
}

class PatientProgressDetailDialog extends StatelessWidget {
  final String treatmentName;
  final String areaName;
  final double progress;
  final int completedSteps;
  final int totalSteps;
  final List<ProgressEvent> events;

  const PatientProgressDetailDialog({
    super.key,
    required this.treatmentName,
    required this.areaName,
    required this.progress,
    required this.completedSteps,
    required this.totalSteps,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(24)),
      ),
      child: Container(
        width: context.w(520),
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.donut_large_rounded,
                        color: CustomColors.purple,
                        size: 22,
                      ),
                    ),
                    context.horizontalSpace(12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treatmentName,
                          style: context.fonts.black18w600,
                        ),
                        Text(
                          'Target Area: $areaName',
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: CustomColors.grey),
                ),
              ],
            ),
            const Divider(color: CustomColors.border, height: 32),

            // Progress Bar Summary Box
            Container(
              padding: context.appEdgeInsets(all: 16),
              decoration: BoxDecoration(
                color: CustomColors.whiteGrey,
                borderRadius: BorderRadius.circular(context.r(16)),
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$completedSteps of $totalSteps steps completed',
                        style: context.fonts.black14w600,
                      ),
                      Text(
                        '${(progress * 100).toInt()}% Done',
                        style: context.fonts.purple12w700,
                      ),
                    ],
                  ),
                  context.verticalSpace(8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.r(4)),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: context.h(8),
                      backgroundColor: Colors.grey.shade200,
                      color: CustomColors.purple,
                    ),
                  ),
                ],
              ),
            ),
            context.verticalSpace(24),

            Text(
              'Detailed Progress Timeline',
              style: context.fonts.black16w600,
            ),
            context.verticalSpace(16),

            // Timeline Items
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(events.length, (index) {
                    final event = events[index];
                    final isLast = index == events.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: context.w(22),
                              height: context.w(22),
                              decoration: BoxDecoration(
                                color: event.isCompleted
                                    ? CustomColors.purple
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: event.isCompleted
                                      ? CustomColors.purple
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: event.isCompleted
                                  ? const Icon(
                                      Icons.check,
                                      size: 13,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: context.h(60),
                                color: Colors.grey.shade200,
                              ),
                          ],
                        ),
                        context.horizontalSpace(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    event.title,
                                    style: event.isCompleted
                                        ? context.fonts.black14w600
                                        : context.fonts.grey14w400,
                                  ),
                                  if (event.isCompleted)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CustomColors.green
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'COMPLETED',
                                        style: context.fonts.green10w600,
                                      ),
                                    ),
                                ],
                              ),
                              if (event.date != null) ...[
                                context.verticalSpace(2),
                                Text(
                                  'Date: ${event.date} ${event.time != null ? "• ${event.time}" : ""}',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                              if (event.doctorName != null) ...[
                                context.verticalSpace(4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 14,
                                      color: CustomColors.grey,
                                    ),
                                    context.horizontalSpace(4),
                                    Text(
                                      event.doctorName!,
                                      style: context.fonts.black12w600,
                                    ),
                                  ],
                                ),
                              ],
                              context.verticalSpace(20),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),

            context.verticalSpace(16),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: context.appEdgeInsets(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  side: const BorderSide(color: CustomColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.r(10)),
                  ),
                ),
                child: Text('Close', style: context.fonts.black14w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
