import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/appointment_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/inventory_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/payment_and_wallet_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/roles_screen.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';
import 'package:skinsync_clinic_portal/widgets/app_sidebar.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';

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
  bool? _wasDesktop;

  @override
  void initState() {
    super.initState();
    _controller = SidebarXController(selectedIndex: 0, extended: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update controller state only when crossing desktop/tablet threshold
    final isDesktop = context.isDesktop;
    if (_wasDesktop != isDesktop) {
      _wasDesktop = isDesktop;
      _controller.setExtended(isDesktop);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final index = AppSidebarRoutes.indexOf(GoRouterState.of(context).matchedLocation);
    if (_controller.selectedIndex != index && index != -1) {
      _controller.selectIndex(index);
    }

    return GradientScaffold(
      // Use SidebarX as drawer on mobile/portrait
      drawer: context.isLandscape ? null : AppSidebar(controller: _controller),
      body: Row(
        children: [
          // Permanent Sidebar on landscape (Desktop/Tablet)
          if (context.isLandscape) AppSidebar(controller: _controller),
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
}
