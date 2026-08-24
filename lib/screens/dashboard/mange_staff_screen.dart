import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import '../../models/responses/administration_staff_response.dart';
import '../../view_models/administration_staff_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/status_toggle_switch.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/gradient_scaffold.dart';

import 'add_administration_staff_screen.dart';
import 'administration_staff_detail_screen.dart';
import 'manage_practitioner_screen.dart';

class ManageStaffScreen extends ConsumerStatefulWidget {
  static const String routeName = '/manage-staff';

  const ManageStaffScreen({super.key});

  @override
  ConsumerState<ManageStaffScreen> createState() => _ManageStaffScreenState();
}

class _ManageStaffScreenState extends ConsumerState<ManageStaffScreen> {
  bool isSchedule = true;
  int _selectedMainTab = 0; // 0 for Provider, 1 for Administration

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           if(!isDeploymentMode)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(28),
              vertical: context.h(20),
            ),
            child: Row(
              children: [
                _mainTabItem("Providers", 0),
                SizedBox(width: context.w(32)),
               
                _mainTabItem("Administration Staff", 1),
              ],
            ),
          ),
           if(!isDeploymentMode)
          const Divider(color: CustomColors.border, height: 1),
          Expanded(
            child: _selectedMainTab == 0
                ? const ManagePractitionerScreen(showScaffold: false)
                : _buildAdministrationStaffContent(),
          ),
        ],
      ),
    );
  }

  Widget _mainTabItem(String title, int index) {
    bool isSelected = _selectedMainTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMainTab = index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: isSelected
                ? context.fonts.black18w600.copyWith(color: CustomColors.purple)
                : context.fonts.black18w600.copyWith(color: CustomColors.grey),
          ),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: context.h(4)),
              height: 2,
              width: context.w(40),
              color: CustomColors.purple,
            ),
        ],
      ),
    );
  }

  Widget _buildAdministrationStaffContent() {
    final state = ref.watch(administrationStaffProvider);

    final filteredStaff = state.staff.where((s) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
          s.name.toLowerCase().contains(query) ||
          s.email.toLowerCase().contains(query) ||
          s.role.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStaffHeader(context),
          context.verticalSpace(32),
          _buildFilters(context),
          context.verticalSpace(24),
          _buildStaffTable(filteredStaff, state.loading),
        ],
      ),
    );
  }

  Widget _buildStaffHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Administration Staff', style: context.fonts.level1Heading),
            context.verticalSpace(6),
            Text(
              'Manage clinic receptionists, managers, and administrative support.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            context.push(AddAdministrationStaffScreen.routeName);
          },
          icon: Icons.add_rounded,
          label: 'Add Admin Staff',
          width: context.w(180),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              style: context.fonts.black14w400,
              decoration: AppDecorations.input(
                context,
                hint: "Search Staff by name, email, or role...",
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: CustomColors.grey,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: CustomColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffTable(List<AdministrationStaffListItem> staff, bool isLoading) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    if (staff.isEmpty) {
      return Center(
        child: Padding(
          padding: context.appEdgeInsets(vertical: 48),
          child: Text("No staff members found", style: context.fonts.grey14w400),
        ),
      );
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Staff Name / Details
            1: FlexColumnWidth(3), // Role
            2: FlexColumnWidth(2), // Status
            3: FlexColumnWidth(1.5), // Actions
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Header Row
            TableRow(
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                border: Border(bottom: BorderSide(color: CustomColors.border)),
              ),
              children: [
                _tableHeaderCell('STAFF NAME'),
                _tableHeaderCell('ROLE'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...staff.map((s) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _staffNameCell(s),
                  _tableTextCell(
                    s.role,
                    style: context.fonts.black14w600,
                  ),
                  _statusBadgeCell(s),
                  _actionsCell(s),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _tableHeaderCell(String label) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        label,
        style: context.fonts.grey12w600.copyWith(letterSpacing: 1),
      ),
    );
  }

  Widget _staffNameCell(AdministrationStaffListItem s) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.r(21),
            backgroundColor: CustomColors.softGrey,
            child: Icon(Icons.person, size: context.r(20), color: CustomColors.grey),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(2),
                Text(
                  s.email,
                  style: context.fonts.purple12w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableTextCell(String text, {required TextStyle style}) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _statusBadgeCell(AdministrationStaffListItem s) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: StatusToggleSwitch(
        status: s.status,
        width: context.w(110),
        height: context.h(32),
        onChanged: (newStatus) {
          ref.read(administrationStaffProvider.notifier).updateStaffStatus(s.id, newStatus);
        },
      ),
    );
  }

  Widget _actionsCell(AdministrationStaffListItem s) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            visualDensity: .compact,
            padding: EdgeInsets.zero,
            tooltip: 'View Details',
            icon: const Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: 20,
            ),
            onPressed: () async {
              await ref.read(administrationStaffProvider.notifier).getStaffDetail(s.id);
              if (context.mounted) {
                context.push(AdministrationStaffDetailScreen.routeName);
              }
            },
          ),
          IconButton(
            visualDensity: .compact,
            padding: EdgeInsets.zero,
            tooltip: 'Delete Staff',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: CustomColors.red,
              size: 20,
            ),
            onPressed: () {
              ref.read(administrationStaffProvider.notifier).deleteStaff(s.id);
            },
          ),
        ],
      ),
    );
  }
}
