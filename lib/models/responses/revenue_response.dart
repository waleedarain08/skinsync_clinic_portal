import 'base_response_model.dart';

class RevenueResponse extends BaseApiResponseModel<RevenueDto> {
  RevenueResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory RevenueResponse.fromJson(Map<String, dynamic> json) {
    return RevenueResponse(
      data: json['data'] != null
          ? RevenueDto.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
      success: json['is_success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}

class RevenueDto {
  final String filter;
  final double totalRevenue;
  final double growthPercentage;
  final List<RevenueItemDto> revenue;

  RevenueDto({
    required this.filter,
    required this.totalRevenue,
    required this.growthPercentage,
    required this.revenue,
  });

  factory RevenueDto.fromJson(Map<String, dynamic> json) {
    return RevenueDto(
      filter: json['filter'] as String? ?? '',
      totalRevenue:
          (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      growthPercentage:
          (json['growth_percentage'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['revenue'] as List?)
              ?.map(
                (e) => RevenueItemDto.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'total_revenue': totalRevenue,
      'growth_percentage': growthPercentage,
      'revenue': revenue.map((e) => e.toJson()).toList(),
    };
  }
}

class RevenueItemDto {
  final String period;
  final double revenue;

  RevenueItemDto({
    required this.period,
    required this.revenue,
  });

  factory RevenueItemDto.fromJson(Map<String, dynamic> json) {
    return RevenueItemDto(
      period: json['period'] as String? ?? '',
      revenue:
          (json['revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'revenue': revenue,
    };
  }
}