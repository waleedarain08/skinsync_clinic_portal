import 'base_request.dart';

class CreateRoleRequest extends BaseRequest {
  final String roleName;
  final List<RoleFeatureRequest> features;

  CreateRoleRequest({required this.roleName, required this.features});

  @override
  Map<String, dynamic> toJson() => {
    "role_name": roleName,
    "features": features.map((e) => e.toJson()).toList(),
  };
}

class RoleFeatureRequest {
  final int featureId;
  final List<int> permissionIds;

  RoleFeatureRequest({required this.featureId, required this.permissionIds});

  Map<String, dynamic> toJson() => {
    "feature_id": featureId,
    "permission_ids": permissionIds,
  };
}
