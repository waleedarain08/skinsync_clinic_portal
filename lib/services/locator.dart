import 'package:get_it/get_it.dart';
import '../repositories/notification_repository.dart';
import 'firebase_notification_service.dart';

import '../repositories/auth_repository.dart';
import '../repositories/explore_repository.dart';
import '../repositories/patient_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/provider_role_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/treatment_repository.dart';
import 'api_base_helper.dart';
import 'appointment_service.dart';
import 'area_services.dart';
import 'auth_service.dart';
import 'explore_service.dart';
import 'notification_service.dart';
import 'patient_service.dart';
import 'practitioner_service.dart';
import '../view_models/forms_controller.dart';
import 'media_service.dart';
import 'product_services.dart';
import 'provider_roles_service.dart';
import 'role_service.dart';
import 'session_service.dart';
import 'storage_service.dart';
import 'treatment_services.dart';

final locator = GetIt.instance;

Future<void> initializeServices() async {
  await locator.reset();

  /// Services
  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);

  final formsController = FormsController();
  await formsController.init();
  locator.registerSingleton(formsController);

  final apiBaseHelper = ApiBaseService();
  locator.registerLazySingleton<AuthRepository>(
    () => AuthService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<TreatmentRepository>(
    () => TreatmentServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<SessionRepository>(
    () => SessionServices(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductServices(api: apiBaseHelper),
  );
   locator.registerLazySingleton<ProviderRoleRepository>(
    () => ProviderRolesService(api: apiBaseHelper),
  );
  locator.registerLazySingleton<ExploreRepository>(
    () => ExploreService(),
  );
   locator.registerLazySingleton<NotificationRepository>(
    () => NotificationService(),
  );
   locator.registerLazySingleton<PatientRepository>(
    () => PatientService(),
  );
  locator.registerLazySingleton(() => MediaService());
  locator.registerLazySingleton(() => PractitionerService());
  locator.registerLazySingleton(() => RoleService());
  locator.registerLazySingleton(() => AppointmentService());
  locator.registerLazySingleton(() => AreaServices());

  // Notification service (initializes FirebaseMessaging + local notifications)
  final firebaseNotificationService = FireBaseNotificationService();
  await firebaseNotificationService.init();
  locator.registerSingleton(firebaseNotificationService);

  locator.registerSingleton(apiBaseHelper);
}
