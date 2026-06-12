import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';

import '../utils/theme.dart';

class NumberPaginator extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const NumberPaginator({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildArrowButton(
          context: context,
          icon: CupertinoIcons.chevron_back,
          onPressed: currentPage > 0
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
        SizedBox(width: context.w(4)),
        if (context.isLandscape) ..._buildPageNumbers(context),
        SizedBox(width: context.w(4)),
        _buildArrowButton(
          context: context,
          icon: CupertinoIcons.chevron_forward,
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildArrowButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(context.r(4)),
      child: Container(
        width: context.w(32),
        height: context.w(32),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: context.r(16),
          color: onPressed == null
              ? CustomColors.lightGrey
              : CustomColors.black,
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    List<Widget> items = [];
    const int visibleThreshold = 3;

    if (totalPages <= 7) {
      for (int i = 0; i < totalPages; i++) {
        items.add(_buildPageItem(context, i));
      }
    } else {
      // First page
      items.add(_buildPageItem(context, 0));

      if (currentPage > visibleThreshold) {
        items.add(_buildEllipsis(context));
      }

      // Pages around current
      int start = (currentPage - 1).clamp(1, totalPages - 2);
      int end = (currentPage + 1).clamp(1, totalPages - 2);

      if (currentPage <= visibleThreshold) {
        start = 1;
        end = 3;
      } else if (currentPage >= totalPages - visibleThreshold - 1) {
        start = totalPages - 4;
        end = totalPages - 2;
      }

      for (int i = start; i <= end; i++) {
        items.add(_buildPageItem(context, i));
      }

      if (currentPage < totalPages - visibleThreshold - 1) {
        items.add(_buildEllipsis(context));
      }

      // Last page
      items.add(_buildPageItem(context, totalPages - 1));
    }

    return items;
  }

  Widget _buildPageItem(BuildContext context, int index) {
    bool isSelected = index == currentPage;
    return GestureDetector(
      onTap: () => onPageChanged(index),
      child: Container(
        width: context.w(32),
        height: context.w(32),
        margin: EdgeInsets.symmetric(horizontal: context.w(2)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.softGrey : Colors.transparent,
          borderRadius: BorderRadius.circular(context.r(4)),
          border: isSelected ? Border.all(color: CustomColors.border) : null,
        ),
        child: Text(
          '${index + 1}',
          style: isSelected ? CustomFonts.black14w600 : CustomFonts.grey14w400,
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(4)),
      child: Text('...', style: CustomFonts.grey12w400),
    );
  }
}
