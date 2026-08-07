import 'base_response_model.dart';

class AdministrationStaffListResponse extends BaseResponse<AdministrationStaffListData> {
  const AdministrationStaffListResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory AdministrationStaffListResponse.fromJson(Map<String, dynamic> json) =>
      AdministrationStaffListResponse(
        data: json["data"] == null ? null : AdministrationStaffListData.fromJson(json["data"]),
        success: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );
}

class AdministrationStaffListData {
  final List<AdministrationStaffListItem> items;
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  AdministrationStaffListData({
    required this.items,
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory AdministrationStaffListData.fromJson(Map<String, dynamic> json) => AdministrationStaffListData(
        items: json["items"] == null
            ? []
            : List<AdministrationStaffListItem>.from(json["items"].map((x) => AdministrationStaffListItem.fromJson(x))),
        limit: json["limit"] ?? 0,
        page: json["page"] ?? 0,
        total: json["total"] ?? 0,
        totalPages: json["total_pages"] ?? 0,
      );
}

class AdministrationStaffListItem {
  final int id;
  final String status;
  final String name;
  final String role;
  final String image;
  final String email;
  final String phone;
  final String? address;
  final String? joinDate;
  final String? department;

  AdministrationStaffListItem({
    required this.id,
    required this.status,
    required this.name,
    required this.role,
    required this.image,
    required this.email,
    required this.phone,
    this.address,
    this.joinDate,
    this.department,
  });

  factory AdministrationStaffListItem.fromJson(Map<String, dynamic> json) => AdministrationStaffListItem(
        id: json["id"] ?? 0,
        status: json["status"] ?? "",
        name: json["name"] ?? "",
        role: json["role"] ?? "",
        image: json["image"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        address: json["address"],
        joinDate: json["join_date"],
        department: json["department"],
      );
}
