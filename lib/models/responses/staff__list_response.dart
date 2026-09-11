import 'base_response_model.dart';

class StaffListResponse extends BaseApiResponseModel<List<StaffModel>> {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  StaffListResponse({
    super.data,
    required super.success,
    required this.limit,
    required super.message,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory StaffListResponse.fromJson(Map<String, dynamic> json) {
    return StaffListResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => StaffModel.fromJson(item))
              .toList() ??
          [],
      success: json['is_success'] ?? false,
      limit: json['limit'] ?? 0,
      message: json['message'] ?? '',
      page: json['page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}

class StaffModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String cc;
  final String country;
  final String role;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
    required this.role,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cc: json['cc'] ?? '',
      country: json['country'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'cc': cc,
      'country': country,
      'role': role,
    };
  }
}
