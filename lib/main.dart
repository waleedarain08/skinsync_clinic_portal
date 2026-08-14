import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'app_init.dart';
import 'firebase_options.dart';
import 'services/locator.dart';


bool isDeploymentMode = true;


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ScreenUtilPlus.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeServices();
  Stripe.publishableKey = 'pk_test_51RZrW32UDQ1Rzrd8uNB07ptQPHxECWTfB4ZZF6ZCgiFyfWBpBGdQhSSlD7J3u79aMSzQCAeVgI30pnA8iyNekaA500go9X7wD7';

  runApp(const ProviderScope(child: AppInit()));
}
