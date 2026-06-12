import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/screens/sign_in_screen.dart';
import 'package:skinsync_clinic_portal/view_models/auth_view_model.dart';

import '../services/locator.dart';
import '../services/storage_service.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'dashboard/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  static const String routeName = '/';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _animate = false;
  final int _duration = 1000; // animation duration

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: _duration));
      if (mounted) {
        setState(() {
          _animate = true;
        });
      }

      await Future.delayed(Duration(milliseconds: _duration - 800));

      if (mounted) {
        if (locator<SecureStorageService>().isLoggedIn) {
          await ref
              .read(authViewModelProvider.notifier)
              .callGetMe()
              .then((value) {
            if (value) {
              context.goNamed(HomeScreen.routeName);
            } else {
              context.goNamed(SignInScreen.routeName);
            }
          });
        } else {
          context.goNamed(SignInScreen.routeName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: CustomColors.purpleWhiteStateBlueLightGradient,
            ),
          ),
          AnimatedOpacity(
            opacity: _animate ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: Center(
              child: Image.asset(
                PngAssets.splashLogo,
                height: context.h(169),
                width: context.w(169),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            top: _animate ? screenHeight : -screenHeight,
            left: _animate ? screenWidth : -context.r(362),
            child: CircleAvatar(
              radius: context.r(362),
              backgroundColor: CustomColors.paleBlue,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            bottom: _animate ? screenHeight : -screenHeight,
            right: _animate ? screenWidth : -context.r(362),
            child: CircleAvatar(
              radius: context.r(362),
              backgroundColor: CustomColors.lightPurple,
            ),
          ),
        ],
      ),
    );
  }
}
