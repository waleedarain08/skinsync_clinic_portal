import 'package:skinsync_clinic_portal/models/responses/base_response_model.dart';
import 'package:skinsync_clinic_portal/models/responses/get_roles_response.dart';

class GetFeatureResponse extends BaseApiResponseModel<List<Feature>> {
  GetFeatureResponse({
    super.data,
    required super.isSuccess,
    required super.message,
  });

  factory GetFeatureResponse.fromJson(Map<String, dynamic> json) =>
      GetFeatureResponse(
        isSuccess: json["is_success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Feature>.from(json["data"]!.map((x) => Feature.fromJson(x))),
      );
}

class Feature {
  int? featureId;
  String? featureName;
  List<Permissions>? permissions;

  Feature({this.featureId, this.featureName, this.permissions});

  Feature.fromJson(Map<String, dynamic> json) {
    featureId = json['feature_id'];
    featureName = json['feature_name'];
    if (json['permissions'] != null) {
      permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permissions.fromJson(v));
      });
    }
  }
}

