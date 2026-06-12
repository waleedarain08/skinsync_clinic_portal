import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';

import '../../utils/theme.dart';

class ChatDailog extends StatelessWidget {
  const ChatDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(752),
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    PngAssets.person,
                    height: context.w(52),
                    width: context.w(52),
                  ),
                ),
                SizedBox(width: context.w(14)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sarah Jhonson", style: CustomFonts.black16w600),
                    Text("Patient ID: 1", style: CustomFonts.grey14w400),
                  ],
                ),
                const Spacer(),
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

            SizedBox(height: context.h(35)),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.w(22),
                  vertical: context.h(11),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(35)),
                  color: CustomColors.softGrey,
                ),
                child: Text("Today", style: CustomFonts.grey13w600),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                            style: CustomFonts.grey12w400,
                          ),
                          SizedBox(height: context.h(4)),
                          Container(
                            width: context.w(292),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(18),
                              vertical: context.h(14),
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(context.r(24)),
                                bottomRight: Radius.circular(context.r(24)),
                                bottomLeft: Radius.circular(context.r(24)),
                              ),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.arrowDownCircle,
                                  height: context.w(36),
                                  width: context.w(29),
                                ),
                                SizedBox(width: context.w(13)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "notes.pdf",
                                      style: CustomFonts.black14w600,
                                    ),
                                    Text(
                                      "867 Kb",
                                      style: CustomFonts.grey12w400,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  SvgAssets.arrowDownCircle,
                                  height: context.w(31),
                                  width: context.w(31),
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
            ),
            SizedBox(height: context.h(24)),
            TextField(
              style: CustomFonts.black14w400,
              decoration: InputDecoration(
                hintText: "Write a message...",
                hintStyle: CustomFonts.grey14w400,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: context.w(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.rotate(
                        angle: pi / 2,
                        child: Icon(
                          Icons.attachment,
                          size: context.r(24),
                          color: CustomColors.grey,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      Transform.rotate(
                        angle: -pi / 4,
                        child: Icon(
                          Icons.send_outlined,
                          size: context.r(20),
                          color: CustomColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.w(16),
                  vertical: context.h(14),
                ),
                filled: true,
                fillColor: CustomColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(12)),
                  borderSide: const BorderSide(color: CustomColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(12)),
                  borderSide: const BorderSide(color: CustomColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(12)),
                  borderSide: const BorderSide(color: CustomColors.purple),
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
          Text("You, 11:30 PM", style: CustomFonts.grey12w400),
          SizedBox(height: context.h(4)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(18),
              vertical: context.h(14),
            ),
            decoration: BoxDecoration(
              color: CustomColors.lightPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(context.r(24)),
                bottomRight: Radius.circular(context.r(24)),
                bottomLeft: Radius.circular(context.r(24)),
              ),
            ),
            child: Text(text, style: CustomFonts.black14w500),
          ),
          SizedBox(height: context.h(12)),
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
          Text("Sarah Johnson, 11:35 PM", style: CustomFonts.grey12w400),
          SizedBox(height: context.h(4)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(18),
              vertical: context.h(14),
            ),
            decoration: BoxDecoration(
              color: CustomColors.softGrey,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(context.r(24)),
                bottomRight: Radius.circular(context.r(24)),
                bottomLeft: Radius.circular(context.r(24)),
              ),
            ),
            child: Text(text, style: CustomFonts.black14w500),
          ),
          SizedBox(height: context.h(12)),
        ],
      ),
    );
  }
}
