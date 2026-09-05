import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../models/responses/messages_response.dart';
import '../../services/websocket_service.dart';
import '../../utils/enums.dart';
import '../../utils/responsive.dart';
import '../../view_models/chat_view_model.dart';
import '../../widgets/app_sidebar.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/gradient_scaffold.dart';

class Dashboard extends ConsumerStatefulWidget {
  static const String routeName = '/dashboard';
  final Widget child;

  const Dashboard({super.key, required this.child});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late final SidebarXController _controller;
  bool? _wasDesktop;
  final _wsInstance = WebSocketService();

  @override
  void initState() {
    super.initState();
    _controller = SidebarXController(selectedIndex: 0, extended: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _wsInstance.connect(
        onEvent: (event) {
          try {
            switch (event.type) {
              case EventType.chat:
                final message = Message.fromJson(event.data);
                if (ref.exists(chatProvider)) {
                  ref.read(chatProvider.notifier).addMessage(message);
                }
                break;
              case EventType.subscription:
                // TODO: Handle this case.
                throw UnimplementedError();
            }
          } catch (_) {
            log('Ignoring parsing errors');
          }
        },
      );
    });
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
  void dispose() {
    _wsInstance.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sync index with current route
    final index = AppSidebarRoutes.indexOf(
      GoRouterState.of(context).matchedLocation,
    );
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
