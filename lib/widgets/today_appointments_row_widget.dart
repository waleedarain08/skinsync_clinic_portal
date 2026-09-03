import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/dummy/appointment_dummy.dart';
import '../models/responses/appointment_list_response.dart';
import '../screens/dashboard/appointment_detail_screen.dart';
import '../screens/dashboard/appointment_screen.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';
import '../view_models/appointment_view_model.dart';
import 'borderd_container_widget.dart';

class TodayAppointmentsRowWidget extends ConsumerWidget {
  const TodayAppointmentsRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(appointmentProvider);
    final apiAppointments = appointmentState.appointmentList ?? [];

    // Combine or filter appointments: if API returns data, use it; otherwise fallback to dummy today's appointments
    final List<dynamic> todayList;
    if (apiAppointments.isNotEmpty) {
      todayList = apiAppointments;
    } else {
      todayList = dummyAppointments;
    }

    if (todayList.isEmpty) {
      return Center(
        child: _buildHorizontalEmptyState(
          context: context,
          height: context.h(101),
          width: context.w(400),
          icon: Icons.event_available_outlined,
          title: "No Appointments Today",
          subtitle: "There are no scheduled appointments for today.",
        ),
      );
    }

    return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(215),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(
        todayList.length,
        (index) {
          final item = todayList[index];
          return TodayAppointmentCardWidget(appointment: item);
        },
      ),
    );
  }

  Widget _buildHorizontalEmptyState({
    required BuildContext context,
    required double height,
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    const myLocalGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        CustomColors.lightPurple,
        CustomColors.purpleColor,
      ],
    );

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(24)),
        gradient: myLocalGradient,
        border: Border.all(
          color: CustomColors.lightPurple.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(22)),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(16),
                vertical: context.h(8),
              ),
              child: Row(
                children: [
                  Container(
                    height: context.w(44),
                    width: context.w(44),
                    decoration: BoxDecoration(
                      color: CustomColors.purpleColor.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CustomColors.purpleColor.withValues(
                          alpha: 0.15,
                        ),
                        width: context.w(1),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                        color: CustomColors.purpleColor,
                        size: context.sp(20),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: CustomFonts.black14w700,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          subtitle,
                          style: CustomFonts.grey12w400,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodayAppointmentCardWidget extends ConsumerWidget {
  final dynamic appointment;

  const TodayAppointmentCardWidget({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String patientName = '';
    String? patientImage;
    String appointmentType = 'Consultation';
    String treatmentName = '';
    String doctorName = '';
    String timeStr = '';
    String statusStr = 'Ongoing';
    Color statusColor = CustomColors.purple;
    int? appointmentId;
    double? amount;

    if (appointment is AppointmentData) {
      final a = appointment as AppointmentData;
      appointmentId = a.id;
      patientName = a.patientName ?? 'Unknown Patient';
      patientImage = a.patientImage;
      appointmentType = a.appointmentType ?? 'Consultation';
      treatmentName =
          a.bookingType ?? 'Botox (Lips), Botox (Cheeks), Dermal Filler (Eyes)';
      doctorName = a.doctorName ?? 'Staff Practitioner';
      timeStr =
          "${a.start.hour.toString().padLeft(2, '0')}:${a.start.minute.toString().padLeft(2, '0')}";
      statusStr = a.status ?? 'Ongoing';
      statusColor = _getBadgeColor(statusStr);
    } else if (appointment is AppointmentModel) {
      final a = appointment as AppointmentModel;
      patientName = a.patientName;
      appointmentType = a.appointmentType;
      treatmentName = a.treatment;
      doctorName = a.doctor;
      timeStr = a.time;
      statusStr = a.status.label;
      statusColor = a.status.color;
      amount = a.amount;
    }

    return BorderdContainerWidget(
      width: context.w(310),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.r(12)),
          onTap: () async {
            if (appointmentId != null) {
              await ref
                  .read(appointmentProvider.notifier)
                  .getAppointmentsDetail(id: appointmentId);
              if (context.mounted) {
                context.push(AppointmentDetailScreen.routeName);
              }
            } else {
              context.push(AppointmentScreen.routeName);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Row: Time Tag & Appointment Type + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Time Tag
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(8),
                              vertical: context.h(4),
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey,
                              borderRadius:
                                  BorderRadius.circular(context.r(12)),
                              border: Border.all(color: CustomColors.border),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: context.sp(12),
                                  color: CustomColors.grey,
                                ),
                                SizedBox(width: context.w(4)),
                                Text(
                                  timeStr,
                                  style: context.fonts.grey11w600,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: context.w(6)),

                          // Appointment Type Badge (e.g. Consultation / Session)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(8),
                              vertical: context.h(4),
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.lightPurple,
                              borderRadius:
                                  BorderRadius.circular(context.r(12)),
                              border: Border.all(
                                color: CustomColors.purple
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              appointmentType,
                              style: context.fonts.purple10w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(6)),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(10),
                      vertical: context.h(4),
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(context.r(20)),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      statusStr,
                      style: context.fonts.grey12w600.copyWith(
                        color: statusColor,
                        fontSize: context.sp(10),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(8)),

              // Patient Info Row
              Row(
                children: [
                  CircleAvatar(
                    radius: context.r(18),
                    backgroundColor: CustomColors.palePurple,
                    backgroundImage:
                        (patientImage != null && patientImage.isNotEmpty)
                            ? NetworkImage(patientImage)
                            : null,
                    child: (patientImage == null || patientImage.isEmpty)
                        ? Text(
                            patientName.isNotEmpty
                                ? patientName[0].toUpperCase()
                                : 'P',
                            style: context.fonts.purple12w700,
                          )
                        : null,
                  ),
                  SizedBox(width: context.w(10)),
                  Expanded(
                    child: Text(
                      patientName,
                      style: context.fonts.black14w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.h(8)),

              // Treatments & Areas Breakdown Box
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(10),
                  vertical: context.h(6),
                ),
                decoration: BoxDecoration(
                  color: CustomColors.softGrey.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.medical_services_outlined,
                      size: context.sp(14),
                      color: CustomColors.purple,
                    ),
                    SizedBox(width: context.w(6)),
                    Expanded(
                      child: Text(
                        treatmentName,
                        style: context.fonts.black12w600.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(8)),

              // Footer Row: Doctor & Amount / Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: context.sp(14),
                          color: CustomColors.grey,
                        ),
                        SizedBox(width: context.w(4)),
                        Expanded(
                          child: Text(
                            doctorName,
                            style: context.fonts.grey12w500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (amount != null) ...[
                    SizedBox(width: context.w(8)),
                    Text(
                      '\$${amount.toStringAsFixed(0)}',
                      style: context.fonts.purple14w600,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'arrived':
        return CustomColors.green;
      case 'ongoing':
        return Colors.blue;
      case 'delayed':
        return CustomColors.purple;
      case 'no_show':
      case 'no-show':
        return CustomColors.red;
      default:
        return CustomColors.purple;
    }
  }
}
