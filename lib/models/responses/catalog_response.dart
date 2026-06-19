import 'base_response_model.dart';

class CatalogResponse extends BaseResponse<List<CatalogItem>> {
  CatalogResponse({super.data, required super.success, required super.message});

  factory CatalogResponse.fromJson(Map<String, dynamic> json) =>
      CatalogResponse(
        data: json["data"] == null
            ? []
            : List<CatalogItem>.from(
                json["data"]!.map((x) => CatalogItem.fromJson(x)),
              ),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );
}

class CatalogItem {
  final int? id;
  final String? image;
  final String? name;
  final String? description;
  final String? unit;

  CatalogItem({this.id, this.image, this.name, this.description, this.unit});

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    description: json["description"],
    unit: json["unit"],
  );
}
