import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/responses/appointment_detail_response.dart';
import '../../utils/date_time_utills.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class AppointmentDetailScreen extends ConsumerWidget {
  static const String routeName = '/appointment-detail';

  const AppointmentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(appointmentProvider).appointmentDetail;

    if (appointment == null) {
      return const GradientScaffold(
        body: Center(child: AppLoader()),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Appointment #${appointment.appointmentKey ?? ""}',
          style: context.fonts.black18w600,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColors.black,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(800)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewHeader(context, appointment),
                context.verticalSpace(32),
                _buildSectionTitle(context, 'PATIENT INFORMATION'),
                context.verticalSpace(12),
                _buildPatientCard(context, appointment),
                context.verticalSpace(32),
                _buildSectionTitle(context, 'APPOINTMENT DETAILS'),
                context.verticalSpace(12),
                _buildAppointmentInfoCard(context, appointment),
                context.verticalSpace(32),
                if (appointment.treatments != null && appointment.treatments!.isNotEmpty) ...[
                  _buildSectionTitle(context, 'ASSIGNED TREATMENTS'),
                  context.verticalSpace(12),
                  _buildTreatmentsCard(context, appointment),
                  context.verticalSpace(32),
                ],
                //_buildSectionTitle(context, 'CLINIC INFORMATION'),
                // context.verticalSpace(12),
                // _buildClinicCard(context, appointment),
                context.verticalSpace(32),
                if (appointment.simulations != null) ...[
                  _buildSectionTitle(context, 'SIMULATIONS'),
                  context.verticalSpace(12),
                  _buildSimulationsCard(context, appointment),
                  context.verticalSpace(32),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.fonts.grey11w600ls12,
    );
  }

  Widget _buildOverviewHeader(BuildContext context, AppointmentDetailData appointment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment.appointmentType?.title ?? 'Consultation',
              style: context.fonts.black24w700,
            ),
            context.verticalSpace(4),
            Text(
              'Booked on ${appointment.createdAt != null ? DateFormat('MMM dd, yyyy').format(appointment.createdAt!) : "N/A"}',
              style: context.fonts.grey14w400,
            ),
          ],
        ),
        _buildStatusBadge(context, appointment.status),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    final normalized = status?.toLowerCase() ?? '';
    Color badgeColor;
    switch (normalized) {
      case 'completed':
      case 'arrived':
        badgeColor = CustomColors.green;
        break;
      case 'ongoing':
        badgeColor = Colors.blue;
        break;
      case 'pending':
        badgeColor = Colors.orange;
        break;
      case 'delayed':
        badgeColor = CustomColors.purple;
        break;
      case 'no_show':
      case 'no-show':
        badgeColor = CustomColors.red;
        break;
      default:
        badgeColor = CustomColors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(8)),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        status?.toUpperCase() ?? 'PENDING',
        style: context.fonts.grey12w600.copyWith(color: badgeColor),
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, AppointmentDetailData appointment) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Row(
        children: [
          _buildAvatar(
            context,
            imageUrl: appointment.patient?.profileImageUrl,
            radius: 40,
          ),
          context.horizontalSpace(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patient?.name ?? 'N/A',
                  style: context.fonts.black20w600,
                ),
                context.verticalSpace(4),
                Text(
                  appointment.patient?.email ?? 'N/A',
                  style: context.fonts.purple14w600,
                ),
                context.verticalSpace(4),
                Text(
                  appointment.patient?.phoneNumber ?? 'N/A',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentInfoCard(BuildContext context, AppointmentDetailData appointment) {
    final dateStr = appointment.date != null
        ?  DateTimeUtils.formatTimestampToDayDate(appointment.date!)
        : 'N/A';
    final startTimeStr = appointment.startTime != null
        ?  DateTimeUtils.formatTimestampToTime(appointment.startTime!)
        : 'N/A';
    final endTimeStr = appointment.endTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.endTime!)
        : 'N/A';

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.calendar_today_outlined, 'Date', dateStr),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.access_time_outlined, 'Time Slot', '$startTimeStr - $endTimeStr'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(
            context,
            Icons.person_outline_rounded,
            'Doctor',
            appointment.doctor?.name != null && appointment.doctor!.name!.isNotEmpty
                ? '${appointment.doctor?.title ?? ""} ${appointment.doctor?.name}'
                : 'Not Assigned',
          ),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.payment_outlined, 'Payment Status', appointment.paymentType?.status?.toUpperCase() ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: context.appEdgeInsets(all: 8),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: CustomColors.purple, size: context.sp(20)),
        ),
        context.horizontalSpace(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.fonts.grey12w400),
            context.verticalSpace(2),
            Text(value, style: context.fonts.black14w600),
          ],
        ),
      ],
    );
  }

  Widget _buildTreatmentsCard(BuildContext context, AppointmentDetailData appointment) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...appointment.treatments!.map((t) {
            return Padding(
              padding: context.appEdgeInsets(bottom: 16),
              child: Container(
                padding: context.appEdgeInsets(all: 16),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.treatmentName ?? 'Treatment', style: context.fonts.black14w600),
                          context.verticalSpace(4),
                          Text('Area: ${t.areaName ?? "N/A"}', style: context.fonts.grey12w400),
                        ],
                      ),
                    ),
                    Text(
                      '\$${t.treatmentCost?.toStringAsFixed(2) ?? "0.00"}',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
              ),
            );
          }),
          const Divider(height: 32, color: CustomColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: context.fonts.black16w700),
              Text(
                '\$${appointment.treatmentTotal?.toStringAsFixed(2) ?? "0.00"}',
                style: context.fonts.black18w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildClinicCard(BuildContext context, AppointmentDetailData appointment) {
  //   return BorderdContainerWidget(
  //     padding: context.appEdgeInsets(all: 24),
  //     borderRadius: context.r(12),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             _buildAvatar(context, imageUrl: appointment.clinic?.logo, radius: 24),
  //             context.horizontalSpace(16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(appointment.clinic?.name ?? 'N/A', style: context.fonts.black16w600),
  //                   context.verticalSpace(2),
  //                   Text(appointment.clinic?.address ?? 'N/A', style: context.fonts.grey12w400),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSimulationsCard(BuildContext context, AppointmentDetailData appointment) {
    final simulations = appointment.simulations!;
    final images = [
      {'label': 'Front Before', 'url': simulations.frontImageBefore},
      {'label': 'Front After', 'url': simulations.frontImageAfter},
      {'label': 'Right Before', 'url': simulations.rightImageBefore},
      {'label': 'Right After', 'url': simulations.rightImageAfter},
      {'label': 'Left Before', 'url': simulations.leftImageBefore},
      {'label': 'Left After', 'url': simulations.leftImageAfter},
    ].where((img) => img['url'] != null && img['url']!.isNotEmpty).toList();

    if (images.isEmpty) return const SizedBox();

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: context.w(16),
          mainAxisSpacing: context.h(16),
          childAspectRatio: 1,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.r(8)),
                  child: CachedNetworkImage(
                    imageUrl: images[index]['url']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: CustomColors.softGrey),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              context.verticalSpace(4),
              Text(images[index]['label']!, style: context.fonts.grey11w400),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, {String? imageUrl, required double radius}) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: context.r(radius * 2),
          width: context.r(radius * 2),
          fit: BoxFit.cover,
          errorWidget: (_, _, _) => _buildDefaultAvatar(context, radius),
        ),
      );
    }
    return _buildDefaultAvatar(context, radius);
  }

  Widget _buildDefaultAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: context.r(radius),
      backgroundColor: CustomColors.softGrey,
      child: Icon(Icons.person, size: context.r(radius), color: CustomColors.grey),
    );
  }
}

