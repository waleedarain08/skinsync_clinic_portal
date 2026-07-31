import 'package:flutter/material.dart';

import '../utils/theme.dart';

class BorderdContainerWidget extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final Color borderColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double borderWidth;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const BorderdContainerWidget({
    super.key,
    required this.child,
    this.borderRadius,
    this.borderColor = CustomColors.border,
    this.backgroundColor = CustomColors.white,
    this.height,
    this.width,
    this.borderWidth = 1,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? context.r(10)),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular((borderRadius ?? context.r(10)) - borderWidth),
        clipBehavior: backgroundColor != Colors.transparent ? Clip.antiAlias : Clip.none,
        child: Padding(
          padding: padding ?? EdgeInsets.all(context.w(20)),
          child: child,
        ),
      ),
    );
  }
}
