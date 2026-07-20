import 'package:flutter/material.dart';
import '../../utils/theme.dart';
import '../custom_dropdown_widget.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddNoteDialog());
  }

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();
  String _selectedNote = 'All note';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StandardDialog(
      title: "Add Note",
      width: 520.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Note Type', style: context.fonts.black14w600),
          context.verticalSpace(8),
          CustomDropdown(
            hint: 'All note',
            value: _selectedNote,
            items: const ['All note', 'Note 1', 'Note 2', 'Note 3'],
            height: 48.h,
            onChanged: (value) =>
                setState(() => _selectedNote = value ?? 'All note'),
          ),
          context.verticalSpace(20),
          Text('Note', style: context.fonts.black14w600),
          context.verticalSpace(8),
          TextField(
            controller: _noteController,
            maxLines: 5,
            style: context.fonts.black14w400,
            decoration: AppDecorations.input(
              context,
              hint: 'Write your note here...',
            ),
          ),
        ],
      ),
      actions: [
        CustomPrimaryButton(
          onTap: () => Navigator.pop(context),
          label: 'Save Note',
          width: 140.w,
        ),
      ],
    );
  }
}
