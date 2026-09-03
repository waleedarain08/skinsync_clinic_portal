import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/theme.dart';
import 'borderd_container_widget.dart';

class AppointmentStatusPieChart extends StatefulWidget {
  const AppointmentStatusPieChart({super.key});

  @override
  State<AppointmentStatusPieChart> createState() =>
      _AppointmentStatusPieChartState();
}

class _AppointmentStatusPieChartState
    extends State<AppointmentStatusPieChart> {
  late List<_AppointmentChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'Appointment Status',
      format: 'point.x: point.y appointments (point.percentage%)',
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );

    _chartData = [
      _AppointmentChartData(
        status: 'Completed',
        count: 18,
        color: CustomColors.green,
        badgeBg: CustomColors.green.withValues(alpha: 0.1),
        icon: Icons.check_circle_rounded,
      ),
      _AppointmentChartData(
        status: 'In Progress',
        count: 8,
        color: CustomColors.purple,
        badgeBg: CustomColors.lightPurple,
        icon: Icons.play_circle_fill_rounded,
      ),
      _AppointmentChartData(
        status: 'Pending',
        count: 6,
        color: CustomColors.amber,
        badgeBg: CustomColors.amber.withValues(alpha: 0.1),
        icon: Icons.hourglass_top_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final int totalAppointments =
        _chartData.fold(0, (sum, item) => sum + item.count);

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
                          "Appointment Status Overview",
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
                                "+12% this week",
                                style: context.fonts.green10w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    context.verticalSpace(4),
                    Text(
                      "Live analytics powered by Syncfusion Charts",
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
              Container(
                padding: context.appEdgeInsets(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: CustomColors.lightPurple,
                  borderRadius: BorderRadius.circular(context.r(20)),
                  border: Border.all(
                    color: CustomColors.purple.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.insights_rounded,
                      size: context.sp(16),
                      color: CustomColors.purple,
                    ),
                    context.horizontalSpace(6),
                    Text(
                      "Total: $totalAppointments",
                      style: context.fonts.purple12w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(24),

          // Responsive Chart & Metrics Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            height: context.h(260),
                            child: _buildSyncfusionDoughnutChart(
                              context,
                              totalAppointments,
                            ),
                          ),
                        ),
                        context.horizontalSpace(24),
                        Expanded(
                          flex: 6,
                          child: _buildDetailedMetricsList(
                            context,
                            totalAppointments,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: context.h(240),
                          child: _buildSyncfusionDoughnutChart(
                            context,
                            totalAppointments,
                          ),
                        ),
                        context.verticalSpace(24),
                        _buildDetailedMetricsList(context, totalAppointments),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncfusionDoughnutChart(
    BuildContext context,
    int totalAppointments,
  ) {
    return SfCircularChart(
      tooltipBehavior: _tooltipBehavior,
      margin: EdgeInsets.zero,
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$totalAppointments",
                style: context.fonts.black24w700,
              ),
              context.verticalSpace(2),
              Text(
                "Appointments",
                style: context.fonts.grey11w400,
              ),
            ],
          ),
        ),
      ],
      series: <CircularSeries<_AppointmentChartData, String>>[
        DoughnutSeries<_AppointmentChartData, String>(
          dataSource: _chartData,
          xValueMapper: (_AppointmentChartData data, _) => data.status,
          yValueMapper: (_AppointmentChartData data, _) => data.count,
          pointColorMapper: (_AppointmentChartData data, _) => data.color,
          innerRadius: '68%',
          radius: '88%',
          explode: true,
          explodeIndex: 0,
          explodeOffset: '8%',
          animationDuration: 1200,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            connectorLineSettings: const ConnectorLineSettings(
              type: ConnectorType.curve,
              width: 1.5,
              color: CustomColors.grey,
            ),
            textStyle: TextStyle(
              fontSize: context.sp(11),
              fontWeight: FontWeight.w600,
              color: CustomColors.black,
            ),
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              final _AppointmentChartData item = data as _AppointmentChartData;
              final double percentage = (item.count / totalAppointments) * 100;
              return Container(
                padding: context.appEdgeInsets(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: item.badgeBg,
                  borderRadius: BorderRadius.circular(context.r(8)),
                  border: Border.all(
                    color: item.color.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontSize: context.sp(10),
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedMetricsList(
    BuildContext context,
    int totalAppointments,
  ) {
    return Column(
      children: List.generate(_chartData.length, (index) {
        final item = _chartData[index];
        final percentage =
            ((item.count / totalAppointments) * 100).toStringAsFixed(1);
        final isSelected = _selectedCategoryIndex == index;

        return MouseRegion(
          onEnter: (_) => setState(() => _selectedCategoryIndex = index),
          onExit: (_) => setState(() => _selectedCategoryIndex = -1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: context.h(12)),
            padding: context.appEdgeInsets(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? item.badgeBg
                  : CustomColors.softGrey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(context.r(12)),
              border: Border.all(
                color: isSelected ? item.color : CustomColors.border,
                width: isSelected ? 1.5 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: item.color.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  padding: context.appEdgeInsets(all: 8),
                  decoration: BoxDecoration(
                    color: item.badgeBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.icon,
                    size: context.sp(18),
                    color: item.color,
                  ),
                ),
                context.horizontalSpace(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.status,
                        style: context.fonts.black14w600,
                      ),
                      context.verticalSpace(2),
                      Text(
                        "${item.count} out of $totalAppointments appointments",
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(context.r(16)),
                  ),
                  child: Text(
                    "$percentage%",
                    style: context.fonts.white10w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _AppointmentChartData {
  final String status;
  final int count;
  final Color color;
  final Color badgeBg;
  final IconData icon;

  _AppointmentChartData({
    required this.status,
    required this.count,
    required this.color,
    required this.badgeBg,
    required this.icon,
  });
}
