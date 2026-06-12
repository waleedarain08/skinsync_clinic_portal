import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/models/user_model.dart';

import '../screens/sign_in_screen.dart';
import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/assets.dart';
import '../utils/responsive.dart';
import '../utils/theme.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showLogo;
  const CustomAppBar({super.key, this.showLogo = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 101);
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
      height: context.h(101),
      color: CustomColors.white,
      constraints: BoxConstraints(minHeight: context.h(101)),
      padding: EdgeInsets.symmetric(horizontal: context.w(30)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showLogo)
            Row(
              children: [
                Image.asset(PngAssets.splashLogo, width: context.w(40)),
                SizedBox(width: context.w(10)),
                Image.asset(PngAssets.logo),
                SizedBox(width: context.w(15)),
              ],
            ),
          context.isLandscape
              ? SizedBox(
                  width: context.r(380),
                  child: const CupertinoSearchTextField(
                    backgroundColor: CustomColors.softGrey,
                  ),
                )
              : _buildMobileActions(context),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(CupertinoIcons.bell, size: context.r(24)),
          ),
          context.isLandscape ? SizedBox(width: context.r(30)) : const SizedBox.shrink(),
          context.isLandscape
              ? ClipOval(
                  child: Image.network(
                    user?.clinic?.logo ?? "",
                    width: context.r(44),
                    height: context.r(44),
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: context.r(22));
                    },
                  ),
                )
              : const SizedBox.shrink(),

          context.isLandscape
              ? Row(
                  children: [
                    SizedBox(width: context.w(20)),
                    Text(user?.name ?? "N/A", style: CustomFonts.black16w600),
                    SizedBox(width: context.w(20)),
                    PopupMenuButton(
                      offset: Offset(0, context.h(40)),
                      icon: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: context.r(18),
                        color: CustomColors.black,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          height: context.h(40),
                          onTap: () async {
                            final secureStorage = locator<SecureStorageService>();
                            await secureStorage.clearToken();
                            if (!context.mounted) return;
                            context.goNamed(SignInScreen.routeName);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: CustomColors.red,
                                size: context.r(18),
                              ),
                              SizedBox(width: context.w(8)),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: CustomColors.red,
                                  fontSize: context.sp(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildMobileActions(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu),
        ),
        SizedBox(width: context.w(10)),
        context.isLandscape
            ? Image.asset(PngAssets.splashLogo, width: context.r(48), height: context.r(48))
            : ClipOval(
                child: Image.asset(PngAssets.person, width: context.r(44), height: context.r(44)),
              ),
        SizedBox(width: context.w(5)),
        Text("Scarlet Fox", style: CustomFonts.black20w600),
        SizedBox(width: context.w(40)),
        PopupMenuButton(
          offset: Offset(0, context.h(40)),
          icon: Icon(
            Icons.arrow_drop_down_circle_outlined,
            size: context.r(18),
            color: CustomColors.black,
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              height: context.h(40),
              onTap: () {},
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, color: CustomColors.red, size: context.r(18)),
                  SizedBox(width: context.w(8)),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: CustomColors.red,
                      fontSize: context.sp(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
