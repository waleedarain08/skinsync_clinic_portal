import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../custom_dropdown_widget.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.3,
        padding: EdgeInsets.symmetric(
          vertical: context.h(20),
          horizontal: context.w(20),
        ),
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: context.w(32),
                    width: context.w(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: CustomColors.border),
                    ),
                    child: Icon(Icons.close, size: context.r(18)),
                  ),
                ),
              ],
            ),
            Text('Note Type', style: CustomFonts.black18w600),
            SizedBox(height: context.h(8)),
            CustomDropdown(
              hint: 'All note',
              value: _selectedNote,
              items: const ['All note', 'Note 1', 'Note 2', 'Note 3'],
              height: context.h(42),
              onChanged: (value) =>
                  setState(() => _selectedNote = value ?? 'All note'),
            ),
            SizedBox(height: context.h(16)),
            Text('Note', style: CustomFonts.black18w600),
            SizedBox(height: context.h(8)),

            /// Note TextField
            TextField(
              controller: _noteController,
              maxLines: 5,
              style: CustomFonts.black14w400,
              decoration: InputDecoration(
                hintText: 'Write your note here...',
                hintStyle: CustomFonts.grey14w400,
                filled: true,
                fillColor: CustomColors.softGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.r(12)),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(context.r(14)),
              ),
            ),
            SizedBox(height: context.h(20)),

            /// Save Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: context.h(16)),
                decoration: BoxDecoration(
                  color: CustomColors.black,
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                child: Center(
                  child: Text('Save', style: CustomFonts.white14w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
