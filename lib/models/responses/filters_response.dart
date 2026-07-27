import 'dart:convert';


import 'base_response_model.dart';

class FiltersResponse extends BaseApiResponseModel<List<Filters>> {
  FiltersResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory FiltersResponse.fromJson(Map<String, dynamic> json) =>
      FiltersResponse(
        data: json["data"] == null
            ? []
            : List<Filters>.from(
                json["data"]!.map((x) => Filters.fromJson(x)),
              ),
        success: json["is_success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "is_success": isSuccess,
    "message": message,
  };
}

class Filters {
  final int? id;
  final String? name;

  Filters({this.id, this.name});

  factory Filters.fromRawJson(String str) =>
      Filters.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Filters.fromJson(Map<String, dynamic> json) =>
      Filters(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
