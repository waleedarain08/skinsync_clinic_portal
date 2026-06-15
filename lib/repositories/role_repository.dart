import '../models/requests/create_role_request_model.dart';
import '../models/requests/update_role_request.dart';
import '../models/responses/base_response_model.dart';
import '../models/responses/get_feature_response.dart';
import '../models/responses/get_roles_response.dart';

abstract class RoleRepository {
  Future<GetFeatureResponse> fetchFeature();
  Future<BaseResponse> registerRole({required CreateRoleRequest request});
  Future<GetRoleResponse> fetchRole();
  Future<BaseResponse> updateRole({
    required UpdateRoleRequest request,
    required String roleId,
  });
}
