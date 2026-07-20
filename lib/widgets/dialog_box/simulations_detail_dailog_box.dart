import 'package:flutter/material.dart';
import '../../utils/assets.dart';

import '../../utils/theme.dart';

class SimulationDetailDaillogBox extends StatelessWidget {
  const SimulationDetailDaillogBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(520),
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sarah Jhonson", style: CustomFonts.black20w600),
                        Text(
                          "Derma Fillers Patient, Botox",
                          style: CustomFonts.black14w400,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: context.w(32),
                      width: context.w(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Icon(
                        Icons.close,
                        size: context.r(18),
                        color: CustomColors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(30)),
              Image.asset(
                DemoAssets.simulationLandscape,
                height: context.h(208),
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              SizedBox(height: context.h(20)),
              Container(
                padding: EdgeInsets.all(context.w(23)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(10)),
                  color: CustomColors.lightPurple.withValues(alpha: 0.15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Treatments Applied on Simulator",
                      style: CustomFonts.black16w600,
                    ),
                    SizedBox(height: context.h(15)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Treatment", style: CustomFonts.black14w600),
                            SizedBox(height: context.h(5)),
                            Text("Botox", style: CustomFonts.black14w400),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Area", style: CustomFonts.black14w600),
                            SizedBox(height: context.h(5)),
                            Text("Undereye", style: CustomFonts.black14w400),
                          ],
                        ),
                        Column(
                          children: [
                            Text("Syringes", style: CustomFonts.black14w600),
                            SizedBox(height: context.h(5)),
                            Text("1", style: CustomFonts.black14w400),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(20)),
              Text(
                "Before & After Patient AI Model",
                style: CustomFonts.black16w600,
              ),
              SizedBox(height: context.h(20)),
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(PngAssets.simulation, height: context.w(148)),
                      SizedBox(height: context.h(4)),
                      Text("Before", style: CustomFonts.black14w600)
                    ],
                  ),
                  SizedBox(width: context.w(15)),
                  Column(
                    children: [
                      Image.asset(PngAssets.simulation, height: context.w(148)),
                      SizedBox(height: context.h(4)),
                      Text("After", style: CustomFonts.black14w600)
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
