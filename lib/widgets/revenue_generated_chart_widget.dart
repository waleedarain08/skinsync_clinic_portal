import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/responses/revenue_response.dart';
import '../utils/theme.dart';
import '../view_models/auth_view_model.dart';
import 'borderd_container_widget.dart';

class RevenueGeneratedChartWidget extends ConsumerStatefulWidget {
  const RevenueGeneratedChartWidget({super.key});

  @override
  ConsumerState<RevenueGeneratedChartWidget> createState() =>
      _RevenueGeneratedChartWidgetState();
}

class _RevenueGeneratedChartWidgetState
    extends ConsumerState<RevenueGeneratedChartWidget> {
  late TooltipBehavior _tooltipBehavior;
  String _selectedFilter = 'Weekly';

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'Revenue Details',
      format: 'point.x : \$point.y',
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
    // Fire the initial fetch with the API's lowercase filter value.
    ref
        .read(authViewModelProvider.notifier)
        .callGetRevenue(filter: _selectedFilter.toLowerCase());
  }

  void _onFilterChanged(String filter) {
    if (filter == _selectedFilter) return;
    setState(() => _selectedFilter = filter);
    ref
        .read(authViewModelProvider.notifier)
        .callGetRevenue(filter: filter.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final RevenueDto? revenueDto = ref.watch(
      authViewModelProvider.select((s) => s.revenueDto),
    );

    // Only trust API data once it matches the currently selected filter -
    // avoids a stale/mismatched chart flashing while the new filter loads.
    final bool hasData =
        revenueDto != null &&
        revenueDto.filter.toLowerCase() == _selectedFilter.toLowerCase();

    final List<RevenueItemDto> chartData = hasData ? revenueDto.revenue : [];
    final double totalRevenue = hasData ? revenueDto.totalRevenue : 0;
    final double growthPercentage = hasData ? revenueDto.growthPercentage : 0;
    final bool isPositiveGrowth = growthPercentage >= 0;

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      borderRadius: context.r(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Revenue Generated",
                          style: context.fonts.black18w600,
                        ),
                        context.horizontalSpace(8),
                        Container(
                          padding: context.appEdgeInsets(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: (isPositiveGrowth
                                    ? CustomColors.green
                                    : CustomColors.red)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(context.r(12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPositiveGrowth
                                    ? Icons.trending_up_rounded
                                    : Icons.trending_down_rounded,
                                size: context.sp(14),
                                color: isPositiveGrowth
                                    ? CustomColors.green
                                    : CustomColors.red,
                              ),
                              context.horizontalSpace(4),
                              Text(
                                "${isPositiveGrowth ? '+' : ''}${growthPercentage.toStringAsFixed(1)}%",
                                style: isPositiveGrowth
                                    ? context.fonts.green10w600
                                    : context.fonts.red10w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(4),
                    Text(
                      "Total Revenue: \$${NumberFormat('#,##0').format(totalRevenue)}",
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
              // Filter Toggle
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.lightPurple,
                  borderRadius: BorderRadius.circular(context.r(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: ['Weekly', 'Monthly'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return GestureDetector(
                      onTap: () => _onFilterChanged(filter),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(12),
                          vertical: context.h(6),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CustomColors.purple
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(context.r(10)),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : CustomColors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(12),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          context.verticalSpace(16),
          // Chart
          SizedBox(
            height: context.h(220),
            child: !hasData
                ? const Center(child: CircularProgressIndicator())
                : SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                      axisLine: const AxisLine(width: 1, color: Colors.grey),
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: context.sp(11),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      majorGridLines: MajorGridLines(
                        width: 1,
                        color: Colors.grey.shade200,
                        dashArray: const <double>[5, 5],
                      ),
                      axisLine: const AxisLine(width: 0),
                      labelStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: context.sp(11),
                      ),
                      numberFormat: NumberFormat.compactCurrency(
                        symbol: '\$',
                        decimalDigits: 0,
                      ),
                    ),
                    series: <CartesianSeries<RevenueItemDto, String>>[
                      SplineAreaSeries<RevenueItemDto, String>(
                        dataSource: chartData,
                        xValueMapper: (RevenueItemDto data, _) => data.period,
                        yValueMapper: (RevenueItemDto data, _) =>
                            data.revenue,
                        name: 'Revenue',
                        color: CustomColors.purple.withValues(alpha: 0.2),
                        borderColor: CustomColors.purple,
                        borderWidth: 2.5,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          height: 6,
                          width: 6,
                          color: CustomColors.purple,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}