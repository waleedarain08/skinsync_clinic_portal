import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/string_utils.dart';
import '../../utils/theme.dart';
import '../../models/responses/register_practitioner_response.dart';
import '../../view_models/practitioner_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class PractitionerDetailScreen extends ConsumerWidget {
  static const String routeName = '/practitioner-detail';

  const PractitionerDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practitioner = ref.watch(practitionerProvider).practitioner;

    if (practitioner == null) {
      return const GradientScaffold(
        body: Center(child: AppLoader()),
      );
    }

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          'Provider Details',
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
            _buildProfileHeader(context, practitioner),
            context.verticalSpace(24),
            _buildInfoSection(context, practitioner),
            context.verticalSpace(24),
            _buildProfessionalSection(context, practitioner),
            if (practitioner.availabilityInfo?.availability != null &&
                practitioner.availabilityInfo!.availability.isNotEmpty) ...[
              context.verticalSpace(24),
              _buildAvailabilitySection(context, practitioner),
            ],
            context.verticalSpace(24),
            _buildFinancialSection(context, practitioner),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Practitioner p) {
    final basic = p.basicInfo;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        children: [
          _buildAvatar(context, basic?.image, 50),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${basic?.title ?? ""} ${basic?.name ?? "N/A"}',
                  style: context.fonts.black26w700,
                ),
                context.verticalSpace(4),
                Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    '${basic?.role.capitalize ?? "N/A"} • ${basic?.specialization ?? "N/A"}',
                    style: context.fonts.purple12w700,
                  ),
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _statusIndicator(p.status),
                    context.horizontalSpace(8),
                    Text(
                      (p.status ?? "inactive").toUpperCase(),
                      style: context.fonts.black12w600.copyWith(
                        color: p.status?.toLowerCase() == 'active'
                            ? CustomColors.green
                            : CustomColors.red,
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
        color: status?.toLowerCase() == 'active' ? CustomColors.green : CustomColors.red,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, Practitioner p) {
    final contact = p.contactInfo;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.email_outlined, 'Email Address', contact?.email ?? 'N/A'),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', '${contact?.cc ?? ""} ${contact?.phone ?? "N/A"}'),
          _infoRow(context, Icons.location_on_outlined, 'Country', contact?.country ?? 'N/A'),
          if (contact?.emergencyContact != null)
            _infoRow(
              context,
              Icons.contact_emergency_outlined,
              'Emergency Contact',
              '${contact?.emergencyContact.name ?? "N/A"} (${contact?.emergencyContact.relationship ?? ""}) - ${contact?.emergencyContact.phone ?? ""}',
            ),
        ],
      ),
    );
  }

  Widget _buildProfessionalSection(BuildContext context, Practitioner p) {
    final license = p.licenseInfo;
    final basic = p.basicInfo;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Professional Details', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.work_history_outlined, 'Experience', '${basic?.yearsOfExperience ?? 0} Years'),
          _infoRow(context, Icons.badge_outlined, 'License Number', license?.licenseNumber ?? 'N/A'),
          _infoRow(context, Icons.calendar_month_outlined, 'License Expiry', license?.licenseExpiryDate ?? 'N/A'),
          _infoRow(context, Icons.account_balance_outlined, 'Issuing Authority', license?.issuingAuthority ?? 'N/A'),
          _infoRow(context, Icons.security_outlined, 'Indemnity Insurance', license?.indemnityInsuranceNumber ?? 'N/A'),
          if (basic?.qualifications != null && basic!.qualifications.isNotEmpty) ...[
            context.verticalSpace(8),
            Text('Qualifications', style: context.fonts.grey12w400),
            context.verticalSpace(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: basic.qualifications.map((q) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CustomColors.softGrey,
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                child: Text(q, style: context.fonts.black12w600),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(BuildContext context, Practitioner p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Clinical Availability', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          ...p.availabilityInfo!.availability.map((avail) {
            return Padding(
              padding: EdgeInsets.only(bottom: context.h(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: CustomColors.purple),
                      context.horizontalSpace(12),
                      Text(avail.uiTimeRange(context), style: context.fonts.black14w600),
                    ],
                  ),
                  context.verticalSpace(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: avail.days.map((day) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(20)),
                      ),
                      child: Text(day, style: context.fonts.black12w400),
                    )).toList(),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24, color: CustomColors.border),
          _infoRow(context, Icons.timer_outlined, 'Slot Duration', '${p.availabilityInfo?.slotDurationMinutes ?? 0} Minutes'),
        ],
      ),
    );
  }

  Widget _buildFinancialSection(BuildContext context, Practitioner p) {
    final fin = p.financialInfo;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Financial Configuration', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.payments_outlined, 'Consultation Fee', '\$${fin?.consultationFee ?? 0}'),
          _infoRow(
            context,
            Icons.percent_outlined,
            'Commission',
            '${fin?.treatmentCommission ?? 0}${fin?.commissionType == 'percentage' ? '%' : '\$'}',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
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
