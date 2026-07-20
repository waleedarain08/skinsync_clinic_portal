import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../custom_dropdown_widget.dart';
import '../custom_primary_button.dart';
import '../../utils/theme.dart';
import 'standard_dialog.dart';

class AddNotesDailog extends StatefulWidget {
  const AddNotesDailog({super.key});

  @override
  State<AddNotesDailog> createState() => _AddNotesDailogState();
}

class _AddNotesDailogState extends State<AddNotesDailog> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Add Note",
      width: 520.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Note Type", style: context.fonts.black14w600),
          context.verticalSpace(8),
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
            height: 48.h,
            onChanged: (value) =>
                setState(() => _selectedType = value ?? 'General Note'),
          ),
          context.verticalSpace(20),
          Text("Notes", style: context.fonts.black14w600),
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
          label: "Save Note",
          onTap: () => context.pop(),
          width: 120.w,
        ),
      ],
    );
  }
}
