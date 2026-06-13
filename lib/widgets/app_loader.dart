import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? value;
  const AppLoader({super.key, this.size, this.color, this.value});

  @override
  Widget build(BuildContext context) {
    final boxSize = size ?? context.w(100);
    final imageSize = size ?? context.w(50);
    return Padding(
      padding: EdgeInsets.all(context.w(10)),
      child: SizedBox(
        width: boxSize,
        height: boxSize,
        child: Stack(
          children: [
            Center(
              child: Transform.scale(
                scale: 1.6,
                child: CircularProgressIndicator(strokeWidth: 2, value: value),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Image.asset(
                  PngAssets.splashLogo,
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
