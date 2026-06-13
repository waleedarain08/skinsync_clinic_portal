import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_clinic_portal/models/responses/get_feature_response.dart';
import 'package:skinsync_clinic_portal/view_models/role_view_model.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';

import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../app_loader.dart';

class AddCustomRoleDialog extends ConsumerStatefulWidget {
  const AddCustomRoleDialog({super.key});

  @override
  ConsumerState<AddCustomRoleDialog> createState() =>
      _AddCustomRoleDialogState();
}

class _AddCustomRoleDialogState extends ConsumerState<AddCustomRoleDialog> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roleProvider.notifier).getFeature();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.w(50),
        vertical: context.h(50),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: SizedBox(
        width: context.isLandscape ? context.w(600) : double.infinity,
        child: Padding(
          padding: EdgeInsets.all(context.r(24)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Custom Role', style: CustomFonts.black20w600),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(context.r(4)),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: CustomColors.border),
                        ),
                        child: Icon(
                          Icons.close,
                          size: context.r(20),
                          color: CustomColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(30)),
                Text("Role Name", style: CustomFonts.black14w500),
                SizedBox(height: context.h(8)),
                TextFormField(
                  controller: controller,
                  style: CustomFonts.black14w400,
                  decoration: InputDecoration(
                    hintText: "e.g. Manager",
                    hintStyle: CustomFonts.grey14w400,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.w(16),
                      vertical: context.h(14),
                    ),
                    filled: true,
                    fillColor: CustomColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.r(8)),
                      borderSide: const BorderSide(color: CustomColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.r(8)),
                      borderSide: const BorderSide(color: CustomColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.r(8)),
                      borderSide: const BorderSide(color: CustomColors.purple),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Role name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.h(30)),
                Text("Assign Permissions", style: CustomFonts.black14w500),
                SizedBox(height: context.h(16)),
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(roleProvider);
                    if (state.loading) {
                      return const Center(
                        child: AppLoader(color: CustomColors.purple),
                      );
                    } else if (state.features.isEmpty) {
                      return Center(
                        child: Text(
                          "No Features Available",
                          style: CustomFonts.grey14w400,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.features.length,
                          itemBuilder: (context, index) {
                            final feature = state.features[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: context.h(10)),
                              child: _buildFeatureContainer(
                                feature: feature,
                                ref: ref,
                                context: context,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: context.h(32)),
                Consumer(
                  builder: (context, ref, _) {
                    final loading = ref.watch(roleProvider).createRoleLoading;
                    final state = ref.read(roleProvider);

                    return Row(
                      children: [
                        Expanded(
                          child: CustomPrimaryButton(
                            label: 'Create Role',
                            isLoading: loading,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (state.selectedFeatures.isEmpty) {
                                  EasyLoading.showToast(
                                    "Please select at least one permission",
                                  );
                                  return;
                                } else {
                                  final success = await ref
                                      .read(roleProvider.notifier)
                                      .createRole(controller.text.trim());

                                  if (success == true && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(width: context.w(16)),
                        Expanded(
                          child: CustomOutlinedButton(
                            label: 'Cancel',
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureContainer({
    required Feature feature,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final vm = ref.read(roleProvider.notifier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.r(10)),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.border),
        borderRadius: BorderRadius.circular(context.r(12)),
        color: CustomColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature.featureName ?? "N/A", style: CustomFonts.black16w600),
          SizedBox(height: context.h(10)),
          Wrap(
            spacing: context.w(8),
            runSpacing: context.h(8),
            children: List.generate(feature.permissions!.length, (index) {
              final permissions = feature.permissions![index];
              final selectedFeature = vm.getSelectedFeature(feature.featureId!);
              final isSelected =
                  selectedFeature?.permissions?.any(
                    (a) => a.permissionId == permissions.permissionId,
                  ) ??
                  false;

              return ChoiceChip(
                label: Text(permissions.permissionTitle ?? "N/A"),
                selected: isSelected,
                selectedColor: CustomColors.black,
                checkmarkColor: CustomColors.white,
                labelStyle: TextStyle(
                  color: isSelected ? CustomColors.white : CustomColors.black,
                  fontSize: context.sp(13),
                  fontWeight: FontWeight.w500,
                ),
                onSelected: (value) {
                  vm.toggleAction(
                    feature: feature,
                    permissions: permissions,
                    selected: value,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
