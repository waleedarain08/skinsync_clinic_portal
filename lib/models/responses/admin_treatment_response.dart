import 'base_response_model.dart';

class AdminProductListResponse
    extends BaseApiResponseModel<List<AdminTreatment>> {
  final int page;
  final int limit;
  final int totalPages;

  const AdminProductListResponse({
    required super.success,
    required super.message,
    required this.page,
    required this.limit,
    required this.totalPages,
    super.data,
  });

  factory AdminProductListResponse.fromJson(Map<String, dynamic> json) {
    return AdminProductListResponse(
      success: (json['is_success'] as bool?) ?? false,
      message: json['message'] ?? '',
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages:
          json['total_pages'] as int? ?? json['totalPages'] as int? ?? 1,
      data: json['data'] == null
          ? null
          : (json['data'] as List)
                .map((e) => AdminTreatment.fromJson(e as Map<String, dynamic>))
                .toList(),
    );
  }
}


class AdminTreatment {
  final int id;
  final String name;
  final String shortDescription;
  final String icon;
  final String image;

  AdminTreatment({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.icon,
    required this.image,
  });

  factory AdminTreatment.fromJson(Map<String, dynamic> json) {
    return AdminTreatment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      icon: json['icon'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'icon': icon,
      'image': image,
    };
  }
}

