import 'package:flutter/material.dart';
import 'package:before_after/before_after.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'borderd_container_widget.dart';

class SimulationRecord {
  final String date;
  final String simulationName;
  final String area;
  final String status;
  final String notes;
  final String frontBefore;
  final String frontAfter;
  final String leftBefore;
  final String leftAfter;
  final String rightBefore;
  final String rightAfter;

  SimulationRecord({
    required this.date,
    required this.simulationName,
    required this.area,
    required this.status,
    required this.notes,
    required this.frontBefore,
    required this.frontAfter,
    required this.leftBefore,
    required this.leftAfter,
    required this.rightBefore,
    required this.rightAfter,
  });
}

class PatientSimulationsWidget extends StatefulWidget {
  const PatientSimulationsWidget({super.key});

  @override
  State<PatientSimulationsWidget> createState() =>
      _PatientSimulationsWidgetState();
}

class _PatientSimulationsWidgetState extends State<PatientSimulationsWidget> {
  final Map<String, double> _sliderValues = {};

  @override
  Widget build(BuildContext context) {
    final List<SimulationRecord> simulations = [
      SimulationRecord(
        date: 'October 12, 2025',
        simulationName: 'Forehead Rejuvenation & Glaze',
        area: 'Upper Face / Forehead',
        status: 'Completed',
        notes:
            'Simulated 20% wrinkle reduction with smooth skin texture mapping across Front, Left, and Right profiles.',
        frontBefore: PngAssets.face,
        frontAfter: PngAssets.faceMarks,
        leftBefore: PngAssets.simulation,
        leftAfter: PngAssets.laserTreatment,
        rightBefore: PngAssets.treatmentImage,
        rightAfter: PngAssets.treatmentImage2,
      ),
      SimulationRecord(
        date: 'September 04, 2025',
        simulationName: 'Mid-Face Volumization & Contour',
        area: 'Cheeks & Jawline',
        status: 'Archived',
        notes:
            'Simulated cheekbone elevation and nasolabial fold softening across all camera angles.',
        frontBefore: PngAssets.simulation,
        frontAfter: PngAssets.laserTreatment,
        leftBefore: PngAssets.face,
        leftAfter: PngAssets.faceMarks,
        rightBefore: PngAssets.treatmentImage2,
        rightAfter: PngAssets.treatmentImage,
      ),
    ];

    return BorderdContainerWidget(
      padding: context.appEdgeInsets(all: 24),
      backgroundColor: CustomColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.compare_rounded,
                color: CustomColors.purple,
                size: 22,
              ),
              context.horizontalSpace(10),
              Text('Date-wise Simulations', style: context.fonts.subHeading),
            ],
          ),
          const Divider(color: CustomColors.border, height: 32),
          ...simulations.asMap().entries.map((entry) {
            final simIndex = entry.key;
            final sim = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: context.h(28)),
              padding: context.appEdgeInsets(all: 20),
              decoration: BoxDecoration(
                border: Border.all(color: CustomColors.border),
                borderRadius: BorderRadius.circular(context.r(16)),
                color: CustomColors.whiteGrey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 18,
                            color: CustomColors.purple,
                          ),
                          context.horizontalSpace(8),
                          Text(sim.date, style: context.fonts.black14w600),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(context.r(12)),
                        ),
                        child: Text(
                          sim.status,
                          style: context.fonts.green10w600,
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(12),
                  Text(sim.simulationName, style: context.fonts.black16w600),
                  context.verticalSpace(4),
                  Text(
                    'Target Area: ${sim.area}',
                    style: context.fonts.grey12w400,
                  ),
                  context.verticalSpace(12),
                  Text(sim.notes, style: context.fonts.black14w400),
                  context.verticalSpace(20),

                  // Front, Left, Right Comparisons Horizontal Scroll View
                  Text(
                    'Front, Left & Right Comparisons',
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.purple,
                    ),
                  ),
                  context.verticalSpace(12),
                  SizedBox(
                    height: context.h(300),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildComparisonCard(
                          context,
                          'Front View',
                          sim.frontBefore,
                          sim.frontAfter,
                          '$simIndex-front',
                        ),
                        context.horizontalSpace(16),
                        _buildComparisonCard(
                          context,
                          'Left Profile',
                          sim.leftBefore,
                          sim.leftAfter,
                          '$simIndex-left',
                        ),
                        context.horizontalSpace(16),
                        _buildComparisonCard(
                          context,
                          'Right Profile',
                          sim.rightBefore,
                          sim.rightAfter,
                          '$simIndex-right',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(
    BuildContext context,
    String label,
    String beforeImg,
    String afterImg,
    String keyName,
  ) {
    _sliderValues.putIfAbsent(keyName, () => 0.5);

    return Container(
      width: context.w(260),
      padding: context.appEdgeInsets(all: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.fonts.black14w600),
          context.verticalSpace(8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.r(12)),
              child: Stack(
                children: [
                  BeforeAfter(
                    value: _sliderValues[keyName]!,
                    onValueChanged: (val) =>
                        setState(() => _sliderValues[keyName] = val),
                    before: Image.asset(beforeImg, fit: BoxFit.cover),
                    after: Image.asset(afterImg, fit: BoxFit.cover),
                    trackColor: Colors.white,
                    trackWidth: 2,
                    thumbWidth: 28,
                    thumbHeight: 28,
                    thumbDecoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(PngAssets.customMarker),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'BEFORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.purple.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AFTER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
