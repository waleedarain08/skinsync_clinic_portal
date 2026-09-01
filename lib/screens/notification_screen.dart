import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/notification_response.dart';
import '../utils/theme.dart';
import '../view_models/notification_view_model.dart';
import '../widgets/app_loader.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/number_paginator.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/Notification';

  final bool showBackButton;

  const NotificationScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  ConsumerState<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModel.notifier).fetchReels(page: 1);
    });
  }

  void _onPageChanged(int page) {
    // NumberPaginator is 0-indexed in the UI; the API is 1-indexed.
    ref.read(notificationViewModel.notifier).fetchReels(page: page + 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModel);

    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, state),
            context.verticalSpace(32),
            _buildNotificationsSection(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showBackButton) ...[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: CustomColors.black,
            ),
            onPressed: () => context.pop(),
          ),
          context.horizontalSpace(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: context.fonts.level1Heading,
              ),
              context.verticalSpace(6),
              Text(
                'Stay updated with real-time clinic alerts, appointments, and activity logs.',
                style: context.fonts.grey13w500,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ref
                .read(notificationViewModel.notifier)
                .fetchReels(page: state.currentPage, showLoading: true);
          },
          icon: Icon(
            Icons.refresh_rounded,
            color: CustomColors.purple,
            size: context.sp(20),
          ),
          tooltip: 'Refresh Notifications',
          style: IconButton.styleFrom(
            backgroundColor: CustomColors.lightPurple,
            shape: RoundedRectangleBorder(
              borderRadius: context.appBorderRadius(all: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    NotificationState state,
  ) {
    if (state.loading && state.notification.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: AppLoader()),
      );
    }

    if (state.notification.isEmpty) {
      return Padding(
        padding: context.appEdgeInsets(vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(context.r(16)),
                decoration: const BoxDecoration(
                  color: CustomColors.whiteGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.notification_bing,
                  size: context.sp(40),
                  color: CustomColors.grey,
                ),
              ),
              context.verticalSpace(16),
              Text(
                'No notifications yet',
                style: context.fonts.black18w600,
              ),
              context.verticalSpace(6),
              Text(
                'When you get new notifications, they will appear here.',
                style: context.fonts.grey13w500,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.notification.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(context, state.notification[index]);
          },
        ),
        if (state.totalPages > 1) ...[
          context.verticalSpace(24),
          Center(
            child: NumberPaginator(
              totalPages: state.totalPages,
              currentPage: state.currentPage - 1, // 0-indexed for UI
              onPageChanged: _onPageChanged,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationData notification,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.r(10)),
            decoration: BoxDecoration(
              color: CustomColors.lightPurple,
              borderRadius: BorderRadius.circular(context.r(10)),
            ),
            child: Icon(
              Iconsax.notification5,
              color: CustomColors.purple,
              size: context.sp(20),
            ),
          ),
          context.horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title ?? 'Notification',
                        style: context.fonts.black16w600,
                      ),
                    ),
                    if (notification.createdAt != null) ...[
                      context.horizontalSpace(12),
                      Text(
                        _formatRelativeTime(notification.createdAt!),
                        style: context.fonts.grey12w400,
                      ),
                    ],
                  ],
                ),
                if (notification.body != null &&
                    notification.body!.isNotEmpty) ...[
                  context.verticalSpace(6),
                  Text(
                    notification.body!,
                    style: context.fonts.grey14w400,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
