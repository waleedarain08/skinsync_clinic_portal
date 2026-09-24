import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/theme.dart';
import '../view_models/patient_view_model.dart';
import 'borderd_container_widget.dart';

class PatientClinicalJourneyWidget extends ConsumerWidget {
  const PatientClinicalJourneyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider);
    final journeyData = patientState.clinicalJourneyData;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.alt_route_rounded,
                color: CustomColors.purple,
                size: 22,
              ),
              context.horizontalSpace(10),
              Text('Treatment Journey', style: context.fonts.subHeading),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),

          if (patientState.journeyLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (journeyData == null)
            Padding(
              padding: context.appEdgeInsets(vertical: 32),
              child: Center(
                child: Text(
                  'No clinical journey found for this patient.',
                  style: context.fonts.grey14w400,
                ),
              ),
            )
          else ...[
            // 1. Original Patient Request Card
            if (journeyData.patientRequest != null)
              _buildJourneyTimelineNode(
                context,
                isFirst: true,
                icon: Icons.description_outlined,
                child: _buildCard(
                  context,
                  title: 'Original Patient Request',
                  badgeText: journeyData.patientRequest?.status ?? 'REVIEWED',
                  badgeColor: CustomColors.purple,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Requested Treatments:',
                          style: context.fonts.grey12w400),
                      context.verticalSpace(8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: journeyData.patientRequest!.treatments
                            .map((t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CustomColors.whiteGrey,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: CustomColors.border),
                                  ),
                                  child:
                                      Text(t, style: context.fonts.black12w600),
                                ))
                            .toList(),
                      ),
                      if (journeyData.patientRequest?.preferredClinic != null) ...[
                        context.verticalSpace(12),
                        Text(
                          'Preferred Clinic: ${journeyData.patientRequest!.preferredClinic!}',
                          style: context.fonts.black14w400,
                        ),
                      ],
                      if (journeyData.patientRequest?.requestedOn != null) ...[
                        context.verticalSpace(4),
                        Text(
                          'Requested On: ${journeyData.patientRequest!.requestedOn!}',
                          style: context.fonts.grey12w400,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // 2. Doctor Finalized Plan Card
            if (journeyData.doctorFinalized != null)
              _buildJourneyTimelineNode(
                context,
                icon: Icons.verified_user_outlined,
                child: _buildCard(
                  context,
                  title: 'Doctor Finalized Plan',
                  badgeText: 'FINALIZED',
                  badgeColor: CustomColors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: CustomColors.softGrey,
                            child: Icon(Icons.person,
                                color: CustomColors.purple, size: 20),
                          ),
                          context.horizontalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                journeyData.doctorFinalized?.doctorName ??
                                    'Doctor',
                                style: context.fonts.black14w600,
                              ),
                              if (journeyData.doctorFinalized?.finalizedAt !=
                                  null)
                                Text(
                                  'Finalized On: ${journeyData.doctorFinalized!.finalizedAt!}',
                                  style: context.fonts.grey12w400,
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (journeyData.doctorFinalized?.note != null) ...[
                        context.verticalSpace(12),
                        Container(
                          padding: context.appEdgeInsets(all: 12),
                          decoration: BoxDecoration(
                            color: CustomColors.lightPurple,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  CustomColors.purple.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            journeyData.doctorFinalized!.note!,
                            style: context.fonts.black14w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // 3. Treatment Session Chronological Nodes
            if (journeyData.treatmentBranches.isNotEmpty)
              ...journeyData.treatmentBranches.map(
                (b) => _buildJourneyTimelineNode(
                  context,
                  icon: Icons.medical_services_outlined,
                  child: _buildCard(
                    context,
                    title:
                        '${b.treatmentName ?? "Treatment"} – ${b.area ?? "Area"}',
                    badgeText: b.status ?? 'COMPLETED',
                    badgeColor: CustomColors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (b.sessionName != null) ...[
                          Text(b.sessionName!,
                              style: context.fonts.black14w600),
                          context.verticalSpace(4),
                        ],
                        if (b.date != null) ...[
                          Text('Date: ${b.date!}',
                              style: context.fonts.grey12w400),
                          context.verticalSpace(8),
                        ],
                        Text(
                          '${b.appointmentKey != null ? "Appointment Key: ${b.appointmentKey!} • " : ""}${b.doctorName != null ? "Performed by ${b.doctorName!}" : ""}',
                          style: context.fonts.black14w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // 4. Overall Journey Status Banner
            _buildJourneyTimelineNode(
              context,
              isLast: true,
              icon: Icons.workspace_premium_rounded,
              child: Container(
                padding: context.appEdgeInsets(all: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CustomColors.purple, Color(0xFF6B46C1)],
                  ),
                  borderRadius: BorderRadius.circular(context.r(16)),
                  boxShadow: [
                    BoxShadow(
                      color: CustomColors.purple.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    context.verticalSpace(12),
                    Text(
                      'Clinical Journey (${journeyData.status ?? "Active"})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.verticalSpace(4),
                    Text(
                      'Requested on: ${journeyData.requestedAt ?? "N/A"}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJourneyTimelineNode(
    BuildContext context, {
    required Widget child,
    required IconData icon,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.w(36),
            child: Column(
              children: [
                Container(
                  width: context.w(32),
                  height: context.w(32),
                  decoration: BoxDecoration(
                    color: CustomColors.lightPurple,
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.purple, width: 1.5),
                  ),
                  child: Icon(icon, size: 16, color: CustomColors.purple),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: CustomColors.purple.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.h(24)),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String badgeText,
    required Color badgeColor,
    required Widget child,
  }) {
    return Container(
      padding: context.appEdgeInsets(all: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
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
              Text(title, style: context.fonts.black16w600),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: context.fonts.purple12w700
                      .copyWith(color: badgeColor, fontSize: 10),
                ),
              ),
            ],
          ),
          const Divider(color: CustomColors.border, height: 24),
          child,
        ],
      ),
    );
  }
}
