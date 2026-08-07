import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';

import '../screens/dashboard/appointment_screen.dart';
import '../screens/dashboard/forms_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/dashboard/inventory_screen.dart';
import '../screens/dashboard/mange_staff_screen.dart';
import '../screens/dashboard/patient_management.dart';
import '../screens/dashboard/payment_and_wallet_screen.dart';
import '../screens/dashboard/profile_screen.dart';
import '../screens/dashboard/roles_screen.dart';
import '../screens/dashboard/treatment_screen.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';

abstract final class AppSidebarRoutes {
  static const routes = <String>[
    HomeScreen.routeName,
    PatientManagementScreen.routeName,
    AppointmentScreen.routeName,
    TreatmentScreen.routeName,
    InventoryScreen.routeName,
    FormsScreen.routeName,
    RolesScreen.routeName,
    ManageStaffScreen.routeName,
    PaymentAndWalletScreen.routeName,
    ProfileScreen.routeName,
  ];

  static int indexOf(String location) {
    final exact = routes.indexOf(location);
    if (exact >= 0) return exact;
    for (var i = 0; i < routes.length; i++) {
      if (location.startsWith(routes[i])) return i;
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
    return [
      SidebarXItem(
        icon: Iconsax.home_2,
        label: 'Home',
        onTap: () => _onItemTap(context, 0),
      ),
      SidebarXItem(
        icon: Iconsax.profile_2user,
        label: 'Patient Management',
        onTap: () => _onItemTap(context, 1),
      ),
      SidebarXItem(
        icon: Iconsax.calendar,
        label: 'Appointments',
        onTap: () => _onItemTap(context, 2),
      ),
      SidebarXItem(
        icon: Icons.vaccines_outlined,
        label: 'Treatments',
        onTap: () => _onItemTap(context, 3),
      ),
      SidebarXItem(
        icon: Icons.inventory,
        label: 'Inventory',
        onTap: () => _onItemTap(context, 4),
      ),
      SidebarXItem(
        icon: Icons.document_scanner,
        label: 'Forms',
        onTap: () => _onItemTap(context, 5),
      ),
      SidebarXItem(
        icon: Icons.person_outline,
        label: 'Roles',
        onTap: () => _onItemTap(context, 6),
      ),
      SidebarXItem(
        icon: Iconsax.user_octagon,
        label: 'Staff',
        onTap: () => _onItemTap(context, 7),
      ),
      SidebarXItem(
        icon: Iconsax.wallet_3,
        label: 'Payments & Wallets',
        onTap: () => _onItemTap(context, 8),
      ),
      SidebarXItem(
        icon: Iconsax.profile_circle,
        label: 'Profile',
        onTap: () => _onItemTap(context, 9),
      ),
    ];
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
    if (index == 2) {
      return _SectionLabel(title: 'CLINICAL', controller: controller);
    }
    if (index == 3) {
      return _SectionLabel(title: 'OPERATIONS', controller: controller);
    }
    if (index == 7) {
      return _SectionLabel(title: 'FINANCIALS', controller: controller);
    }
    if (index == 8) {
      return _SectionLabel(title: 'SYSTEM', controller: controller);
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
