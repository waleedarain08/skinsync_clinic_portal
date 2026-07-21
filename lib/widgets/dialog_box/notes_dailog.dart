import 'package:flutter/material.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class NotesDailog extends StatelessWidget {
  const NotesDailog({super.key});

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Notes",
      width: 520.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Note", style: context.fonts.black14w600),
          context.verticalSpace(8),
          TextField(
            maxLines: 4,
            style: context.fonts.black14w400,
            decoration: AppDecorations.input(
              context,
              hint: "Write your note here",
            ),
          ),
        ],
      ),
      actions: [
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context),
          label: "Save Note",
          width: 140.w,
        ),
      ],
    );
  }
}
