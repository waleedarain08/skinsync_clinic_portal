import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';

import '../../utils/theme.dart';

class NotesDailog extends StatelessWidget {
  const NotesDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Container(
        width: context.w(354),
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
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
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
            ),

            Text("Notes", style: CustomFonts.black18w600),
            SizedBox(height: context.h(5)),
            TextField(
              maxLines: 2,
              style: CustomFonts.black14w400,
              decoration: InputDecoration(
                hintText: "Write your note here",
                hintStyle: CustomFonts.grey14w400,
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
            SizedBox(height: context.h(30)),
            CustomPrimaryButton(
              onTap: () {},
              label: "Save Note",
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
