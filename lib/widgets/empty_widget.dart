import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';

import '../utils/theme.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.height,
    this.width,
    this.text = "Nothing Here",
    this.padding,
  });
  final double? height;
  final double? width;
  final String text;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        children: [
          Image.asset(PngAssets.empty, height: height ?? context.h(500), width: width),
          Center(child: Text(text, style: CustomFonts.black20w600)),
        ],
      ),
    );
  }
}
