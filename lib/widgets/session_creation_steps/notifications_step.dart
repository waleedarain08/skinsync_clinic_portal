import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/string_utils.dart';
import '../../models/notification_entry.dart';
import '../../utils/theme.dart';
import '../../view_models/session_view_model.dart';
import '../build_textfield.dart';

class NotificationsStep extends ConsumerWidget {
  const NotificationsStep({super.key});

  Widget _expandableSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.appBorderRadius(all: 12),
        border: Border.all(color: CustomColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: context.appEdgeInsets(all: 8),
            decoration: BoxDecoration(
              color: CustomColors.purple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: CustomColors.purple, size: 18),
          ),
          title: Text(title.capitalize, style: context.fonts.black16w600),
          children: [
            const Divider(height: 1),
            Padding(padding: context.appEdgeInsets(all: 24), child: content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SessionState state = ref.watch(sessionViewModelProvider);
    final viewModel = ref.read(sessionViewModelProvider.notifier);

    return StatefulBuilder(
      builder: (context, setState) {
        Widget buildCustomNotificationBuilder(
          List<NotificationEntry> entries,
          bool isPre,
        ) {
          final types = isPre
              ? ['reminder', 'warning', 'instruction']
              : ['recovery', 'care', 'follow-up reminder'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPre
                        ? 'Custom Pre Notifications'
                        : 'Custom Post Notifications',
                    style: context.fonts.black14w600,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        if (isPre) {
                          viewModel.addPreNotificationEntry();
                        } else {
                          viewModel.addPostNotificationEntry();
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: CustomColors.purple,
                    ),
                    label: const Text('Add Notification'),
                  ),
                ],
              ),
              context.verticalSpace(12),
              if (entries.isEmpty)
                Container(
                  width: double.infinity,
                  padding: context.appEdgeInsets(all: 16),
                  decoration: BoxDecoration(
                    color: CustomColors.whiteGrey,
                    borderRadius: context.appBorderRadius(all: 12),
                    border: Border.all(color: CustomColors.border),
                  ),
                  child: Text(
                    "No custom notifications added. Tap 'Add Notification' to create one.",
                    style: context.fonts.grey13w500,
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => context.verticalSpace(16),
                  itemBuilder: (context, idx) {
                    final entry = entries[idx];
                    return Container(
                      padding: context.appEdgeInsets(all: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: context.appBorderRadius(all: 12),
                        border: Border.all(color: CustomColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Notification #${idx + 1}',
                                style: context.fonts.purple14w700,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: CustomColors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (isPre) {
                                      viewModel.removePreNotificationEntry(idx);
                                    } else {
                                      viewModel.removePostNotificationEntry(
                                        idx,
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Title',
                            controller: entry.titleController,
                            hintText: 'e.g. Avoid alcohol',
                          ),
                          context.verticalSpace(12),
                          BuildTextField(
                            label: 'Message Content',
                            controller: entry.messageController,
                            hintText: 'Enter notification message...',
                            maxLines: 2,
                          ),
                          context.verticalSpace(12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: BuildTextField(
                                  label: 'Timing Value',
                                  controller: entry.timingValueController,
                                  hintText: 'e.g. 24',
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              context.horizontalSpace(12),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Timing Unit',
                                      style: context.fonts.black14w600,
                                    ),
                                    context.verticalSpace(8),
                                    DropdownButtonHideUnderline(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: CustomColors.border,
                                          ),
                                        ),
                                        child: DropdownButton<String>(
                                          value: entry.timingUnit,
                                          isExpanded: true,
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'minutes',
                                              child: Text('Minutes'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'hours',
                                              child: Text('Hours'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'days',
                                              child: Text('Days'),
                                            ),
                                          ],
                                          onChanged: (v) {
                                            if (v != null) {
                                              setState(() {
                                                entry.timingUnit = v;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Type (Optional)',
                                style: context.fonts.black14w600,
                              ),
                              context.verticalSpace(8),
                              DropdownButtonHideUnderline(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: CustomColors.border,
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    value: types.contains(entry.type)
                                        ? entry.type
                                        : types.first,
                                    isExpanded: true,
                                    items: types
                                        .map(
                                          (t) => DropdownMenuItem(
                                            value: t,
                                            child: Text(t.capitalize),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null) {
                                        setState(() {
                                          entry.type = v;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          );
        }

        return Column(
          children: [
            _expandableSection(
              context,
              title: 'Pre-Treatment Notifications',
              icon: Icons.notifications_none_rounded,
              content: buildCustomNotificationBuilder(
                state.preNotificationEntries,
                true,
              ),
            ),
            context.verticalSpace(24),
            _expandableSection(
              context,
              title: 'Post-Treatment Notifications',
              icon: Icons.notifications_active_outlined,
              content: buildCustomNotificationBuilder(
                state.postNotificationEntries,
                false,
              ),
            ),
          ],
        );
      },
    );
  }
}
