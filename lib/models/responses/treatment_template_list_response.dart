import 'base_response_model.dart';

class TreatmentTemplateListResponse extends BaseApiResponseModel<List<TreatmentTemplateItemModel>> {
  final int? limit;
  final int? page;
  final int? totalPages;

  const TreatmentTemplateListResponse({
    required super.success,
    required super.message,
    super.data,
    this.limit,
    this.page,
    this.totalPages,
  });

  factory TreatmentTemplateListResponse.fromJson(Map<String, dynamic> json) {
    return TreatmentTemplateListResponse(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => TreatmentTemplateItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      limit: json['limit'],
      page: json['page'],
      totalPages: json['total_pages'],
    );
  }
}

class TreatmentTemplateItemModel {
  final int? id;
  final String? icon;
  final String? image;
  final String? name;
  final String? shortDescription;
  final String? globalSku;
  final String? status;

  TreatmentTemplateItemModel({
    this.id,
    this.icon,
    this.image,
    this.name,
    this.shortDescription,
    this.globalSku,
    this.status,
  });

  factory TreatmentTemplateItemModel.fromJson(Map<String, dynamic> json) {
    return TreatmentTemplateItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      icon: json['icon'],
      image: json['image'],
      name: json['name'],
      shortDescription: json['short_description'],
      globalSku: json['global_sku'],
      status: json['status'],
    );
  }
}
