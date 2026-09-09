import 'base_response_model.dart';

class SessionMaterialsResponse
    extends BaseApiResponseModel<List<SessionMaterialData>> {
  const SessionMaterialsResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory SessionMaterialsResponse.fromJson(Map<String, dynamic> json) =>
      SessionMaterialsResponse(
        success: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                  .map((e) =>
                      SessionMaterialData.fromJson(e as Map<String, dynamic>))
                  .toList(),
      );
}

class SessionMaterialData {
  final int sessionId;
  final String sessionName;
  final List<MaterialItem> material;

  SessionMaterialData({
    required this.sessionId,
    required this.sessionName,
    required this.material,
  });

  factory SessionMaterialData.fromJson(Map<String, dynamic> json) {
    return SessionMaterialData(
      sessionId: json['session_id'] as int? ?? 0,
      sessionName: json['session_name'] ?? '',
      material: json['material'] == null
          ? []
          : (json['material'] as List)
              .map((e) => MaterialItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class MaterialItem {
  final int id;
  final String unitType;
  final int minQty;
  final int maxQty;

  MaterialItem({
    required this.id,
    required this.unitType,
    required this.minQty,
    required this.maxQty,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      id: json['id'] as int? ?? 0,
      unitType: json['unitType'] ?? '',
      minQty: json['minQty'] as int? ?? 0,
      maxQty: json['maxQty'] as int? ?? 0,
    );
  }
}
