class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;

  const BaseResponse({required this.success, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  /// For APIs that don’t wrap data
  factory BaseResponse.raw({
    required T data,
    String message = '',
    int statusCode = 400,
  }) {
    return BaseResponse<T>(success: true, message: message, data: data);
  }
}

class BaseApiResponseModel<T> extends BaseResponse<T> {
  const BaseApiResponseModel({
    required super.success,
    required super.message,
    super.data,
  });

  bool get isSuccess => success;
}
