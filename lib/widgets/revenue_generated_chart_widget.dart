import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/theme.dart';
import 'borderd_container_widget.dart';

class RevenueChartData {
  final String period;
  final double revenue;

  RevenueChartData(this.period, this.revenue);
}

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
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data based on selected filter
    final List<RevenueChartData> chartData = _selectedFilter == 'Weekly'
        ? [
            RevenueChartData('Mon', 1200),
            RevenueChartData('Tue', 2400),
            RevenueChartData('Wed', 1800),
            RevenueChartData('Thu', 3200),
            RevenueChartData('Fri', 4500),
            RevenueChartData('Sat', 5100),
            RevenueChartData('Sun', 3800),
          ]
        : [
            RevenueChartData('Week 1', 14200),
            RevenueChartData('Week 2', 18500),
            RevenueChartData('Week 3', 21000),
            RevenueChartData('Week 4', 26400),
          ];

    final double totalRevenue =
        chartData.fold(0, (sum, item) => sum + item.revenue);

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
                            color: CustomColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(context.r(12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: context.sp(14),
                                color: CustomColors.green,
                              ),
                              context.horizontalSpace(4),
                              Text(
                                "+18.4%",
                                style: context.fonts.green10w600,
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
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
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
            child: SfCartesianChart(
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
              series: <CartesianSeries<RevenueChartData, String>>[
                SplineAreaSeries<RevenueChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (RevenueChartData data, _) => data.period,
                  yValueMapper: (RevenueChartData data, _) => data.revenue,
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
