import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/responses/appointment_detail_response.dart';
import '../../utils/date_time_utills.dart';
import '../../utils/theme.dart';
import '../../view_models/appointment_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';
import 'appointment_treatment_detail_screen.dart';

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
        title: Text(
          'Appointment Details',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewHeader(context, appointment),
            context.verticalSpace(24),
            _buildSection(
              context,
              title: 'Patient Information',
              children: [
                _buildPatientInfo(context, appointment),
              ],
            ),
            context.verticalSpace(24),
            _buildSection(
              context,
              title: 'Appointment Schedule',
              children: [
                _buildScheduleInfo(context, appointment),
              ],
            ),
            if (appointment.treatments != null && appointment.treatments!.isNotEmpty) ...[
              context.verticalSpace(24),
              _buildSection(
                context,
                title: 'Assigned Treatments',
                children: [
                  _buildTreatmentsList(context, appointment),
                ],
              ),
            ],
            if (appointment.simulations != null) ...[
              context.verticalSpace(24),
              _buildSection(
                context,
                title: 'Simulations',
                children: [
                  _buildSimulationsGrid(context, appointment),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewHeader(BuildContext context, AppointmentDetailData appointment) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event_available, color: CustomColors.purple, size: 32),
          ),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment #${appointment.appointmentKey ?? ""}',
                  style: context.fonts.level2Heading,
                ),
                context.verticalSpace(4),
                Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    appointment.appointmentType?.title ?? 'Consultation',
                    style: context.fonts.purple12w700,
                  ),
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _statusIndicator(appointment.status),
                    context.horizontalSpace(8),
                    Text(
                      (appointment.status ?? "pending").toUpperCase(),
                      style: context.fonts.black12w600.copyWith(
                        color: _getStatusColor(appointment.status),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusIndicator(String? status) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getStatusColor(status),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    final normalized = status?.toLowerCase() ?? '';
    switch (normalized) {
      case 'completed':
      case 'arrived':
        return CustomColors.green;
      case 'ongoing':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'delayed':
        return CustomColors.purple;
      case 'no_show':
      case 'no-show':
        return CustomColors.red;
      default:
        return CustomColors.grey;
    }
  }

  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.subHeading),
          const Divider(color: CustomColors.border, height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPatientInfo(BuildContext context, AppointmentDetailData appointment) {
    final p = appointment.patient;
    return Row(
      children: [
        _buildAvatar(context, p?.profileImageUrl, 30),
        context.horizontalSpace(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p?.name ?? 'N/A', style: context.fonts.black16w600),
              context.verticalSpace(4),
              _infoRow(context, Icons.email_outlined, 'Email', p?.email ?? 'N/A', marginBottom: 8),
              _infoRow(context, Icons.phone_outlined, 'Phone', p?.phoneNumber ?? 'N/A', marginBottom: 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfo(BuildContext context, AppointmentDetailData appointment) {
    final dateStr = appointment.date != null
        ? DateTimeUtils.formatTimestampToDayDate(appointment.date!)
        : 'N/A';
    final startTimeStr = appointment.startTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.startTime!)
        : 'N/A';
    final endTimeStr = appointment.endTime != null
        ? DateTimeUtils.formatTimestampToTime(appointment.endTime!)
        : 'N/A';

    return Column(
      children: [
        _infoRow(context, Icons.calendar_today_outlined, 'Date', dateStr),
        _infoRow(context, Icons.access_time_outlined, 'Time Slot', '$startTimeStr - $endTimeStr'),
        _infoRow(
          context,
          Icons.person_outline_rounded,
          'Assigned Provider',
          appointment.doctor?.name != null && appointment.doctor!.name!.isNotEmpty
              ? '${appointment.doctor?.title ?? ""} ${appointment.doctor?.name}'
              : 'Not Assigned',
        ),
        _infoRow(context, Icons.payment_outlined, 'Payment Status', appointment.paymentType?.status?.toUpperCase() ?? 'N/A', marginBottom: 0),
      ],
    );
  }

  Widget _buildTreatmentsList(BuildContext context, AppointmentDetailData appointment) {
    return Column(
      children: [
        ...appointment.treatments!.map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                if (t.treatmentId != null) {
                  context.push(AppointmentTreatmentDetailScreen.routeName, extra: t.treatmentId);
                }
              },
              borderRadius: BorderRadius.circular(context.r(8)),
              child: Container(
                padding: context.appEdgeInsets(all: 12),
                decoration: BoxDecoration(
                  color: CustomColors.whiteGrey,
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.treatmentName ?? 'Treatment', style: context.fonts.black14w600),
                        context.verticalSpace(2),
                        Text('Area: ${t.areaName ?? "N/A"}', style: context.fonts.grey12w400),
                      ],
                    ),
                    Text(
                      '\$${t.treatmentCost?.toStringAsFixed(2) ?? "0.00"}',
                      style: context.fonts.purple14w700,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const Divider(height: 24, color: CustomColors.border),
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
    );
  }

  Widget _buildSimulationsGrid(BuildContext context, AppointmentDetailData appointment) {
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

    return GridView.builder(
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
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value, {double marginBottom = 20}) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(marginBottom)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CustomColors.purple),
          context.horizontalSpace(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.fonts.grey12w400),
              context.verticalSpace(4),
              Text(value, style: context.fonts.black14w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String? imageUrl, double radius) {
    return ClipOval(
      child: imageUrl != null && imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: imageUrl,
              height: context.r(radius * 2),
              width: context.r(radius * 2),
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => _buildDefaultAvatar(context, radius),
            )
          : _buildDefaultAvatar(context, radius),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context, double radius) {
    return CircleAvatar(
      radius: context.r(radius),
      backgroundColor: CustomColors.softGrey,
      child: Icon(Icons.person, size: context.r(radius), color: CustomColors.grey),
    );
  }
}
