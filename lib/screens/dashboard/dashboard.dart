import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';
import '../../utils/responsive.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/gradient_scaffold.dart';

import '../../widgets/custom_app_bar.dart';

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
