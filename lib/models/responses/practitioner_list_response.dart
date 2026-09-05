import 'base_response_model.dart';

class PractitionerListResponse extends BaseResponse<PractitionerListData> {
  const PractitionerListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory PractitionerListResponse.fromJson(Map<String, dynamic> json) =>
      PractitionerListResponse(
        data: json["data"] == null
            ? null
            : PractitionerListData.fromJson(json["data"]),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );
}

class PractitionerListData {
  final List<PractitionerListItem> items;
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  PractitionerListData({
    required this.items,
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory PractitionerListData.fromJson(Map<String, dynamic> json) =>
      PractitionerListData(
        items: json["items"] == null
            ? []
            : List<PractitionerListItem>.from(
                json["items"].map((x) => PractitionerListItem.fromJson(x)),
              ),
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        total: json["total"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
      );
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
    required this.status,
    required this.name,
    required this.title,
    required this.image,
    required this.specialization,
    this.role,
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
    required this.licenseExpiryDate,
    required this.treatmentCount,
    required this.appointmentCount,
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
        treatmentCount: json["treatment_count"] ?? 0,
        appointmentCount: json["appointment_count"] ?? 0,
      );
}
