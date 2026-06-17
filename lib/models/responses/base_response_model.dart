class BaseResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;

  const BaseResponse({required this.isSuccess, required this.message, this.data});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return BaseResponse<T>(
      isSuccess: json['is_success'] ?? false,
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
    return BaseResponse<T>(isSuccess: true, message: message, data: data);
  }
}
