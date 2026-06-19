import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/theme.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/number_paginator.dart';
import 'patient_management_detail.dart';

class PatientManagementScreen extends StatefulWidget {
  static const String routeName = '/patient-management';
  const PatientManagementScreen({super.key});

  @override
  State<PatientManagementScreen> createState() => _PatientManagementScreenState();
}

class _PatientManagementScreenState extends State<PatientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;

  // Local list of clinical patients (high-fidelity mock data)
  final List<Map<String, String>> _dummyPatients = [
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'email': 'sarah.johnson@email.com',
      'gender': 'Female',
      'phone': '+1 (555) 0192',
      'lastVisit': '02 Feb 2025',
    },
    {
      'id': '2',
      'name': 'Michael Brown',
      'email': 'michael.brown@email.com',
      'gender': 'Male',
      'phone': '+1 (555) 0143',
      'lastVisit': '28 Jan 2025',
    },
    {
      'id': '3',
      'name': 'Alyssa Davis',
      'email': 'alyssa.davis@email.com',
      'gender': 'Female',
      'phone': '+1 (555) 0188',
      'lastVisit': '15 Jan 2025',
    },
    {
      'id': '4',
      'name': 'Emily Wilson',
      'email': 'emily.wilson@email.com',
      'gender': 'Female',
      'phone': '+1 (555) 0177',
      'lastVisit': '10 Jan 2025',
    },
    {
      'id': '5',
      'name': 'James Taylor',
      'email': 'james.taylor@email.com',
      'gender': 'Male',
      'phone': '+1 (555) 0199',
      'lastVisit': '05 Jan 2025',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter patients dynamically based on search query
    final filteredPatients = _dummyPatients.where((p) {
      final query = _searchQuery.toLowerCase();
      return query.isEmpty ||
          (p['name']?.toLowerCase().contains(query) ?? false) ||
          (p['email']?.toLowerCase().contains(query) ?? false) ||
          (p['phone']?.toLowerCase().contains(query) ?? false);
    }).toList();

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildQuickInsights(),
            context.verticalSpace(32),
            _buildFilters(context),
            context.verticalSpace(24),
            _buildPatientsTable(filteredPatients),
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
            Text('Patient Database', style: context.fonts.black26w700),
            context.verticalSpace(6),
            Text(
              'Manage clinic active patient directory, medical histories, and active treatment journeys.',
              style: context.fonts.grey13w500,
            ),
          ],
        ),
        CustomPrimaryButton(
          onTap: () {
            // Mock Trigger
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Patient Form initialization...')),
            );
          },
          icon: Icons.add_rounded,
          label: 'Add New Patient',
          width: context.w(180),
        ),
      ],
    );
  }

  Widget _buildQuickInsights() {
    final totalPatients = _dummyPatients.length;
    final activePatients = _dummyPatients.length;
    final femaleCount = _dummyPatients.where((p) => p['gender'] == 'Female').length;
    final maleCount = _dummyPatients.where((p) => p['gender'] == 'Male').length;

    return Row(
      children: [
        _buildStatCard(
          'Total Patients',
          '$totalPatients',
          Icons.people_alt_outlined,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Active Patients',
          '$activePatients',
          Icons.check_circle_outline_rounded,
          CustomColors.green,
        ),
        _buildStatCard(
          'Female Profiles',
          '$femaleCount',
          Icons.face_retouching_natural_rounded,
          CustomColors.purple,
        ),
        context.horizontalSpace(16),
        _buildStatCard(
          'Male Profiles',
          '$maleCount',
          Icons.man_outlined,
          CustomColors.blue,
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
                hint: "Search patients by name, email, or phone number...",
                prefixIcon: const Icon(Icons.search_rounded, color: CustomColors.grey),
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

  Widget _buildPatientsTable(List<Map<String, String>> patients) {
    if (patients.isEmpty) {
      return _buildEmptyState(context);
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.r(12)),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4), // Patient Name / Details
            1: FlexColumnWidth(2), // Gender
            2: FlexColumnWidth(3), // Phone Number
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
                _tableHeaderCell('PATIENT NAME'),
                _tableHeaderCell('GENDER'),
                _tableHeaderCell('PHONE NUMBER'),
                _tableHeaderCell('STATUS'),
                _tableHeaderCell('ACTIONS'),
              ],
            ),
            // Data Rows
            ...patients.map((p) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: CustomColors.border),
                  ),
                ),
                children: [
                  _patientNameCell(p),
                  _tableTextCell(
                    p['gender'] ?? 'N/A',
                    style: context.fonts.black14w600,
                  ),
                  _tableTextCell(
                    p['phone'] ?? 'N/A',
                    style: context.fonts.grey14w400,
                  ),
                  _statusBadgeCell(),
                  _actionsCell(p),
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

  Widget _patientNameCell(Map<String, String> p) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: context.r(21),
            backgroundColor: CustomColors.softGrey,
            child: const Icon(
              Icons.person,
              color: CustomColors.grey,
              size: 20,
            ),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'] ?? 'N/A',
                  style: context.fonts.black14w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                context.verticalSpace(2),
                Text(
                  p['email'] ?? 'N/A',
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

  Widget _statusBadgeCell() {
    Color badgeColor = CustomColors.green;
    String label = 'Active';

    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: context.appEdgeInsets(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.1),
              borderRadius: context.appBorderRadius(all: 20),
              border: Border.all(color: badgeColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: context.fonts.grey12w600.copyWith(
                color: badgeColor,
                fontSize: context.sp(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionsCell(Map<String, String> p) {
    return Padding(
      padding: context.appEdgeInsets(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          IconButton(
            tooltip: 'View Journey Details',
            icon: const Icon(
              Icons.visibility_outlined,
              color: CustomColors.grey,
              size: 20,
            ),
            onPressed: () {
              context.push(PatientManagementDetailScreen.routeName);
            },
          ),
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(
              Icons.edit_outlined,
              color: CustomColors.purple,
              size: 20,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit profile for ${p['name']}')),
              );
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
              'No patients match your search refinement',
              style: context.fonts.black18w600,
            ),
            context.verticalSpace(8),
            Text(
              'Try clearing your search keyword, resetting the filter, or register a brand new patient profile.',
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Add Patient Form initialization...')),
                    );
                  },
                  icon: Icons.add_rounded,
                  label: 'Add Patient',
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
