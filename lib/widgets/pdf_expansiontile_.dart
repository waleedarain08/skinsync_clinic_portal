import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/assets.dart';
import '../view_models/auth_view_model.dart';
import 'signpad_widget.dart';

import '../utils/theme.dart';

class PDFExpansionTile extends StatelessWidget {
  const PDFExpansionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.h(9)),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: CustomColors.border),
          borderRadius: BorderRadius.circular(context.r(16)),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: const BorderSide(color: CustomColors.border),
          borderRadius: BorderRadius.circular(context.r(16)),
        ),
        clipBehavior: Clip.antiAlias,
        leading: Image.asset(PngAssets.pdf, height: context.h(33), width: context.w(44)),
        title: Text(
          "Client Intake Form.pdf",
          style: CustomFonts.black12w600,
        ),
        subtitle: Text(
          "867 Kb    14 Feb 2022 at 11:30 am",
          style: CustomFonts.grey14w400,
        ),
        trailing: SvgPicture.asset(
          SvgAssets.downloadIcon,
          height: context.w(20),
          width: context.w(20),
        ),
        childrenPadding: EdgeInsets.symmetric(
          horizontal: context.w(22),
          vertical: context.h(19),
        ),
        children: [
          const Divider(height: 0, color: CustomColors.border),
          SizedBox(height: context.h(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Text Field 1", style: CustomFonts.grey14w400),
              Text("Client Input", style: CustomFonts.black14w400),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Text Field 2", style: CustomFonts.grey14w400),
              Text("Client Input", style: CustomFonts.black14w400),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Text Field 2", style: CustomFonts.grey14w400),
              Text("Client Input", style: CustomFonts.black14w400),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: context.h(54),
                width: context.w(101),
                child: Image.asset(
                  PngAssets.signature,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              Consumer(
                builder: (context, ref, _) {
                  final signature = ref.watch(authViewModelProvider).signature;
                  if (signature != null) {
                    return RawImage(image: signature, height: context.h(60), fit: BoxFit.contain);
                  }

                  return GestureDetector(
                    onTap: () async {
                      final ui.Image? sig = await ESignatureDialog.show(context);
                      if (sig != null) {
                        ref.read(authViewModelProvider.notifier).saveSignature(sig);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(context.w(9)),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColors.black),
                        borderRadius: BorderRadius.circular(context.r(8)),
                        color: CustomColors.softGrey,
                      ),
                      child: Text(
                        " + Draw Signature",
                        style: CustomFonts.black12w400,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: context.h(6)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.w(105),
                    height: context.h(1),
                    color: CustomColors.black,
                  ),
                  Text(
                    "Patient Signature",
                    style: CustomFonts.black14w400,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.w(105),
                    height: context.h(1),
                    color: CustomColors.black,
                  ),
                  Text(
                    "Clinic Signature",
                    style: CustomFonts.black14w400,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
