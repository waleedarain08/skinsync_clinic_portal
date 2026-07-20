import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/theme.dart';
import '../../view_models/provider_view_model.dart';

class AuthorizedRolesWidget extends ConsumerStatefulWidget {
  final String title;
  final String description;
  final List<String> selectedRoles;
  final Function(String) onRoleToggled;

  const AuthorizedRolesWidget({
    super.key,
    required this.title,
    required this.description,
    required this.selectedRoles,
    required this.onRoleToggled,
  });

  @override
  ConsumerState<AuthorizedRolesWidget> createState() =>
      _AuthorizedRolesWidgetState();
}

class _AuthorizedRolesWidgetState extends ConsumerState<AuthorizedRolesWidget> {
  Widget _sectionTitle(BuildContext context, String title, {double? fontSize}) {
    return Text(
      title,
      style: context.fonts.black18w600.copyWith(
        fontSize: fontSize != null ? context.sp(fontSize) : null,
      ),
    );
  }

  Widget _roleChip(
    BuildContext context,
    String role,
    bool isSelected,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: context.appBorderRadius(all: 30),
      child: Container(
        padding: context.appEdgeInsets(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? CustomColors.purple : Colors.white,
          borderRadius: context.appBorderRadius(all: 30),
          border: Border.all(
            color: isSelected ? CustomColors.purple : CustomColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: isSelected ? Colors.white : CustomColors.grey,
              size: 18,
            ),
            context.horizontalSpace(8),
            Text(
              role,
              style: isSelected
                  ? context.fonts.white14w600
                  : context.fonts.black14w400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(providerRoleViewModelProvider.notifier)
          .fetchProviderRoles();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> availableRoles = [
    //   'Injector',
    //   'Aesthetician',
    //   'MD',
    //   'Nurse',
    //   'Specialist',
    // ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, widget.title),
        context.verticalSpace(8),
        Text(widget.description, style: context.fonts.grey14w400),
        context.verticalSpace(24),
        Consumer(
          builder: (context, ref, _) {
            final roles =
                ref.watch(providerRoleViewModelProvider).providerRoles ?? [];

            if (roles.isEmpty) {
              return Text(
                'No provider roles available.',
                style: context.fonts.grey13w500,
              );
            }
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: roles.map((role) {
                final isSelected = widget.selectedRoles.contains(role.name);
                return _roleChip(
                  context,
                  role.name ?? "",
                  isSelected,
                  () => widget.onRoleToggled(role.name ?? ""),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
