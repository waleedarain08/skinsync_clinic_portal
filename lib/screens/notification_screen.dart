import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../utils/responsive.dart';
import '../widgets/header__with_back_btn.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  static const String routeName = '/Notification';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
      icon: Icons.calendar_today_outlined,
      iconBgColor: const Color(0xFFE8F4FD),
      iconColor: const Color(0xFF2196F3),
      title: 'New Appointment Alert',
      description:
          'You have a new appointment booked for 3:00 PM with Sarah Johnson.',
      dateTime: '10/29/2025, 1:00:00 PM',
      isNew: true,
    ),
    NotificationModel(
      icon: Icons.attach_money,
      iconBgColor: const Color(0xFFE8F5E9),
      iconColor: const Color(0xFF4CAF50),
      title: 'Payment Received',
      description:
          'A payment of AED 450 has been successfully processed for treatments.',
      dateTime: '10/28/2025, 7:25:00 PM',
      isNew: true,
    ),
    NotificationModel(
      icon: Icons.description_outlined,
      iconBgColor: const Color(0xFFFCE4EC),
      iconColor: const Color(0xFFE91E63),
      title: 'AI Report Ready',
      description:
          'AI analysis for patient Emily Clark\'s facial scan is now available.',
      dateTime: '10/27/2025, 4:30:00 PM',
      isNew: false,
    ),
    NotificationModel(
      icon: Icons.notifications_outlined,
      iconBgColor: const Color(0xFFFFF3E0),
      iconColor: const Color(0xFFFF9800),
      title: 'Follow-Up Reminder',
      description:
          'It\'s time to schedule a 2-week follow-up for patient John Smith.',
      dateTime: '10/26/2025, 2:00:00 PM',
      isNew: false,
    ),
    NotificationModel(
      icon: Icons.access_time,
      iconBgColor: const Color(0xFFFFFDE7),
      iconColor: const Color(0xFFFFEB3B),
      title: 'Low Availability Notice',
      description:
          'Only two slots remaining for tomorrow, consider enabling dynamic pricing to fill gaps.',
      dateTime: '10/25/2025, 10:00:00 PM',
      isNew: false,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification.isNew = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              const BuildHeader(title: 'Notifications'),
              SizedBox(height: context.h(16)),

              // Divider
              const Divider(height: 1, thickness: 1, color: CustomColors.border),

              SizedBox(height: context.h(16)),

              // Mark all read button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _markAllAsRead,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(12),
                        vertical: context.h(8),
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.white,
                        borderRadius: BorderRadius.circular(context.r(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: context.r(20),
                            color: Colors.black87,
                          ),
                          SizedBox(width: context.w(6)),
                          Text('Mark all read', style: context.fonts.black18w600),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(16)),

              // Notifications Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.r(16)),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(8)),
                    border: Border.all(color: CustomColors.border, width: 1),
                  ),
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => Divider(
                      height: context.h(24),
                      thickness: 1,
                      color: CustomColors.softGrey,
                    ),
                    itemBuilder: (context, index) {
                      return _buildNotificationItem(notifications[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      padding: EdgeInsets.all(context.w(10)),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border, width: 1),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(context.r(10)),
            decoration: BoxDecoration(
              color: notification.iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification.icon,
              color: notification.iconColor,
              size: context.r(20),
            ),
          ),

          SizedBox(width: context.w(12)),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: context.fonts.black16w600),
                SizedBox(height: context.h(4)),
                Text(notification.description, style: context.fonts.grey16w400),
                SizedBox(height: context.h(4)),
                Text(notification.dateTime, style: context.fonts.grey16w400),
              ],
            ),
          ),

          SizedBox(width: context.w(12)),

          // New Badge
          if (notification.isNew)
            Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(10), vertical: context.h(4)),
              decoration: BoxDecoration(
                color: CustomColors.black,
                borderRadius: BorderRadius.circular(context.r(4)),
              ),
              child: Text(
                'New',
                style: context.fonts.white10w600.copyWith(
                  fontSize: context.sp(11),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NotificationModel {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String description;
  final String dateTime;
  bool isNew;

  NotificationModel({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isNew,
  });
}
