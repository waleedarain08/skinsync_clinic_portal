import 'base_response_model.dart';

typedef PractitionerListData = PractitionerListResponse;

class PractitionerListResponse extends BaseResponse<List<PractitionerListItem>> {
  final int page;
  final int limit;
  final int totalPages;
  final int total;
  final int activeProviders;
  final int totalProviders;

  PractitionerListResponse({
    required super.success,
    required super.message,
    super.data,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.total,
    required this.activeProviders,
    required this.totalProviders,
  });

  factory PractitionerListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] ?? json['items'];
    final List<dynamic>? itemsList = rawList is List<dynamic>
        ? rawList
        : (json['data'] is Map<String, dynamic> &&
                (json['data'] as Map<String, dynamic>)['items'] is List<dynamic>
            ? (json['data'] as Map<String, dynamic>)['items'] as List<dynamic>
            : null);

    final dataMap = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return PractitionerListResponse(
      success: json['is_success'] ?? json['success'] ?? true,
      message: json['message'] ?? '',
      data: itemsList
              ?.map(
                (e) => PractitionerListItem.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      page: json['page'] ?? dataMap['page'] ?? 1,
      limit: json['limit'] ?? dataMap['limit'] ?? 10,
      totalPages: json['total_pages'] ?? dataMap['total_pages'] ?? 0,
      total: json['total'] ?? dataMap['total'] ?? 0,
      activeProviders:
          json['active_providers'] ?? dataMap['active_providers'] ?? 0,
      totalProviders:
          json['total_providers'] ?? dataMap['total_providers'] ?? 0,
    );
  }
}

class PractitionerListItem {
  final int id;
  final String status;
  final String name;
  final String title;
  final String image;
  final String specialization;
  final String email;
  final String phone;
  final String cc;
  final String? role;
  final String country;
  final String licenseExpiryDate;
  final int treatmentCount;
  final int appointmentCount;

  PractitionerListItem({
    required this.id,
    this.status = '',
    required this.name,
    this.title = '',
    this.image = '',
    this.specialization = '',
    this.role,
    this.email = '',
    this.phone = '',
    this.cc = '',
    this.country = '',
    this.licenseExpiryDate = '',
    this.treatmentCount = 0,
    this.appointmentCount = 0,
  });

  factory PractitionerListItem.fromJson(Map<String, dynamic> json) =>
      PractitionerListItem(
        id: json["id"] ?? 0,
        status: json["status"] ?? "",
        name: json["name"] ?? "",
        title: json["title"] ?? "",
        image: json["image"] ?? "",
        specialization: json["specialization"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        role: json['role'],
        cc: json["cc"] ?? "",
        country: json["country"] ?? "",
        licenseExpiryDate: json["license_expiry_date"] ?? "",
        treatmentCount:
            json["treatment_counts"] ?? json["treatment_count"] ?? 0,
        appointmentCount:
            json["appointment_count"] ?? json["appointment_counts"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "name": name,
        "title": title,
        "image": image,
        "specialization": specialization,
        "email": email,
        "phone": phone,
        "role": role,
        "cc": cc,
        "country": country,
        "license_expiry_date": licenseExpiryDate,
        "treatment_counts": treatmentCount,
        "appointment_count": appointmentCount,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PractitionerListItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
