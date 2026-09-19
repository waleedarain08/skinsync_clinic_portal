import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/responses/staff__list_response.dart';
import '../../utils/string_utils.dart';
import '../../utils/theme.dart';
import '../../view_models/staff_view_model.dart';

class AddPractitionerDialog extends ConsumerStatefulWidget {
  const AddPractitionerDialog({super.key});

  @override
  ConsumerState<AddPractitionerDialog> createState() => _AddPractitionerDialogState();
}

class _AddPractitionerDialogState extends ConsumerState<AddPractitionerDialog> {
  final TextEditingController _searchController = TextEditingController();
  StaffModel? _selectedStaff;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffViewModelProvider.notifier).getStaff();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final staffState = ref.watch(staffViewModelProvider);
    final staffList = staffState.staff;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(16))),
      child: Container(
        width: context.w(500),
        padding: context.appEdgeInsets(all: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Practitioner', style: context.fonts.black18w600),
            context.verticalSpace(16),
            TextField(
              controller: _searchController,
              decoration: AppDecorations.input(
                context,
                hint: 'Search by name or email...',
                prefixIcon: const Icon(Iconsax.search_normal, color: CustomColors.grey),
              ),
              onChanged: (value) {
                ref.read(staffViewModelProvider.notifier).getStaff(search: value);
              },
            ),
            context.verticalSpace(16),
            SizedBox(
              height: context.h(300),
              child: staffState.loading
                  ? const Center(child: CircularProgressIndicator())
                  : staffList.isEmpty
                      ? const Center(child: Text('No staff found'))
                      : ListView.separated(
                          itemCount: staffList.length,
                          separatorBuilder: (context, index) => const Divider(color: CustomColors.border),
                          itemBuilder: (context, index) {
                            final staff = staffList[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: CustomColors.lightPurple,
                                child: Text(staff.name.firstOrNull ?? 'P', style: context.fonts.purple14w600),
                              ),
                              title: Text(staff.name, style: context.fonts.black14w600),
                              subtitle: Text(staff.email, style: context.fonts.grey12w400),
                              trailing: Radio<int>(
                                value: staff.id,
                                groupValue: _selectedStaff?.id,
                                activeColor: CustomColors.purple,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedStaff = staff;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedStaff = staff;
                                });
                              },
                            );
                          },
                        ),
            ),
            context.verticalSpace(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: context.fonts.grey14w600),
                ),
                context.horizontalSpace(12),
                ElevatedButton(
                  onPressed: _selectedStaff == null
                      ? null
                      : () => Navigator.pop(context, _selectedStaff),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.purple,
                    foregroundColor: CustomColors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.r(8))),
                    padding: context.appEdgeInsets(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Add', style: context.fonts.white14w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
