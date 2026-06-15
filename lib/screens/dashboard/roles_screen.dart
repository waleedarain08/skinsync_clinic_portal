import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/responses/get_roles_response.dart';
import '../../utils/theme.dart';
import '../../view_models/role_view_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_primary_button.dart';
import '../../widgets/dialog_box/add_custom_role_dialog.dart';
import '../../widgets/gradient_scaffold.dart';

class RolesScreen extends ConsumerStatefulWidget {
  static const String routeName = '/roles';
  const RolesScreen({super.key});

  @override
  ConsumerState<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends ConsumerState<RolesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roleProvider.notifier).getRole();
    });
  }

  void _showAddRoleDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddCustomRoleDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Roles Management", style: context.fonts.black20w600),
                CustomPrimaryButton(
                  onTap: _showAddRoleDialog,
                  label: 'Add Custom Role',
                  icon: Icons.add,
                  height: context.h(45),
                ),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(20)),
            Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(roleProvider);
                if (state.loading) {
                  return const Center(child: AppLoader());
                }
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.roles.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: context.h(16)),
                    itemBuilder: (context, index) {
                      final selectedRole = state.roles[index];
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.r(12)),
                          side: const BorderSide(color: CustomColors.border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ExpansionTile(
                          onExpansionChanged: (value) {
                            final vm = ref.read(roleProvider.notifier);
                            if (!value) {
                              vm.clear();
                            }
                          },
                          backgroundColor: CustomColors.white,
                          collapsedBackgroundColor: CustomColors.white,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: CustomColors.blue.withValues(
                              alpha: 0.1,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: CustomColors.blue,
                              size: context.sp(20),
                            ),
                          ),
                          title: Text(
                            selectedRole.roleName?.toUpperCase() ?? "N/A",
                            style: context.fonts.black18w600,
                          ),
                          subtitle: Text(
                            "Configure permissions for this role",
                            style: context.fonts.grey14w400,
                          ),
                          children: [_buildRolePermissions(selectedRole)],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRolePermissions(Roles selectedRole) {
    return Padding(
      padding: EdgeInsets.all(context.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Permission Matrix", style: context.fonts.black16w700),
              CustomPrimaryButton(
                onTap: () {},
                label: "Save",
                icon: Icons.save_outlined,
                height: context.h(40),
                padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              ),
            ],
          ),
          SizedBox(height: context.h(16)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedRole.features!.length,
            itemBuilder: (context, index) {
              final feature = selectedRole.features![index];
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(10)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.border),
                    borderRadius: BorderRadius.circular(context.r(12)),
                    color: CustomColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.featureTitle ?? "N/A",
                        style: context.fonts.black16w600,
                      ),
                      SizedBox(height: context.h(10)),
                      Wrap(
                        spacing: context.w(8),
                        runSpacing: context.h(8),
                        children: List.generate(feature.permissions!.length, (
                          pIndex,
                        ) {
                          final permission = feature.permissions![pIndex];
                          final isSelected = feature.activePermissionIds!
                              .contains(permission.permissionId);

                          return ChoiceChip(
                            label: Text(permission.permissionTitle ?? "N/A"),
                            selected: isSelected,
                            selectedColor: CustomColors.black,
                            checkmarkColor: CustomColors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? CustomColors.white
                                  : CustomColors.black,
                              fontSize: context.sp(13),
                              fontWeight: FontWeight.w500,
                            ),
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  if (permission.permissionId != null) {
                                    feature.activePermissionIds!.add(
                                      permission.permissionId!,
                                    );
                                  }
                                } else {
                                  if (permission.permissionId != null) {
                                    feature.activePermissionIds!.remove(
                                      permission.permissionId!,
                                    );
                                  }
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
