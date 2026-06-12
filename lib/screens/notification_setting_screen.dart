import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';

import '../utils/responsive.dart';
import '../widgets/header__with_back_btn.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _appointmentNotifications = true;
  bool _paymentNotifications = true;
  bool _aiReportNotifications = true;
  bool _followUpReminders = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              const BuildHeader(title: 'Notification Settings'),
              SizedBox(height: context.h(24)),
              // Main Card Container
              _buildCardContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContainer() {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(12)),
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Manage Notifications Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.h(16)),
            child: Text('Manage Notifications', style: context.fonts.black20w600),
          ),
          // Notification Options
          _buildNotificationOption(
            title: 'Appointment Notifications',
            subtitle: 'Get notified about new appointments',
            value: _appointmentNotifications,
            onChanged: (value) {
              setState(() {
                _appointmentNotifications = value;
              });
            },
          ),
          SizedBox(height: context.h(16)),
          _buildNotificationOption(
            title: 'Payment Notifications',
            subtitle: 'Get notified about payments',
            value: _paymentNotifications,
            onChanged: (value) {
              setState(() {
                _paymentNotifications = value;
              });
            },
          ),
          SizedBox(height: context.h(16)),
          _buildNotificationOption(
            title: 'AI Report Notifications',
            subtitle: 'Get notified when AI reports are ready',
            value: _aiReportNotifications,
            onChanged: (value) {
              setState(() {
                _aiReportNotifications = value;
              });
            },
          ),
          SizedBox(height: context.h(16)),
          _buildNotificationOption(
            title: 'Follow-up Reminders',
            subtitle: 'Get reminders for patient follow-ups',
            value: _followUpReminders,
            onChanged: (value) {
              setState(() {
                _followUpReminders = value;
              });
            },
          ),
          SizedBox(height: context.h(24)),
          _buildImportantNote(),
        ],
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20),
        vertical: context.h(16),
      ),
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.fonts.black16w600),
                SizedBox(height: context.h(4)),
                Text(subtitle, style: context.fonts.grey16w400),
              ],
            ),
          ),
          // Toggle Switch
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: CustomColors.white,
              activeTrackColor: CustomColors.black,
              inactiveThumbColor: CustomColors.white,
              inactiveTrackColor: CustomColors.border,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantNote() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FF),
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: context.sp(12),
            color: Colors.black87,
            height: 1.4,
          ),
          children: [
            TextSpan(text: 'Important: ', style: context.fonts.black16w600),
            TextSpan(
              text:
                  'You will need to enter a verification code sent to your phone every time you sign in.',
              style: context.fonts.grey16w400,
            ),
          ],
        ),
      ),
    );
  }
}
