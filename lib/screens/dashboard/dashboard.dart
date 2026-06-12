import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/appointment_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/inventory_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/payment_and_wallet_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/roles_screen.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';

import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_app_bar.dart';
import 'home_screen.dart';
import 'manage_doc_injector_screen.dart';
import 'mange_staff_screen.dart';
import 'patient_management.dart';
import 'profile_screen.dart';
import 'treatment_screen.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = '/dashboard';
  final Widget child;

  const Dashboard({super.key, required this.child});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final SidebarXController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SidebarXController(selectedIndex: 0, extended: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controller state based on screen size
    if (context.isDesktop) {
      _controller.setExtended(true);
    } else if (context.isTablet) {
      // Default tablet to collapsed but allow toggle
      _controller.setExtended(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final index = _getSelectedIndex(context);
    if (_controller.selectedIndex != index) {
      _controller.selectIndex(index);
    }

    return Scaffold(
      backgroundColor: CustomColors.whiteGrey,
      // Use SidebarX as drawer on mobile/portrait
      drawer: context.isLandscape ? null : _buildSidebar(context),
      body: Row(
        children: [
          // Permanent Sidebar on landscape (Desktop/Tablet)
          if (context.isLandscape) _buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(HomeScreen.routeName)) return 0;
    if (location.startsWith(PatientManagementScreen.routeName)) return 1;
    if (location.startsWith(AppointmentScreen.routeName)) return 2;
    if (location.startsWith(TreatmentScreen.routeName)) return 3;
    if (location.startsWith(MangeDoctorsInjectorsScreen.routeName)) return 4;
    if (location.startsWith(InventoryScreen.routeName)) return 5;
    if (location.startsWith(RolesScreen.routeName)) return 6;
    if (location.startsWith(ManageStaffScreen.routeName)) return 7;
    if (location.startsWith(PaymentAndWalletScreen.routeName)) return 8;
    if (location.startsWith(ProfileScreen.routeName)) return 9;
    return 0;
  }

  Widget _buildSidebar(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: EdgeInsets.all(context.w(10)),
        padding: EdgeInsets.symmetric(vertical: context.h(20)),
        decoration: BoxDecoration(
          color: CustomColors.lightPurple2,
          borderRadius: BorderRadius.circular(context.r(10)),
        ),
        hoverColor: CustomColors.purpleHover,
        textStyle: context.fonts.grey14w500,
        selectedTextStyle: context.fonts.black14w600,
        hoverTextStyle: context.fonts.black14w600.copyWith(color: CustomColors.purple),
        itemTextPadding: EdgeInsets.only(left: context.w(15)),
        selectedItemTextPadding: EdgeInsets.only(left: context.w(15)),
        itemMargin: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
        selectedItemMargin: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(12)),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(12)),
          color: CustomColors.white,
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withValues(alpha: 0.05),
              blurRadius: context.r(10),
              offset: Offset(0, context.h(2)),
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: CustomColors.lightGrey,
          size: context.r(20),
        ),
        selectedIconTheme: IconThemeData(
          color: CustomColors.purple,
          size: context.r(20),
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: context.w(270),
        decoration: BoxDecoration(
          color: CustomColors.lightPurple2,
          borderRadius: BorderRadius.circular(context.r(10)),
        ),
        margin: EdgeInsets.all(context.w(10)),
      ),
      headerBuilder: (context, extended) {
        return Column(
          children: [
            SizedBox(height: context.h(20)),
            Image.asset(
              PngAssets.splashLogo,
              width: context.r(48),
              height: context.r(48),
            ),
            if (extended) ...[
              SizedBox(height: context.h(10)),
              Image.asset(PngAssets.logo, height: context.r(20)),
            ],
            SizedBox(height: context.h(30)),
          ],
        );
      },
      items: [
        _buildSidebarItem(context, 'Home', Iconsax.home_2, HomeScreen.routeName),
        _buildSidebarItem(context, 'Patient Management', Iconsax.profile_2user, PatientManagementScreen.routeName),
        _buildSidebarItem(context, 'Appointments', Iconsax.calendar, AppointmentScreen.routeName),
        _buildSidebarItem(context, 'Treatments', Icons.vaccines_outlined, TreatmentScreen.routeName),
        _buildSidebarItem(context, 'Doctors / Injectors', Icons.masks_outlined, MangeDoctorsInjectorsScreen.routeName),
        _buildSidebarItem(context, 'Inventory', Icons.inventory, InventoryScreen.routeName),
        _buildSidebarItem(context, 'Roles', Icons.person_outline, RolesScreen.routeName),
        _buildSidebarItem(context, 'Staff', Iconsax.user_octagon, ManageStaffScreen.routeName),
        _buildSidebarItem(context, 'Payments & Wallets', Iconsax.wallet_3, PaymentAndWalletScreen.routeName),
        _buildSidebarItem(context, 'Profile', Iconsax.profile_circle, ProfileScreen.routeName),
      ],
    );
  }

  SidebarXItem _buildSidebarItem(BuildContext context, String label, IconData icon, String route) {
    return SidebarXItem(
      icon: icon,
      label: label,
      onTap: () {
        context.go(route);
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.pop(context);
        }
      },
    );
  }
}
