import 'base_response_model.dart';

class BookingMethodsResponse
    extends BaseApiResponseModel<List<BookingMethodItem>> {
  const BookingMethodsResponse({
    required super.success,
    required super.message,
    super.data,
  });

  factory BookingMethodsResponse.fromJson(Map<String, dynamic> json) =>
      BookingMethodsResponse(
        success: (json['is_success'] as bool?) ?? false,
        message: json['message'] ?? '',
        data: json['data'] == null
            ? null
            : (json['data'] as List)
                .map((e) =>
                    BookingMethodItem.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
}

class BookingMethodItem {
  final int id;
  final String title;
  final String key;
  final String description;
  final String icon;
  final String status;

  BookingMethodItem({
    required this.id,
    required this.title,
    required this.key,
    required this.description,
    required this.icon,
    required this.status,
  });

  factory BookingMethodItem.fromJson(Map<String, dynamic> json) =>
      BookingMethodItem(
        id: json['id'] as int? ?? 0,
        title: json['title'] ?? '',
        key: json['key'] ?? '',
        description: json['description'] ?? '',
        icon: json['icon'] ?? '',
        status: json['status'] ?? '',
      );
}
