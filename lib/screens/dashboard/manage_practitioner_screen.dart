import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/requests/status_request.dart';
import '../../utils/theme.dart';
import '../../view_models/practitioner_view_model.dart';
import '../../models/responses/practitioner_list_response.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/status_toggle_switch.dart';
import '../add_practitioner_screen.dart';
import 'practitioner_detail_screen.dart';

class ManagePractitionerScreen extends ConsumerStatefulWidget {
  static const String routeName = '/manage-practitioner';

  const ManagePractitionerScreen({super.key});

  @override
  ConsumerState<ManagePractitionerScreen> createState() =>
      _ManagePractitionerScreenState();
}

class _ManagePractitionerScreenState
    extends ConsumerState<ManagePractitionerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(practitionerProvider.notifier).getPractitioner(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(practitionerProvider);

    // Filter practitioners dynamically based on search query
    final filteredDoctors = state.doctors.where((doc) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
          doc.name.toLowerCase().contains(query) ||
          doc.email.toLowerCase().contains(query) ||
          doc.specialization.toLowerCase().contains(query);
    }).toList();

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildQuickInsights(state),
            context.verticalSpace(32),
            _buildFilters(context),
            context.verticalSpace(24),
            _buildDoctorsTable(filteredDoctors, state.loading),
            context.verticalSpace(24),
            _buildFooterPaginator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Practitioner Library', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Manage clinic doctors, injectors, assigned treatments, and weekly clinical schedules.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            ref.read(practitionerProvider.notifier).clearDocuments();
            context.push(AddPractitionerScreen.routeName);
          },
          icon: Icons.add_rounded,
          label: 'Add Practitioner',
          width: context.w(180),
        ),
      ],
    );
  }

  Widget _buildQuickInsights(PractitionerState state) {
    final totalPractitioners = state.doctors.length;
    final activeInjectors = state.doctors
        .where(
          (d) => d.specialization.toLowerCase().contains('injector'),
        )
        .length;
    final activeMDs = state.doctors
        .where(
          (d) =>
              d.title.toLowerCase().contains('dr') ||
              d.specialization.toLowerCase().contains('md'),
        )
        .length;
    final assignedTreatments = state.doctors.fold<int>(
      0,
      (sum, d) => sum + d.treatmentCount,
    );

    return Row(
      children: [
        _buildStatCard(
          'Total Practitioners',
          '$totalPractitioners',
          Icons.people_alt_outlined,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Active Injectors',
          '$activeInjectors',
          Icons.vaccines_outlined,
          CustomColors.green,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Active Doctors (MD)',
          '$activeMDs',
          Icons.masks_outlined,
          CustomColors.blue,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Services Configured',
          '$assignedTreatments',
          Icons.event_note_outlined,
          CustomColors.amber,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: BorderdContainerWidget(
        padding: context.appEdgeInsets(all: 16),
        child: Row(
          children: [
            Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: context.appBorderRadius(all: 8),
              ),
              child: Icon(icon, color: color, size: context.sp(20)),
            ),
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: context.fonts.black18w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.verticalSpace(2),
                  Text(
                    title,
                    style: context.fonts.grey11w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
                hint: "Search practitioners by keyword, name, or email...",
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

  Widget _buildDoctorsTable(List<PractitionerListItem> doctors, bool isLoading) {
    if (isLoading) {
      return const Center(child: AppLoader());
    }

    if (doctors.isEmpty) {
      return _buildEmptyState(context);
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Practitioner Name / Details
            1: FlexColumnWidth(2.5), // Clinical Role
            2: FlexColumnWidth(2), // Treatments Assigned
            3: FlexColumnWidth(2), // Status
            4: FlexColumnWidth(2), // Actions
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
                _tableHeaderCell('PRACTITIONER NAME'),
                _tableHeaderCell('CLINICAL ROLE'),
                _tableHeaderCell('ASSIGNED TREATMENTS'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...doctors.map((d) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _practitionerNameCell(d),
                  _tableTextCell(
                    d.specialization,
                    style: context.fonts.black14w600,
                  ),
                  _tableTextCell(
                    '${d.treatmentCount} Services',
                    style: context.fonts.grey14w400,
                  ),
                  _statusBadgeCell(d),
                  _actionsCell(d),
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

  Widget _practitionerNameCell(PractitionerListItem d) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          _buildAvatar(context, d),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${d.title} ${d.name}',
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(2),
                Text(
                  d.email,
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

  Widget _buildAvatar(BuildContext context, PractitionerListItem d) {
    if (d.image.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: d.image,
          height: context.r(42),
          width: context.r(42),
          fit: BoxFit.cover,
          errorWidget: (_, _, _) {
            return CircleAvatar(
              radius: context.r(21),
              backgroundColor: CustomColors.softGrey,
              child: Icon(
                Icons.person,
                size: context.r(20),
                color: CustomColors.grey,
              ),
            );
          },
        ),
      );
    }
    return CircleAvatar(
      radius: context.r(21),
      backgroundColor: CustomColors.softGrey,
      child: Icon(Icons.person, size: context.r(20), color: CustomColors.grey),
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

  Widget _statusBadgeCell(PractitionerListItem d) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: StatusToggleSwitch(
        status: d.status,
        width: context.w(110),
        height: context.h(32),
        onChanged: (newStatus) {
          final request = StatusRequest(status: newStatus.toLowerCase());

          ref
              .read(practitionerProvider.notifier)
              .updatePractitionerStatus(id: d.id, request: request);
        },
      ),
    );
  }

  Widget _actionsCell(PractitionerListItem d) {
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
              await ref
                  .read(practitionerProvider.notifier)
                  .getPractitionerDetail(id: d.id);
              final detail = ref.read(practitionerProvider).practitioner;
              if (detail != null && context.mounted) {
                context.push(PractitionerDetailScreen.routeName, extra: detail);
              }
            },
          ),
          IconButton(
            visualDensity: .compact,
            padding: EdgeInsets.zero,
            tooltip: 'Delete Practitioner',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: CustomColors.red,
              size: 20,
            ),
            onPressed: () async {
              await ref
                  .read(practitionerProvider.notifier)
                  .deletePractitioner(id: d.id);
            },
          ),
          IconButton(
            visualDensity: .compact,
            padding: EdgeInsets.zero,
            tooltip: 'Edit Practitioner',
            icon: const Icon(
              Icons.edit_outlined,
              color: CustomColors.purple,
              size: 20,
            ),
            onPressed: () async {
              await ref
                  .read(practitionerProvider.notifier)
                  .getPractitionerDetail(id: d.id);
              final detail = ref.read(practitionerProvider).practitioner;
              if (detail != null && context.mounted) {
                context.push(AddPractitionerScreen.routeName, extra: detail);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: const BoxDecoration(
                color: CustomColors.whiteGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 48,
                color: CustomColors.grey,
              ),
            ),
            context.verticalSpace(24),
            Text(
              'No practitioners match your search refinement',
              style: context.fonts.black18w600,
            ),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filter, or add a brand new clinical practitioner profile.',
              style: context.fonts.grey14w400,
              textAlign: TextAlign.center,
            ),
            context.verticalSpace(24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomOutlinedButton(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  label: 'Clear Search Filter',
                ),
                context.horizontalSpace(16),
                CustomPrimaryButton(
                  onTap: () {
                    context.push(AddPractitionerScreen.routeName);
                  },
                  icon: Icons.add_rounded,
                  label: 'Add Practitioner',
                  width: context.w(180),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterPaginator() {
    return Center(
      child: NumberPaginator(
        totalPages: 1,
        currentPage: _currentPage,
        onPageChanged: (pageIndex) {
          setState(() {
            _currentPage = pageIndex;
          });
        },
      ),
    );
  }
}
