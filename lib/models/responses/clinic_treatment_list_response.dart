import 'base_response_model.dart';
import '../treatment_model.dart';

class ClinicTreatmentListResponse extends BaseApiResponseModel<List<TreatmentModel>> {
  final int? limit;
  final int? page;
  final int? totalPages;

  const ClinicTreatmentListResponse({
    required super.success,
    required super.message,
    super.data,
    this.limit,
    this.page,
    this.totalPages,
  });

  factory ClinicTreatmentListResponse.fromJson(Map<String, dynamic> json) {
    return ClinicTreatmentListResponse(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((e) => TreatmentModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      limit: json['limit'],
      page: json['page'],
      totalPages: json['total_pages'],
    );
  }
}
