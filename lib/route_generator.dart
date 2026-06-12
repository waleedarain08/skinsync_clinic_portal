import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/models/responses/register_doctor_response.dart';
import 'package:skinsync_clinic_portal/screens/about_screen.dart';
import 'package:skinsync_clinic_portal/screens/business_info_screen.dart';
import 'package:skinsync_clinic_portal/screens/change_password_screen.dart';
import 'package:skinsync_clinic_portal/screens/create_staff_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/inventory_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/manage_doc_injector_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/mange_staff_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/patient_management_detail.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/payment_history_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/profile_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/roles_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/treatment_screen.dart';
import 'package:skinsync_clinic_portal/screens/dynamic_pricing.dart';
import 'package:skinsync_clinic_portal/screens/notification_screen.dart';
import 'package:skinsync_clinic_portal/screens/sign_in_screen.dart';
import 'package:skinsync_clinic_portal/screens/signup_screen.dart';
import 'package:skinsync_clinic_portal/screens/update_treatment_screen.dart';
import 'package:skinsync_clinic_portal/screens/clinic_add_treatment_screen.dart';
import 'package:skinsync_clinic_portal/services/storage_service.dart';

import 'app_init.dart';
import 'screens/add_doctor_injector_screen.dart';
import 'screens/create_treatment_screen.dart';
import 'screens/dashboard/appointment_screen.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/dashboard/patient_ai_management.dart';
import 'screens/dashboard/patient_management.dart';
import 'screens/dashboard/payment_and_wallet_screen.dart';
import 'screens/splash_screen.dart';
import 'services/locator.dart';

class RouteGenerator {
  static final List<String> _authRoutes = [
    SplashScreen.routeName,
    SignInScreen.routeName,
    SignUpScreen.routeName,
  ];
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final route = state.uri.toString();
      log('PAGE: ${state.uri}');
      if (_authRoutes.contains(route)) {
        return null;
      }
      final token = await locator<SecureStorageService>().getToken();
      if (token == null) {
        return SignInScreen.routeName;
      }
      return null;
    },
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        name: SplashScreen.routeName,
        path: SplashScreen.routeName,
        builder: (_, _) => SplashScreen(),
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: SignInScreen.routeName,
        builder: (_, _) => SignInScreen(),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeName,
        builder: (_, _) => SignUpScreen(),
      ),
      ShellRoute(
        builder: (_, _, child) {
          return Dashboard(child: child);
        },
        routes: [
          GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routeName,
            builder: (_, _) => HomeScreen(),
          ),
          GoRoute(
            name: PatientAiManagementScreen.routeName,
            path: PatientAiManagementScreen.routeName,
            builder: (_, _) => PatientAiManagementScreen(),
          ),
          GoRoute(
            name: PatientManagementScreen.routeName,
            path: PatientManagementScreen.routeName,
            builder: (_, _) => PatientManagementScreen(),
            routes: [
              GoRoute(
                name: PatientManagementDetailScreen.path,
                path: PatientManagementDetailScreen.path,
                builder: (_, _) => PatientManagementDetailScreen(),
              ),
            ],
          ),
          GoRoute(
            name: AppointmentScreen.routeName,
            path: AppointmentScreen.routeName,
            builder: (_, _) => AppointmentScreen(),
          ),
          GoRoute(
            name: ManageStaffScreen.routeName,
            path: ManageStaffScreen.routeName,
            builder: (_, _) => ManageStaffScreen(),
          ),
          GoRoute(
            name: InventoryScreen.routeName,
            path: InventoryScreen.routeName,
            builder: (_, _) => InventoryScreen(),
          ),
          GoRoute(
            name: RolesScreen.routeName,
            path: RolesScreen.routeName,
            builder: (_, _) => RolesScreen(),
          ),
          GoRoute(
            name: MangeDoctorsInjectorsScreen.routeName,
            path: MangeDoctorsInjectorsScreen.routeName,
            builder: (_, _) => MangeDoctorsInjectorsScreen(),
          ),

          GoRoute(
            name: PaymentAndWalletScreen.routeName,
            path: PaymentAndWalletScreen.routeName,
            builder: (_, _) => PaymentAndWalletScreen(),
          ),
          GoRoute(
            name: PaymentHistoryScreen.routeName,
            path: PaymentHistoryScreen.routeName,
            builder: (_, _) => PaymentHistoryScreen(),
          ),
          GoRoute(
            name: ProfileScreen.routeName,
            path: ProfileScreen.routeName,
            builder: (_, _) => ProfileScreen(),
          ),
          GoRoute(
            name: TreatmentScreen.routeName,
            path: TreatmentScreen.routeName,
            builder: (_, _) => TreatmentScreen(),
          ),
          GoRoute(
            name: ClinicAddTreatmentScreen.routeName,
            path: ClinicAddTreatmentScreen.routeName,
            builder: (_, _) => ClinicAddTreatmentScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AddDoctorInjectorScreen.routeName,
        name: AddDoctorInjectorScreen.routeName,
        builder: (_, state) {
          final doctor = state.extra as Doctor?;
          return AddDoctorInjectorScreen(doctor: doctor);
        },
      ),
      GoRoute(
        name: CreateTreatmentScreen.routeName,
        path: CreateTreatmentScreen.routeName,
        builder: (_, _) => CreateTreatmentScreen(),
      ),
      GoRoute(
        name: BusinessInformationScreen.routeName,
        path: BusinessInformationScreen.routeName,
        builder: (_, _) => BusinessInformationScreen(),
      ),
      GoRoute(
        name: ChangePasswordScreen.routeName,
        path: ChangePasswordScreen.routeName,
        builder: (_, _) => ChangePasswordScreen(),
      ),
      GoRoute(
        name: AboutScreen.routeName,
        path: AboutScreen.routeName,
        builder: (_, _) => AboutScreen(),
      ),
      GoRoute(
        name: NotificationScreen.routeName,
        path: NotificationScreen.routeName,
        builder: (_, _) => NotificationScreen(),
      ),
      GoRoute(
        name: CreateStaffScreen.routeName,
        path: CreateStaffScreen.routeName,
        builder: (_, _) => CreateStaffScreen(),
      ),
      GoRoute(
        name: UpdateTreatmentScreen.routeName,
        path: UpdateTreatmentScreen.routeName,
        builder: (_, _) => UpdateTreatmentScreen(),
      ),

      GoRoute(
        path: DynamicPricing.routeName,
        name: DynamicPricing.routeName,
        builder: (_, _) => DynamicPricing(),
      ),
    ],
  );
}
