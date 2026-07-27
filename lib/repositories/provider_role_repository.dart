
import '../models/responses/filters_response.dart';

abstract class ProviderRoleRepository {
  Future<FiltersResponse> providerRoles();
}