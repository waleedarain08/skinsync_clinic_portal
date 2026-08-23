import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../widgets/gradient_scaffold.dart';
import '../widgets/header__with_back_btn.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  static const String routeName = '/About';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int selectedTab = 0; // 0 = Terms & Conditions, 1 = Privacy Policy

  static const String _termsUrl = 'https://skinsyncai.com/terms-of-service/';
  static const String _privacyUrl = 'https://skinsyncai.com/privacy-policy/';

  static const String _termsViewType = 'skinsync-terms-iframe';
  static const String _privacyViewType = 'skinsync-privacy-iframe';

  bool _termsLoaded = false;
  bool _privacyLoaded = false;
  bool _viewsRegistered = false;

  @override
  void initState() {
    super.initState();
    _registerIframeViews();
  }

  void _registerIframeViews() {
    if (_viewsRegistered) return;
    _viewsRegistered = true;

    ui_web.platformViewRegistry.registerViewFactory(_termsViewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = _termsUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..onLoad.listen((_) {
          if (mounted) setState(() => _termsLoaded = true);
        });
      return iframe;
    });

    ui_web.platformViewRegistry.registerViewFactory(_privacyViewType, (int viewId) {
      final iframe = web.HTMLIFrameElement()
        ..src = _privacyUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..onLoad.listen((_) {
          if (mounted) setState(() => _privacyLoaded = true);
        });
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              const BuildHeader(title: 'About'),
              // Divider
              SizedBox(height: context.h(16)),

              const Divider(height: 1, thickness: 1, color: CustomColors.border),

              SizedBox(height: context.h(16)),

              // Tab Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                child: Container(
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTab(
                          title: 'Terms & Conditions',
                          isSelected: selectedTab == 0,
                          onTap: () => setState(() => selectedTab = 0),
                        ),
                      ),
                      Expanded(
                        child: _buildTab(
                          title: 'Privacy Policy',
                          isSelected: selectedTab == 1,
                          onTap: () => setState(() => selectedTab = 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.h(24)),

              // Content based on selected tab — embeds the live page
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(12)),
                    color: CustomColors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IndexedStack(
                    index: selectedTab,
                    children: [
                      _buildIframePane(
                        viewType: _termsViewType,
                        loaded: _termsLoaded,
                      ),
                      _buildIframePane(
                        viewType: _privacyViewType,
                        loaded: _privacyLoaded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIframePane({required String viewType, required bool loaded}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        HtmlElementView(viewType: viewType),
        if (!loaded)
          Container(
            color: CustomColors.white,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.isLandscape ? context.w(16) : context.w(6),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? CustomColors.black : Colors.transparent,
            width: context.r(1),
          ),
          color: isSelected ? CustomColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(context.r(6)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CustomColors.black.withValues(alpha: 0.05),
                    blurRadius: context.r(4),
                    offset: Offset(0, context.h(2)),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: CustomFonts.black14w600,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}