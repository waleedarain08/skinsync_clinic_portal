import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../models/user_model.dart';
import '../screens/sign_in_screen.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/theme.dart';
import '../utils/responsive.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.showLogo = false});
  final bool showLogo;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 72);
}

class _CustomAppBarState extends State<CustomAppBar> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    user = await locator<SecureStorageService>().getUser();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.topBarHeight(context),
      decoration: const BoxDecoration(
        gradient: CustomColors.purpleWhiteStateBlueLightGradient,
        border: Border(bottom: BorderSide(color: CustomColors.border, width: 1)),
      ),
      padding: context.appEdgeInsets(horizontal: 24),
      child: Row(
        children: [
          if (!context.isLandscape) _MenuButton(context: context),
          const Spacer(),
           if(!isDeploymentMode)

          const _TopBarAction(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            hasBadge: true,
          ), if(!isDeploymentMode)
          context.horizontalSpace(20),
           if(!isDeploymentMode)
          const _TopBarAction(
            icon: Icons.help_outline_rounded,
            tooltip: 'Documentation',
          ),
           if(!isDeploymentMode)
          context.horizontalSpace(20),
          const VerticalDivider(width: 1, indent: 20, endIndent: 20),
          context.horizontalSpace(20),
          _UserProfile(context: context, user: user),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final BuildContext context;
  const _MenuButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.appEdgeInsets(right: 12),
      child: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Icon(Icons.menu_rounded,
            color: CustomColors.black, size: context.sp(26)),
        style: IconButton.styleFrom(
          backgroundColor: CustomColors.whiteGrey,
          shape: RoundedRectangleBorder(
              borderRadius: context.appBorderRadius(all: 8)),
        ),
      ),
    );
  }
}

class _TopBarAction extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool hasBadge;

  const _TopBarAction({
    required this.icon,
    required this.tooltip,
    this.hasBadge = false,
  });

  @override
  State<_TopBarAction> createState() => _TopBarActionState();
}

class _TopBarActionState extends State<_TopBarAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(widget.icon, size: context.sp(24)),
              color: _hovered ? CustomColors.purple : CustomColors.grey,
              style: IconButton.styleFrom(
                backgroundColor:
                    _hovered ? CustomColors.palePurple : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: context.appBorderRadius(all: 8),
                ),
              ),
            ),
            if (widget.hasBadge)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: context.w(7),
                  height: context.w(7),
                  decoration: BoxDecoration(
                    color: CustomColors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: CustomColors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final BuildContext context;
  final UserModel? user;
  const _UserProfile({required this.context, this.user});

  @override
  Widget build(BuildContext context) {
    final String clinicName = user?.clinic?.name ?? "Clinic Portal";
    final String userRole = user?.role ?? "User";
    final String userName = user?.name ?? "Guest";
    final String userEmail = user?.email ?? "";
    final String? logoUrl = user?.clinic?.logo;

    return PopupMenuButton(
      offset: Offset(0, context.h(48)),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: context.appBorderRadius(all: 12),
        side: const BorderSide(color: CustomColors.border),
      ),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: context.appBorderRadius(all: 8),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(clinicName, style: context.fonts.black12w600),
                Text(userRole, style: context.fonts.grey10w400),
              ],
            ),
            context.horizontalSpace(12),
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: CustomColors.purple,
                borderRadius: context.appBorderRadius(all: 8),
              ),
              child: logoUrl != null && logoUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: context.appBorderRadius(all: 8),
                      child: Image.network(
                        logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person_rounded,
                            size: context.sp(22),
                            color: CustomColors.white),
                      ),
                    )
                  : Icon(Icons.person_rounded,
                      size: context.sp(22), color: CustomColors.white),
            ),
            context.horizontalSpace(4),
            Icon(Icons.keyboard_arrow_down_rounded,
                size: context.sp(16), color: CustomColors.lightGrey),
          ],
        ),
      ),
      itemBuilder: (context) => <PopupMenuEntry<void>>[
        PopupMenuItem<void>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: context.fonts.black14w600),
              Text(userEmail, style: context.fonts.grey12w400),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<void>(
          onTap: () {},
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: context.sp(18), color: CustomColors.grey),
              context.horizontalSpace(16),
              const Text('Account Profile'),
            ],
          ),
        ),
        PopupMenuItem<void>(
          onTap: () async {
            final secureStorage = locator<SecureStorageService>();
            await secureStorage.clearToken();
            if (!context.mounted) return;
            context.goNamed(SignInScreen.routeName);
          },
          child: Row(
            children: [
              Icon(Icons.logout_rounded,
                  color: CustomColors.red, size: context.sp(18)),
              context.horizontalSpace(16),
              const Text('Logout',
                  style:
                      TextStyle(color: CustomColors.red, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
