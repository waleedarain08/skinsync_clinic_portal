import 'package:skinsync_clinic_portal/models/responses/base_response_model.dart';

class GetRoleResponse extends BaseApiResponseModel<List<Roles>> {
  GetRoleResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });

  factory GetRoleResponse.fromJson(Map<String, dynamic> json) =>
      GetRoleResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["roles"] == null
            ? []
            : List<Roles>.from(json["roles"]!.map((x) => Roles.fromJson(x))),
      );
}

class Roles {
  String? roleId;
  String? roleName;
  List<Features>? features;

  Roles({this.roleId, this.roleName, this.features});

  Roles.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(Features.fromJson(v));
      });
    }
  }
}

class Features {
  int? featureId;
  String? featureTitle;
  List<int>? activePermissionIds;
  List<Permissions>? permissions;

  Features({
    this.featureId,
    this.featureTitle,
    this.activePermissionIds,
    this.permissions,
  });

  Features.fromJson(Map<String, dynamic> json) {
    featureId = json['feature_id'];
    featureTitle = json['feature_title'];
    activePermissionIds = json['active_permission_ids'].cast<int>();
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permissions.fromJson(v));
      });
    }
  }
}

class Permissions {
  int? permissionId;
  String? permissionTitle;

  Permissions({this.permissionId, this.permissionTitle});

  Permissions.fromJson(Map<String, dynamic> json) {
    permissionId = json['permission_id'];
    permissionTitle = json['permission_title'];
  }
}
