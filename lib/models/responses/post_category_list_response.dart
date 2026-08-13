import 'dart:convert';

import 'base_response_model.dart';

class PostCategoryListResponse extends BaseResponse<List<PostCategoryModel>> {
 

  PostCategoryListResponse({
   required super.success,
   required super.message,
    super.data,
  });

  factory PostCategoryListResponse.fromRawJson(String str) =>
      PostCategoryListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostCategoryListResponse.fromJson(Map<String, dynamic> json) => PostCategoryListResponse(
    success: json['is_success'],
    message: json['message'],
    data: json['data'] == null
        ? null
        : List<PostCategoryModel>.from((json['data'] as List).map((x) => PostCategoryModel.fromJson(x as Map<String, dynamic>))),
  );

  Map<String, dynamic> toJson() => {
    'is_success': success,
    'message': message,
    'data': data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class PostCategoryModel {
  final int? id;
  final String name;

  PostCategoryModel({
    this.id,
    required this.name,
  });

  factory PostCategoryModel.fromJson(Map<String, dynamic> json) => PostCategoryModel(
    id: json['id'],
    name: json['name'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
