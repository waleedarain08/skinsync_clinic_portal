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
        elevation: 0,
        centerTitle: true,
        title: Text(
          practitioner.basicInfo?.name ?? 'Provider Details',
          style: context.fonts.black18w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CustomColors.black),
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
                // Header Profile Section
                _buildProfileHeader(context, practitioner),
                context.verticalSpace(32),

                // Contact Information
                _buildSectionTitle(context, 'CONTACT INFORMATION'),
                context.verticalSpace(12),
                _buildContactCard(context, practitioner),
                context.verticalSpace(32),

                // License & Insurance
                _buildSectionTitle(context, 'LICENSE & INSURANCE'),
                context.verticalSpace(12),
                _buildLicenseCard(context, practitioner),
                context.verticalSpace(32),

                // Clinic Access & Permissions
                _buildSectionTitle(context, 'CLINIC ACCESS & PERMISSIONS'),
                context.verticalSpace(12),
                _buildAccessCard(context, practitioner),
                context.verticalSpace(32),

                // Availability Hours
                if (practitioner.availabilityInfo?.availability != null &&
                    practitioner.availabilityInfo!.availability.isNotEmpty) ...[
                  _buildSectionTitle(context, 'CLINICAL AVAILABILITY'),
                  context.verticalSpace(12),
                  _buildAvailabilityCard(context, practitioner),
                  context.verticalSpace(32),
                ],

                // Financial Configuration
                _buildSectionTitle(context, 'FINANCIAL CONFIGURATION'),
                context.verticalSpace(12),
                _buildFinancialCard(context, practitioner),
                context.verticalSpace(32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: context.fonts.grey11w600ls12);
  }

  Widget _buildProfileHeader(BuildContext context, Practitioner p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Row(
        children: [
          _buildAvatar(context, p.basicInfo?.image, 40),
          context.horizontalSpace(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${p.basicInfo?.title ?? ""} ${p.basicInfo?.name ?? "N/A"}',
                      style: context.fonts.black20w600,
                    ),
                    context.horizontalSpace(12),
                    _buildStatusBadge(context, p.status),
                  ],
                ),
                context.verticalSpace(4),
                Text(
                  '${p.basicInfo?.role.capitalize ?? "N/A"} • ${p.basicInfo?.specialization ?? "N/A"}',
                  style: context.fonts.grey14w400,
                ),
                context.verticalSpace(4),
                Text(
                  '${p.basicInfo?.yearsOfExperience ?? 0} Years Experience',
                  style: context.fonts.purple14w600,
                ),
                if (p.basicInfo?.qualifications != null && p.basicInfo!.qualifications.isNotEmpty) ...[
                  context.verticalSpace(8),
                  Wrap(
                    spacing: 8,
                    children: p.basicInfo!.qualifications.map((q) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(q, style: context.fonts.black10w600),
                    )).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String? status) {
    final isActive = status?.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isActive ? CustomColors.green : CustomColors.red).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status?.toUpperCase() ?? 'INACTIVE',
        style: context.fonts.grey10w700.copyWith(color: isActive ? CustomColors.green : CustomColors.red),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Practitioner p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.email_outlined, 'Email Address', p.contactInfo?.email ?? 'N/A'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.phone_outlined, 'Phone Number', '${p.contactInfo?.cc ?? ""} ${p.contactInfo?.phone ?? "N/A"}'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.location_on_outlined, 'Country', p.contactInfo?.country ?? 'N/A'),
          if (p.contactInfo?.emergencyContact != null) ...[
            const Divider(height: 32, color: CustomColors.border),
            _buildInfoRow(
              context,
              Icons.contact_emergency_outlined,
              'Emergency Contact',
              '${p.contactInfo?.emergencyContact.name ?? "N/A"} (${p.contactInfo?.emergencyContact.relationship ?? ""}) - ${p.contactInfo?.emergencyContact.phone ?? ""}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLicenseCard(BuildContext context, Practitioner p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.badge_outlined, 'License Number', p.licenseInfo?.licenseNumber ?? 'N/A'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.calendar_month_outlined, 'License Expiry', p.licenseInfo?.licenseExpiryDate ?? 'N/A'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.account_balance_outlined, 'Issuing Authority', p.licenseInfo?.issuingAuthority ?? 'N/A'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(context, Icons.security_outlined, 'Indemnity Insurance', p.licenseInfo?.indemnityInsuranceNumber ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildAccessCard(BuildContext context, Practitioner p) {
    final access = p.clinicAccess;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          _buildSwitchRow(context, 'Can Perform Consultations', access?.canPerformConsultation ?? false),
          const Divider(height: 24, color: CustomColors.border),
          _buildSwitchRow(context, 'Can Perform Treatments', access?.canPerformTreatment ?? false),
          const Divider(height: 24, color: CustomColors.border),
          _buildSwitchRow(context, 'Virtual Consultations Enabled', access?.isVirtualEnabled ?? false),
          const Divider(height: 24, color: CustomColors.border),
          _buildSwitchRow(context, 'Accepts Walk-ins', access?.acceptsWalkIn ?? false),
          if (access?.allowedBookingMethods != null && access!.allowedBookingMethods.isNotEmpty) ...[
            const Divider(height: 24, color: CustomColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Booking Methods', style: context.fonts.black14w600),
                Wrap(
                  spacing: 8,
                  children: access.allowedBookingMethods.map((m) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: CustomColors.purple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(m.replaceAll('_', ' ').toUpperCase(), style: context.fonts.purple11w700),
                  )).toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard(BuildContext context, Practitioner p) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          ...p.availabilityInfo!.availability.map((avail) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: CustomColors.purple),
                      context.horizontalSpace(8),
                      Text(avail.uiTimeRange(context), style: context.fonts.black14w600),
                    ],
                  ),
                  context.verticalSpace(8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: avail.days.map((day) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(day, style: context.fonts.black12w600),
                    )).toList(),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 24, color: CustomColors.border),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Slot Duration', style: context.fonts.grey13w500),
              Text('${p.availabilityInfo?.slotDurationMinutes ?? 0} Minutes', style: context.fonts.black14w600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(BuildContext context, Practitioner p) {
    final fin = p.financialInfo;
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(12),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.payments_outlined, 'Consultation Fee', '\$${fin?.consultationFee ?? 0}'),
          const Divider(height: 32, color: CustomColors.border),
          _buildInfoRow(
            context,
            Icons.percent_outlined,
            'Commission',
            '${fin?.treatmentCommission ?? 0}${fin?.commissionType == 'percentage' ? '%' : '\$'}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CustomColors.purple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: CustomColors.purple, size: 20),
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

  Widget _buildSwitchRow(BuildContext context, String label, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.fonts.black14w600),
        Icon(
          value ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: value ? CustomColors.green : CustomColors.red,
          size: 24,
        ),
      ],
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
      child: Icon(Icons.person, size: context.r(radius * 0.8), color: CustomColors.grey),
    );
  }
}
