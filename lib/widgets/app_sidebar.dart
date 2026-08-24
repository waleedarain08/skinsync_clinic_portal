import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';

import '../main.dart';
import '../screens/dashboard/appointment_screen.dart';
import '../screens/dashboard/clinic_ai_plans_screen.dart';
import '../screens/dashboard/forms_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/dashboard/inventory_screen.dart';
import '../screens/dashboard/mange_staff_screen.dart';
import '../screens/dashboard/patient_management.dart';
import '../screens/dashboard/payment_and_wallet_screen.dart';
import '../screens/dashboard/profile_screen.dart';
import '../screens/dashboard/roles_screen.dart';
import '../screens/dashboard/treatment_screen.dart';
import '../screens/explore_screen.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

class _SidebarEntry {
  const _SidebarEntry({
    required this.icon,
    required this.label,
    required this.routeName,
    this.sectionLabel,
  });

  final IconData icon;
  final String label;
  final String routeName;
  final String? sectionLabel;
}

/// Builds the full list of sidebar entries, hiding the deployment-mode-only
/// tabs (Appointments, Treatments, Inventory, Forms, Roles, Payments &
/// Wallets) when [isDeploymentMode] is true. They only show when it's false.
List<_SidebarEntry> _sidebarEntries() {
  return [
    const _SidebarEntry(
      icon: Iconsax.home_2,
      label: 'Home',
      routeName: HomeScreen.routeName,
    ),
    const _SidebarEntry(
      icon: Iconsax.discover,
      label: 'Explore',
      routeName: ExploreScreen.routeName,
    ),
    const _SidebarEntry(
      icon: Iconsax.profile_2user,
      label: 'Patient Management',
      routeName: PatientManagementScreen.routeName,
    ),
     const _SidebarEntry(
        icon: Icons.vaccines_outlined,
        label: 'Treatments',
        routeName: TreatmentScreen.routeName,
        sectionLabel: 'OPERATIONS',
      ),
    const _SidebarEntry(
      icon: Iconsax.mask,
      label: 'Subscription',
      routeName: ClinicAiPlansScreen.routeName,
      sectionLabel: 'FINANCIALS',

    ),
    if (!isDeploymentMode) ...[
      const _SidebarEntry(
        icon: Iconsax.calendar,
        label: 'Appointments',
        routeName: AppointmentScreen.routeName,
        sectionLabel: 'CLINICAL',
      ),
     
      const _SidebarEntry(
        icon: Icons.inventory,
        label: 'Inventory',
        routeName: InventoryScreen.routeName,
      ),
      const _SidebarEntry(
        icon: Icons.document_scanner,
        label: 'Forms',
        routeName: FormsScreen.routeName,
      ),
      const _SidebarEntry(
        icon: Icons.person_outline,
        label: 'Roles',
        routeName: RolesScreen.routeName,
      ),
      const _SidebarEntry(
        icon: Iconsax.wallet_3,
        label: 'Payments & Wallets',
        routeName: PaymentAndWalletScreen.routeName,
        sectionLabel: 'FINANCIALS',
      ),

    ],
    const _SidebarEntry(
      icon: Iconsax.user_octagon,
      label: 'Staff',
      routeName: ManageStaffScreen.routeName,
      sectionLabel: 'SYSTEM',
    ),
    const _SidebarEntry(
      icon: Iconsax.profile_circle,
      label: 'Profile',
      routeName: ProfileScreen.routeName,
    ),
  ];
}

abstract final class AppSidebarRoutes {
  /// Dynamic now — recomputed from the same entry list the sidebar renders,
  /// so it always matches what's actually on screen.
  static List<String> get routes =>
      _sidebarEntries().map((e) => e.routeName).toList();

