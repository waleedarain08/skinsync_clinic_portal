import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/theme.dart';

class BuildHeader extends StatelessWidget {
  final String title;
  const BuildHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, size: context.r(24), color: CustomColors.black),
        ),
        SizedBox(width: context.w(12)),
        Text(title, style: CustomFonts.black20w600),
      ],
    );
  }
}
