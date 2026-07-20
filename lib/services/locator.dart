import 'package:get_it/get_it.dart';

import '../repositories/auth_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/provider_role_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/treatment_repository.dart';
import 'api_base_helper.dart';
import 'appointment_service.dart';
import 'auth_service.dart';
import 'doctor_service.dart';
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
  locator.registerLazySingleton(() => MediaService());
  locator.registerLazySingleton(() => DoctorService());
  locator.registerLazySingleton(() => RoleService());
  locator.registerLazySingleton(() => AppointmentService());
  locator.registerSingleton(apiBaseHelper);
}
