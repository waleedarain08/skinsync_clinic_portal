import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/theme.dart';
import '../view_models/patient_view_model.dart';
import 'borderd_container_widget.dart';
import 'dialog_box/patient_progress_detail_dialog.dart';

class PatientTreatmentProgressWidget extends ConsumerWidget {
  const PatientTreatmentProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider);
    final apiList = patientState.treatmentProgressList;

    final progressList = apiList
        .map((item) => ProgressCardData(
              treatmentName: item.treatmentName ?? 'Treatment',
              area: item.areaName ?? 'Area',
              progress: item.progress ?? 0.0,
              completedSteps: item.completedSteps ?? 0,
              totalSteps: item.totalSteps ?? 0,
              status: item.status ?? 'IN PROGRESS',
              events: item.events
                  .map((e) => ProgressEvent(
                        title: e.title,
                        date: e.date,
                        time: e.time,
                        doctorName: e.doctorName,
                        clinicName: e.clinicName,
                        isCompleted: e.isCompleted,
                      ))
                  .toList(),
            ))
        .toList();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.donut_large_rounded,
                color: CustomColors.purple,
                size: 22,
              ),
              context.horizontalSpace(10),
              Text('Treatment Progress', style: context.fonts.subHeading),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          if (patientState.progressLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (progressList.isEmpty)
            Padding(
              padding: context.appEdgeInsets(vertical: 32),
              child: Center(
                child: Text(
                  'No treatment progress found for this patient.',
                  style: context.fonts.grey14w400,
                ),
              ),
            )
          else
            ...progressList.map(
              (item) => InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => PatientProgressDetailDialog(
                      treatmentName: item.treatmentName,
                      areaName: item.area,
                      progress: item.progress,
                      completedSteps: item.completedSteps,
                      totalSteps: item.totalSteps,
                      events: item.events,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(context.r(16)),
                child: Container(
                  margin: EdgeInsets.only(bottom: context.h(16)),
                  padding: context.appEdgeInsets(all: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.border),
                    borderRadius: BorderRadius.circular(context.r(16)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.treatmentName,
                                  style: context.fonts.black16w600,
                                ),
                                context.verticalSpace(2),
                                Text(
                                  'Target Area: ${item.area}',
                                  style: context.fonts.grey12w400,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: (item.status == 'COMPLETED'
                                      ? CustomColors.green
                                      : CustomColors.purple)
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(context.r(16)),
                            ),
                            child: Text(
                              item.status,
                              style: item.status == 'COMPLETED'
                                  ? context.fonts.green10w600
                                  : context.fonts.purple12w700,
                            ),
                          ),
                        ],
                      ),
                      context.verticalSpace(16),

                      // Progress Percentage Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.completedSteps} of ${item.totalSteps} steps completed',
                            style: context.fonts.grey12w400,
                          ),
                          Text(
                            '${(item.progress * 100).toInt()}%',
                            style: context.fonts.black14w600,
                          ),
                        ],
                      ),
                      context.verticalSpace(8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(context.r(4)),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: context.h(8),
                          backgroundColor: Colors.grey.shade100,
                          color: CustomColors.purple,
                        ),
                      ),
                      context.verticalSpace(16),

                      // Step Dots Indicator
                      Row(
                        children: List.generate(item.events.length, (index) {
                          final event = item.events[index];
                          final isLast = index == item.events.length - 1;

                          return Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: context.w(12),
                                  height: context.w(12),
                                  decoration: BoxDecoration(
                                    color: event.isCompleted
                                        ? CustomColors.purple
                                        : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: event.isCompleted
                                          ? CustomColors.purple
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      context.verticalSpace(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Click to view detailed timeline',
                            style: context.fonts.purple12w700,
                          ),
                          context.horizontalSpace(4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: CustomColors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressCardData {
  final String treatmentName;
  final String area;
  final double progress;
  final int completedSteps;
  final int totalSteps;
  final String status;
  final List<ProgressEvent> events;

  ProgressCardData({
    required this.treatmentName,
    required this.area,
    required this.progress,
    required this.completedSteps,
    required this.totalSteps,
    required this.status,
    required this.events,
  });
}
