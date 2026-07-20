import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class ChatDailog extends StatelessWidget {
  const ChatDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Chat",
      width: 752.w,
      content: SizedBox(
        height: 600.h,
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    PngAssets.person,
                    height: 52.w,
                    width: 52.w,
                  ),
                ),
                context.horizontalSpace(14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sarah Jhonson", style: context.fonts.black16w600),
                    Text("Patient ID: 1", style: context.fonts.grey14w400),
                  ],
                ),
              ],
            ),
            context.verticalSpace(24),
            Center(
              child: Container(
                padding: context.appEdgeInsets(horizontal: 22, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: context.appBorderRadius(all: 35),
                  color: CustomColors.whiteGrey,
                  border: Border.all(color: CustomColors.border),
                ),
                child: Text("Today", style: context.fonts.grey13w600),
              ),
            ),
            context.verticalSpace(24),
            Expanded(
              child: ListView(
                children: [
                  _buildRightContainer(
                    context: context,
                    text: "The class was very interesting",
                  ),
                  _buildLeftContainer(
                    context: context,
                    text: "Thankyou so much looking forward to next class",
                  ),
                  _buildRightContainer(
                    context: context,
                    text: "Kindly share Notes for reading",
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sarah Johnson, 11:35 PM",
                          style: context.fonts.grey11w400,
                        ),
                        context.verticalSpace(4),
                        Container(
                          width: 292.w,
                          padding: context.appEdgeInsets(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.whiteGrey,
                            borderRadius: context.appBorderRadius(
                              topRight: 24,
                              bottomRight: 24,
                              bottomLeft: 24,
                            ),
                            border: Border.all(color: CustomColors.border),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                SvgAssets.arrowDownCircle,
                                height: 36.w,
                                width: 36.w,
                              ),
                              context.horizontalSpace(13),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "notes.pdf",
                                    style: context.fonts.black14w600,
                                  ),
                                  Text(
                                    "867 Kb",
                                    style: context.fonts.grey11w400,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Icon(
                                Icons.download_rounded,
                                size: 24.sp,
                                color: CustomColors.purple,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            context.verticalSpace(24),
            TextField(
              style: context.fonts.black14w400,
              decoration: AppDecorations.input(
                context,
                hint: "Write a message...",
                suffixIcon: Padding(
                  padding: context.appEdgeInsets(right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: pi / 2,
                        child: Icon(
                          Icons.attachment,
                          size: 24.sp,
                          color: CustomColors.grey,
                        ),
                      ),
                      context.horizontalSpace(8),
                      Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.send_outlined,
                          size: 20.sp,
                          color: CustomColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightContainer({
    required BuildContext context,
    required String text,
  }) {
    return Align(
      alignment: Alignment.topRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("You, 11:30 PM", style: context.fonts.grey11w400),
          context.verticalSpace(4),
          Container(
            padding: context.appEdgeInsets(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: CustomColors.lightPurple,
              borderRadius: context.appBorderRadius(
                topLeft: 24,
                bottomRight: 24,
                bottomLeft: 24,
              ),
            ),
            child: Text(text, style: context.fonts.black14w500),
          ),
          context.verticalSpace(12),
        ],
      ),
    );
  }

  Widget _buildLeftContainer({
    required BuildContext context,
    required String text,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sarah Johnson, 11:35 PM", style: context.fonts.grey11w400),
          context.verticalSpace(4),
          Container(
            padding: context.appEdgeInsets(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: CustomColors.whiteGrey,
              borderRadius: context.appBorderRadius(
                topRight: 24,
                bottomRight: 24,
                bottomLeft: 24,
              ),
              border: Border.all(color: CustomColors.border),
            ),
            child: Text(text, style: context.fonts.black14w500),
          ),
          context.verticalSpace(12),
        ],
      ),
    );
  }
}
