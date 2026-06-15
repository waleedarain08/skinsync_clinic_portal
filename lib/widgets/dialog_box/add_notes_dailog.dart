import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom_dropdown_widget.dart';
import '../custom_primary_button.dart';

import '../../utils/theme.dart';

class AddNotesDailog extends StatefulWidget {
  const AddNotesDailog({super.key});

  @override
  State<AddNotesDailog> createState() => _AddNotesDailogState();
}

class _AddNotesDailogState extends State<AddNotesDailog> {
  String? _selectedType;

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
            Text("Note Type", style: CustomFonts.black18w600),
            SizedBox(height: context.h(5)),
            CustomDropdown(
              hint: "Select type",
              value: _selectedType,
              items: const [
                "General Note",
                "Treatment Note",
                "Follow-up Note",
                "Prescription Note",
                "Allergy Note",
                "Pre-Treatment Note",
                "Post-Treatment Note",
                "Consultation Note",
              ],
              height: context.h(42),
              onChanged: (value) =>
                  setState(() => _selectedType = value ?? 'General Note'),
            ),
            SizedBox(height: context.h(30)),

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
              label: "Save Note",
              onTap: () {
                context.pop();
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
