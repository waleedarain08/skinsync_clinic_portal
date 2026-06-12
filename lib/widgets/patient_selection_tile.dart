import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class PatientSelectionTile extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? imageUrl;
  final bool isSelected;

  const PatientSelectionTile({
    super.key,
    required this.title,
    this.subTitle,
    this.imageUrl,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.w(15)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(
          color: isSelected ? CustomColors.purple : CustomColors.border,
          width: isSelected ? context.r(2) : context.r(1),
        ),
      ),
      child: Row(
        children: [
          if (imageUrl != null)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                height: context.w(63),
                width: context.w(63),
                errorWidget: (_, error, s) {
                  if (imageUrl!.contains('alyssa')) {
                    log('ERROR: $error');
                  }
                  return _buildPlaceholder(context);
                },
              ),
            )
          else
            _buildPlaceholder(context),
          SizedBox(width: context.w(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SelectableText(title, style: CustomFonts.black20w600),
                if (subTitle != null)
                  SelectableText(subTitle ?? "", style: CustomFonts.black13w400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return CircleAvatar(
      radius: context.w(63) / 2,
      backgroundColor: CustomColors.softGrey,
      child: Icon(Icons.person, size: context.r(30), color: CustomColors.grey),
    );
  }
}
