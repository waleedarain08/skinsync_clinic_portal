
import '../models/responses/provider_roles_response.dart';

abstract class ProviderRoleRepository {
  Future<ProviderRolesResponse> providerRoles();
}