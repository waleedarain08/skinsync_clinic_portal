import 'dart:developer';

import '../models/requests/create_role_request_model.dart';
import '../models/requests/update_role_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/get_feature_response.dart';
import '../models/responses/get_roles_response.dart';
import '../repositories/role_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class RoleService extends RoleRepository {
  @override
  Future<GetFeatureResponse> fetchFeature() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.getFeature,
      requestType: RequestType.get,
    );
    final model = GetFeatureResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<GetRoleResponse> fetchRole() async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.roles,
      requestType: RequestType.get,
    );
    final model = GetRoleResponse.fromJson(response);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<BaseResponse> registerRole({
    required CreateRoleRequest request,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.roles,
      requestType: RequestType.post,
      requestBody: request,
    );
    log('RESPONSE: $response');
    final model = BaseResponse.fromJson(response, (json) => json);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }

  @override
  Future<BaseResponse> updateRole({
    required UpdateRoleRequest request,
    required String roleId,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.roles,
      requestType: RequestType.put,
      requestBody: request,
      queryParams: {"id": roleId},
    );
    log('RESPONSE: $response');
    final model = BaseResponse.fromJson(response, (json) => json);
    if (!model.success) {
      throw Exception(model.message);
    }
    return model;
  }
}
