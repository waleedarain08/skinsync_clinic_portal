

import '../models/responses/filters_response.dart';
import '../repositories/provider_role_repository.dart';
import '../utils/enums.dart';
import '../utils/exception.dart';
import 'api_base_helper.dart';

class ProviderRolesService implements ProviderRoleRepository {
  final ApiBaseService _api;

  ProviderRolesService({required ApiBaseService api}) : _api = api;

  @override
  Future<FiltersResponse> providerRoles() async {
    final jsonResponse = await _api.httpRequest(
      requestType: RequestType.get,
      endPoint:  Endpoint.providerRoles);
    final response = FiltersResponse.fromJson(jsonResponse);
    if (!response.success) {
      throw BadRequestException(response.message);
    }
    return response;
  }
}
