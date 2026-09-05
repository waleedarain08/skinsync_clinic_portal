import 'package:flutter/material.dart';

import '../../utils/string_utils.dart';
import '../../utils/theme.dart';

class StandardDialog extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;

  const StandardDialog({
    super.key,
    required this.title,
    this.width,
    this.height,
    required this.content,
    this.actions,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: context.appEdgeInsets(horizontal: 20, vertical: 20),
      child: Container(
        width: width ?? 520.w,
        height: height,
        constraints: BoxConstraints(maxWidth: 700.w),
        padding: context.appEdgeInsets(all: 24),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: context.appBorderRadius(all: 16),
          border: Border.all(color: CustomColors.border),
          boxShadow: AppShadows.lg(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.capitalize,
                    style: context.fonts.black18w600,
                  ),
                ),
                if (showCloseButton)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: context.appBorderRadius(all: 8),
                    child: Container(
                      height: 32.w,
                      width: 32.w,
                      decoration: BoxDecoration(
                        color: CustomColors.whiteGrey,
                        borderRadius: context.appBorderRadius(all: 8),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: CustomColors.lightGrey,
                      ),
                    ),
                  ),
              ],
            ),
            context.verticalSpace(24),

            /// Content
            Expanded(child: content),

            /// Actions
            if (actions != null && actions!.isNotEmpty) ...[
              context.verticalSpace(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map(
                      (action) => Padding(
                        padding: EdgeInsets.only(
                          left: action == actions!.first ? 0 : 12.w,
                        ),
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
