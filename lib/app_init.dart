import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'route_generator.dart';
import 'widgets/app_loader.dart';
import 'package:timetable/timetable.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/screen_size.dart';
import 'utils/theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppInit extends StatelessWidget {
  const AppInit({super.key});

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 40.0
      ..radius = 12.0
      ..progressColor = CustomColors.white
      ..backgroundColor = CustomColors.white
      ..indicatorColor = CustomColors.green
      ..textColor = CustomColors.black
      ..maskColor = Colors.transparent
      ..indicatorWidget = const AppLoader(size: 40)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  @override
  Widget build(BuildContext context) {
    configLoading();

    return ScreenUtilPlusInit(
      designSize: getDesignSize(context),
      ensureScreenSize: true,
      minTextAdapt: true,
      splitScreenMode: true,
      autoRebuild: false,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'SkinSync Clinic',
          routerConfig: RouteGenerator.router,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          localizationsDelegates: const [
            TimetableLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          builder: (context, child) {
            return EasyLoading.init()(context, child);
          },
        );
      },
    );
  }
}
