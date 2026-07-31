import 'base_response_model.dart';

class AreaListResponse extends BaseApiResponseModel<List<AreaModel>> {
  const AreaListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AreaListResponse.fromJson(Map<String, dynamic> json) =>
      AreaListResponse(
        success: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                  .map((e) => AreaModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
      );
}

class AreaModel {
  final int id;
  final String name;
  final String globalSku;
  final String icon;
  final String image;
  final String? status;

  AreaModel({
    required this.id,
    required this.name,
    required this.globalSku,
    required this.icon,
    required this.image,
    this.status,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      globalSku: json['global_sku'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'global_sku': globalSku,
      'icon': icon,
      'image': image,
      'status': status,
    };
  }

  AreaModel copyWith({
    int? id,
    String? name,
    String? globalSku,
    String? icon,
    String? image,
    String? status,
  }) {
    return AreaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      globalSku: globalSku ?? this.globalSku,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }
}
