import 'package:flutter/material.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class SimulationDetailDaillogBox extends StatelessWidget {
  const SimulationDetailDaillogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Simulation Details",
      width: 650.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Patient Info Header in Content
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundImage: const AssetImage(PngAssets.person),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sarah Jhonson", style: context.fonts.black18w600),
                      Text(
                        "Derma Fillers Patient, Botox",
                        style: context.fonts.grey13w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            context.verticalSpace(24),

            /// Main Simulation Image
            ClipRRect(
              borderRadius: context.appBorderRadius(all: 12),
              child: Image.asset(
                DemoAssets.simulationLandscape,
                height: 240.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            context.verticalSpace(24),

            /// Detail Block: Treatments Applied
            Container(
              padding: context.appEdgeInsets(all: 20),
              decoration: BoxDecoration(
                borderRadius: context.appBorderRadius(all: 12),
                color: CustomColors.whiteGrey,
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Treatments Applied on Simulator",
                    style: context.fonts.purple16w600,
                  ),
                  context.verticalSpace(16),
                  _buildDetailRow(context, "Treatment", "Botox"),
                  context.verticalSpace(12),
                  _buildDetailRow(context, "Area", "Undereye"),
                  context.verticalSpace(12),
                  _buildDetailRow(context, "Syringes", "1"),
                ],
              ),
            ),
            context.verticalSpace(24),

            /// Before & After AI Model
            Text(
              "Before & After Patient AI Model",
              style: context.fonts.black16w600,
            ),
            context.verticalSpace(16),
            Row(
              children: [
                Expanded(
                  child: _buildComparisonItem(
                    context,
                    "Before",
                    PngAssets.simulation,
                  ),
                ),
                context.horizontalSpace(16),
                Expanded(
                  child: _buildComparisonItem(
                    context,
                    "After",
                    PngAssets.simulation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(key, style: context.fonts.grey13w500),
        Text(value, style: context.fonts.black14w600),
      ],
    );
  }

  Widget _buildComparisonItem(
    BuildContext context,
    String label,
    String imagePath,
  ) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: context.appBorderRadius(all: 12),
          child: Image.asset(imagePath, height: 160.h, fit: BoxFit.cover),
        ),
        context.verticalSpace(8),
        Text(label, style: context.fonts.black14w600),
      ],
    );
  }
}
