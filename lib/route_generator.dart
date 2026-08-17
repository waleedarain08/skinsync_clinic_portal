import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'app_init.dart';
import 'models/responses/register_practitioner_response.dart';
import 'screens/about_screen.dart';
import 'screens/add_practitioner_screen.dart';
import 'screens/business_info_screen.dart';
import 'screens/change_password_screen.dart';
import 'screens/add_treatment_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/create_appointment_screen.dart';
import 'screens/create_session_screen.dart';
import 'screens/create_staff_screen.dart';
import 'screens/create_treatment_screen.dart';
import 'screens/dashboard/add_administration_staff_screen.dart';
import 'screens/dashboard/administration_staff_detail_screen.dart';
import 'screens/dashboard/appointment_detail_screen.dart';
import 'screens/dashboard/appointment_screen.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/dashboard/forms_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/dashboard/inventory_screen.dart';
import 'screens/dashboard/manage_practitioner_screen.dart';
import 'screens/dashboard/mange_staff_screen.dart';
import 'screens/dashboard/patient_ai_management.dart';
import 'screens/dashboard/patient_management.dart';
import 'screens/dashboard/patient_management_detail.dart';
import 'screens/dashboard/payment_and_wallet_screen.dart';
import 'screens/dashboard/payment_history_screen.dart';
import 'screens/dashboard/profile_screen.dart';
import 'screens/dashboard/roles_screen.dart';
import 'screens/dashboard/treatment_detail_screen.dart';
import 'screens/dashboard/treatment_screen.dart';
import 'screens/dashboard/appointment_treatment_detail_screen.dart';
import 'screens/dashboard/practitioner_detail_screen.dart';
import 'screens/dynamic_pricing.dart';
import 'screens/explore_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/lot_items_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/update_treatment_screen.dart';
import 'services/locator.dart';
import 'services/storage_service.dart';

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
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        name: SignInScreen.routeName,
        path: SignInScreen.routeName,
        builder: (_, _) => const SignInScreen(),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeName,
        builder: (_, _) => const SignUpScreen(),
      ),
      ShellRoute(
        builder: (_, _, child) {
          return Dashboard(child: child);
        },
        routes: [
          GoRoute(
            name: HomeScreen.routeName,
            path: HomeScreen.routeName,
            builder: (_, _) =>const HomeScreen(),
          ),
           GoRoute(
            name: ExploreScreen.routeName,
            path: ExploreScreen.routeName,
            builder: (_, _) => const ExploreScreen(),
          ),
          GoRoute(
            name: PatientAiManagementScreen.routeName,
            path: PatientAiManagementScreen.routeName,
            builder: (_, _) => const PatientAiManagementScreen(),
          ),
          GoRoute(
            name: PatientManagementScreen.routeName,
            path: PatientManagementScreen.routeName,
            builder: (_, _) => const PatientManagementScreen(),
            routes: [
              GoRoute(
                name: PatientManagementDetailScreen.path,
                path: PatientManagementDetailScreen.path,
                builder: (_, state) {
                  final patientId = state.extra as int?;
                  return PatientManagementDetailScreen(patientId: patientId);
                },
              ),
            ],
          ),
           GoRoute(
            name: ProductDetailScreen.routeName,
            path: ProductDetailScreen.routeName,
            builder: (_, _) => const ProductDetailScreen(),
          ),
          GoRoute(
            name: LotItemsScreen.routeName,
            path: LotItemsScreen.routeName,
            builder: (_, _) => const LotItemsScreen(),
          ),
          GoRoute(
            name: AppointmentScreen.routeName,
            path: AppointmentScreen.routeName,
            builder: (_, _) => const AppointmentScreen(),
          ),
          GoRoute(
            name: AppointmentDetailScreen.routeName,
            path: AppointmentDetailScreen.routeName,
            builder: (_, state) => const AppointmentDetailScreen(),
          ),
          GoRoute(
            name: FormsScreen.routeName,
            path: FormsScreen.routeName,
            builder: (_, _) => const FormsScreen(),
          ),
          GoRoute(
            name: ManageStaffScreen.routeName,
            path: ManageStaffScreen.routeName,
            builder: (_, _) => const ManageStaffScreen(),
          ),
          GoRoute(
            name: InventoryScreen.routeName,
            path: InventoryScreen.routeName,
            builder: (_, _) => const InventoryScreen(),
          ),
          GoRoute(
            name: RolesScreen.routeName,
            path: RolesScreen.routeName,
            builder: (_, _) => const RolesScreen(),
          ),
          GoRoute(
            name: ManagePractitionerScreen.routeName,
            path: ManagePractitionerScreen.routeName,
            builder: (_, _) => const ManagePractitionerScreen(),
          ),
          GoRoute(
            name: AddAdministrationStaffScreen.routeName,
            path: AddAdministrationStaffScreen.routeName,
            builder: (_, _) => const AddAdministrationStaffScreen(),
          ),
          GoRoute(
            name: AdministrationStaffDetailScreen.routeName,
            path: AdministrationStaffDetailScreen.routeName,
            builder: (_, _) => const AdministrationStaffDetailScreen(),
          ),
          GoRoute(
            name: PractitionerDetailScreen.routeName,
            path: PractitionerDetailScreen.routeName,
            builder: (_, state) => const PractitionerDetailScreen(),
          ),

          GoRoute(
            name: PaymentAndWalletScreen.routeName,
            path: PaymentAndWalletScreen.routeName,
            builder: (_, _) => const PaymentAndWalletScreen(),
          ),
          GoRoute(
            name: PaymentHistoryScreen.routeName,
            path: PaymentHistoryScreen.routeName,
            builder: (_, _) => const PaymentHistoryScreen(),
          ),
          GoRoute(
            name: ProfileScreen.routeName,
            path: ProfileScreen.routeName,
            builder: (_, _) => const ProfileScreen(),
          ),
          GoRoute(
            name: TreatmentScreen.routeName,
            path: TreatmentScreen.routeName,
            builder: (_, _) => const TreatmentScreen(),
          ),
          GoRoute(
            name: CreateSessionScreen.routeName,
            path: CreateSessionScreen.routeName,
            builder: (_, _) => const CreateSessionScreen(),
          ),
          GoRoute(
            name: CreateAppointmentScreen.routeName,
            path: CreateAppointmentScreen.routeName,
            builder: (_, _) => const CreateAppointmentScreen(),
          ),
            GoRoute(
            name: TreatmentDetailScreen.routeName,
            path: TreatmentDetailScreen.routeName,
            builder: (_, state) {
            //  final treatment = state.extra as model_treatment.TreatmentModel;
              return const TreatmentDetailScreen();
            },
          ),
          GoRoute(
            name: AppointmentTreatmentDetailScreen.routeName,
            path: AppointmentTreatmentDetailScreen.routeName,
            builder: (_, state) {
              final treatmentId = state.extra as int? ?? 0;
              return AppointmentTreatmentDetailScreen(treatmentId: treatmentId);
            },
          ),
          GoRoute(
            name: AddTreatmentScreen.routeName,
            path: AddTreatmentScreen.routeName,
            builder: (_, _) => const AddTreatmentScreen(),
          ),
          GoRoute(
            path: AddPractitionerScreen.routeName,
            name: AddPractitionerScreen.routeName,
            builder: (_, state) {
              final practitioner = state.extra as Practitioner?;
              return AddPractitionerScreen(practitioner: practitioner);
            },
          ),
          GoRoute(
            path: AddProductScreen.routeName,
            name: AddProductScreen.routeName,
            builder: (_, _) => const AddProductScreen(),
          ),
        ],
      ),
      GoRoute(
        name: CreateTreatmentScreen.routeName,
        path: CreateTreatmentScreen.routeName,
        builder: (_, _) => const CreateTreatmentScreen(),
      ),
      GoRoute(
        name: BusinessInformationScreen.routeName,
        path: BusinessInformationScreen.routeName,
        builder: (_, _) => const BusinessInformationScreen(),
      ),
      GoRoute(
        name: ChangePasswordScreen.routeName,
        path: ChangePasswordScreen.routeName,
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        name: AboutScreen.routeName,
        path: AboutScreen.routeName,
        builder: (_, _) => const AboutScreen(),
      ),
      GoRoute(
        name: NotificationScreen.routeName,
        path: NotificationScreen.routeName,
        builder: (_, _) => const NotificationScreen(),
      ),
      GoRoute(
        name: CreateStaffScreen.routeName,
        path: CreateStaffScreen.routeName,
        builder: (_, _) => const CreateStaffScreen(),
      ),
      GoRoute(
        name: UpdateTreatmentScreen.routeName,
        path: UpdateTreatmentScreen.routeName,
        builder: (_, _) => const UpdateTreatmentScreen(),
      ),

      GoRoute(
        path: DynamicPricing.routeName,
        name: DynamicPricing.routeName,
        builder: (_, _) => const DynamicPricing(),
      ),
    ],
  );
}
