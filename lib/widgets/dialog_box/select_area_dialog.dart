import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/extentions.dart';
import '../../utils/theme.dart';
import '../../view_models/area_view_model.dart';
import '../custom_outlined_button.dart';
import '../custom_primary_button.dart';
import 'standard_dialog.dart';

class SelectAreaDialog extends ConsumerStatefulWidget {
  const SelectAreaDialog({super.key});

  @override
  ConsumerState<SelectAreaDialog> createState() => _SelectAreaDialogState();
}

class _SelectAreaDialogState extends ConsumerState<SelectAreaDialog> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(areaViewModelProvider.notifier).clearSelectedAreas();
      ref.read(areaViewModelProvider.notifier).fetchAreas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(areaViewModelProvider);

    return StandardDialog(
      title: "Select Areas",
      width: 600.w,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Areas", style: context.fonts.black14w600),
            context.verticalSpace(12),

            if (state.loading == true)
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: List.generate(
                  8,
                  (_) => Container(
                    width: 90.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: CustomColors.softGrey,
                      borderRadius: context.appBorderRadius(all: 8),
                    ),
                  ).withShimmer(),
                ),
              )
            else if (state.areas.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Text(
                    "No Areas Found",
                    style: context.fonts.grey14w400,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: state.areas.map((area) {
                  final selected = state.selectedAreas?.id == area.id;
                  return ChoiceChip(
                    label: Text(area.name ?? "N/A"),
                    selected: selected,
                    selectedColor: CustomColors.purple,
                    checkmarkColor: CustomColors.white,
                    backgroundColor: CustomColors.whiteGrey,
                    labelStyle: context.fonts.black14w500.copyWith(
                      color: selected ? CustomColors.white : CustomColors.black,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: context.appBorderRadius(all: 8),
                      side: BorderSide(
                        color: selected
                            ? CustomColors.purple
                            : CustomColors.border,
                      ),
                    ),
                    onSelected: (_) {
                      ref
                          .read(areaViewModelProvider.notifier)
                          .toggleSelectedArea(area);
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      actions: [
        CustomOutlinedButton(
          onTap: () {
            ref.read(areaViewModelProvider.notifier).clearSelectedAreas();
            Navigator.pop(context);
          },
          label: "Cancel",
          width: 100.w,
        ),
        CustomPrimaryButton(
          onTap: () async {
           if (state.selectedAreas == null) {
              EasyLoading.showError("Please select at least one area");
              return;
            }

            await ref.read(areaViewModelProvider.notifier).addAreas();

            if (mounted) {
              Navigator.pop(context);
            }
          },
          label: "Add Areas",
          width: 150.w,
        ),
      ],
    );
  }
}
