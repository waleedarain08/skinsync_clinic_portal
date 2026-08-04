import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/theme.dart';
import '../../view_models/administration_staff_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class AdministrationStaffDetailScreen extends ConsumerWidget {
  const AdministrationStaffDetailScreen({super.key});
  static const String routeName = '/administration-staff-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(administrationStaffProvider);
    final staff = state.selectedStaff;

    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        title: Text(
          'Staff Details',
          style: context.fonts.black18w600,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: CustomColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.loading
          ? const Center(child: AppLoader())
          : staff == null
              ? Center(
                  child: Text(
                    state.error ?? 'Staff member not found',
                    style: context.fonts.grey14w400,
                  ),
                )
              : SingleChildScrollView(
                  padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(context, staff),
                      context.verticalSpace(24),
                      _buildInfoSection(context, staff),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, var staff) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: context.r(50),
            backgroundColor: CustomColors.softGrey,
            child: Icon(Icons.person, size: context.r(50), color: CustomColors.grey),
          ),
          context.horizontalSpace(24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(staff.name, style: context.fonts.black26w700),
                context.verticalSpace(4),
                Container(
                  padding: context.appEdgeInsets(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: CustomColors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.r(20)),
                  ),
                  child: Text(
                    staff.role,
                    style: context.fonts.purple12w700,
                  ),
                ),
                context.verticalSpace(12),
                Row(
                  children: [
                    _statusIndicator(staff.status),
                    context.horizontalSpace(8),
                    Text(
                      staff.status.toUpperCase(),
                      style: context.fonts.black12w600.copyWith(
                        color: staff.status.toLowerCase() == 'active'
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

  Widget _statusIndicator(String status) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status.toLowerCase() == 'active' ? CustomColors.green : CustomColors.red,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, var staff) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal & Professional Information', style: context.fonts.black18w600),
          const Divider(color: CustomColors.border, height: 32),
          _infoRow(context, Icons.email_outlined, 'Email Address', staff.email),
          _infoRow(context, Icons.phone_outlined, 'Phone Number', staff.phone),
          _infoRow(context, Icons.location_on_outlined, 'Address', staff.address ?? 'N/A'),
          _infoRow(context, Icons.business_outlined, 'Department', staff.department ?? 'N/A'),
          _infoRow(context, Icons.calendar_today_outlined, 'Join Date', staff.joinDate ?? 'N/A'),
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
}
