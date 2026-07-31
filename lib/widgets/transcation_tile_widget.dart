import 'package:flutter/material.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';
import 'dialog_box/receipt_details.dart';

class TranscationTileWidget extends StatelessWidget {
  const TranscationTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (context) => const ReceiptDialog(),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(15),
          vertical: context.h(15),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.r(15)),
          border: Border.all(color: CustomColors.border),
        ),
        child: AdaptiveLayoutRowColumn(
          alignment: MainAxisAlignment.spaceBetween,
          widthBetween: 0,
          children: [
            Container(
              padding: EdgeInsets.all(context.w(12)),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColors.lightPurple,
              ),
              child: Icon(
                Icons.article_rounded,
                size: context.r(24),
                color: CustomColors.purple,
              ),
            ),
            SizedBox(width: context.r(30)),
            Column(
              crossAxisAlignment: context.isLandscape
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sarah Johnson", style: CustomFonts.black16w600),
                Text("Botox", style: CustomFonts.grey14w400),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: context.r(16),
                      color: CustomColors.grey,
                    ),
                    SizedBox(width: context.r(10)),
                    Text("10/29/2025", style: CustomFonts.grey14w400),
                    SizedBox(width: context.r(20)),
                    Icon(
                      Icons.access_time,
                      size: context.r(16),
                      color: CustomColors.grey,
                    ),
                    SizedBox(width: context.r(10)),
                    Text("3:00 PM", style: CustomFonts.grey14w400),
                  ],
                ),
              ],
            ),
            context.isLandscape ? const Spacer() : const SizedBox.shrink(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$ 350",
                  style: TextStyle(
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.w600,
                    color: CustomColors.purple,
                    fontFamily: 'Degular',
                  ),
                ),
                SizedBox(width: context.r(10)),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(context.w(7)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(8)),
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Icon(
                      Icons.file_download_outlined,
                      size: context.r(16),
                      color: CustomColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