  static int indexOf(String location) {
    final routeList = routes;
    final exact = routeList.indexOf(location);
    if (exact >= 0) return exact;

    for (var i = 0; i < routeList.length; i++) {
      if (location.startsWith(routeList[i])) return i;
    }

    return -1;
  }
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.controller,
    this.showToggleButton = true,
  });

  final SidebarXController controller;
  final bool showToggleButton;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: controller,
      theme: _buildTheme(context),
      extendedTheme: _buildExtendedTheme(context),
      animationDuration: const Duration(milliseconds: 300),
      showToggleButton: showToggleButton,
      toggleButtonBuilder: (context, extended) =>
          _buildToggleButton(context, extended),
      headerDivider: const SizedBox.shrink(),
      footerDivider: Divider(
        color: CustomColors.border,
        height: context.h(1),
        thickness: 1,
      ),
      separatorBuilder: (context, index) =>
          _separatorBuilder(context, index, controller),
      headerBuilder: (context, extended) => _headerBuilder(context, extended),
      items: _buildItems(context),
    );
  }

  SidebarXTheme _buildTheme(BuildContext context) {
    return SidebarXTheme(
      width: context.w(80),
      decoration: const BoxDecoration(
        color: CustomColors.white,
        border: Border(right: BorderSide(color: CustomColors.border, width: 1)),
      ),
      padding: context.appEdgeInsets(vertical: 24),
      iconTheme: IconThemeData(color: CustomColors.grey, size: context.sp(20)),
      selectedIconTheme: IconThemeData(
        color: CustomColors.purple,
        size: context.sp(20),
      ),
      hoverIconTheme: IconThemeData(
        color: CustomColors.purple,
        size: context.sp(20),
      ),
      textStyle: context.fonts.grey14w600,
      selectedTextStyle: context.fonts.purple14w600,
      hoverTextStyle: context.fonts.purple14w600,
      hoverColor: CustomColors.lightPurple,
      itemMargin: context.appEdgeInsets(horizontal: 12, vertical: 4),
      selectedItemMargin: context.appEdgeInsets(horizontal: 12, vertical: 4),
      itemPadding: context.appEdgeInsets(horizontal: 12, vertical: 12),
      selectedItemPadding: context.appEdgeInsets(horizontal: 12, vertical: 12),
      itemDecoration: BoxDecoration(
        borderRadius: context.borderRadius(all: 12),
      ),
      selectedItemDecoration: BoxDecoration(
        color: CustomColors.lightPurple,
        borderRadius: context.borderRadius(all: 12),
        border: Border.all(
          color: CustomColors.purple.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
    );
  }

  SidebarXTheme _buildExtendedTheme(BuildContext context) {
    return _buildTheme(context).copyWith(
      width: context.w(280),
      itemTextPadding: context.appEdgeInsets(left: 16),
      selectedItemTextPadding: context.appEdgeInsets(left: 16),
    );
  }

  List<SidebarXItem> _buildItems(BuildContext context) {
    final entries = _sidebarEntries();
    return List.generate(entries.length, (i) {
      final entry = entries[i];
      return SidebarXItem(
        icon: entry.icon,
        label: entry.label,
        onTap: () => _onItemTap(context, i),
      );
    });
  }

  void _onItemTap(BuildContext context, int index) {
    context.go(AppSidebarRoutes.routes[index]);
    if (Scaffold.of(context).isDrawerOpen) {
      Navigator.pop(context);
    }
  }

  Widget _separatorBuilder(
    BuildContext context,
    int index,
    SidebarXController controller,
  ) {
    final entries = _sidebarEntries();
    // `index` here is the separator slot BEFORE entries[index + 1],
    // matching SidebarX's separatorBuilder(context, index) contract:
    // separator at `index` sits between item[index] and item[index + 1].
    final nextEntryIndex = index + 1;
    if (nextEntryIndex < entries.length) {
      final sectionLabel = entries[nextEntryIndex].sectionLabel;
      if (sectionLabel != null) {
        return _SectionLabel(title: sectionLabel, controller: controller);
      }
    }

    return context.verticalSpace(2);
  }

  Widget _headerBuilder(BuildContext context, bool extended) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: context.appEdgeInsets(
        vertical: 28,
        horizontal: extended ? 24 : 12,
      ),
      child: Row(
        mainAxisAlignment: extended
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          SizedBox(
            width: context.w(extended ? 42 : 30),
            height: context.w(extended ? 42 : 30),
            child: Image.asset(PngAssets.splashLogo, fit: BoxFit.contain),
          ),
          if (extended) ...[
            context.horizontalSpace(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SkinSync', style: context.fonts.black18w600lsNeg04),
                  Text('CLINIC PORTAL', style: context.fonts.purple9w800ls1),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, bool extended) {
    return InkWell(
      onTap: () => controller.toggleExtended(),
      hoverColor: CustomColors.purple.withValues(alpha: 0.05),
      child: Container(
        width: double.infinity,
        padding: context.appEdgeInsets(vertical: 16),
        child: Icon(
          extended
              ? Icons.arrow_back_ios_new_rounded
              : Icons.arrow_forward_ios_rounded,
          size: context.sp(16),
          color: CustomColors.grey.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final SidebarXController controller;
  const _SectionLabel({required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (!controller.extended) {
          return Padding(
            padding: context.appEdgeInsets(vertical: 8),
            child: Divider(
              color: CustomColors.border,
              indent: context.w(20),
              endIndent: context.w(20),
            ),
          );
        }
        return Padding(
          padding: context.appEdgeInsets(
            left: 28,
            top: 24,
            right: 16,
            bottom: 8,
          ),
          child: Text(title, style: context.fonts.grey11w600ls12),
        );
      },
    );
  }
}
