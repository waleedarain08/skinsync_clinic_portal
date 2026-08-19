import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../main.dart';
import '../about_screen.dart';
import '../dynamic_pricing.dart';
import '../notification_screen.dart';
import '../../utils/theme.dart';
import '../../view_models/auth_view_model.dart';
import '../../widgets/gradient_scaffold.dart';

import '../business_info_screen.dart';
import '../change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(20),
                vertical: context.h(16),
              ),
              child: Text("Profile", style: context.fonts.black24w700),
            ),
            const Divider(color: CustomColors.border, height: 1),
            SizedBox(height: context.h(20)),
            // Profile Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: _buildProfileInfoContainer(context),
            ),
            SizedBox(height: context.h(20)),
            // Clinic Settings
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: _buildSettingsSection(
                context: context,
                title: "Clinic Settings",
                items: [
                  _SettingItemData(
                    icon: Icons.business_outlined,
                    title: "Business Information",
                    subtitle: "Update clinic details and contact info",
                    onTap: () {
                      context.push(BusinessInformationScreen.routeName);
                    },
                  ),
                  if (!isDeploymentMode)
                    _SettingItemData(
                      icon: Icons.calendar_month_outlined,
                      title: "Dynamic Pricing",
                      subtitle: "Configure dynamic pricing for off-peak hours",
                      onTap: () {
                        context.pushNamed(DynamicPricing.routeName);
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: context.h(20)),

            // password security
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: _buildSettingsSection(
                context: context,
                title: "Security",
                items: [
                  if (!isDeploymentMode)
                    _SettingItemData(
                      icon: Icons.shield_outlined,
                      title: "Two-Factor Authentication",
                      subtitle: "Update password and security settings",
                      onTap: () {
                        context.push(ChangePasswordScreen.routeName);
                      },
                    ),
                  _SettingItemData(
                    icon: Icons.lock_open,
                    title: "Password & Security",
                    subtitle: "Add extra security to your account",
                    onTap: () {
                      context.push(ChangePasswordScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
            if (!isDeploymentMode) SizedBox(height: context.h(20)),
            // preference
            if (!isDeploymentMode)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                child: _buildSettingsSection(
                  context: context,
                  title: "Preferences",
                  items: [
                    _SettingItemData(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "Manage notification settings",
                      onTap: () {
                        context.push(NotificationScreen.routeName);
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(height: context.h(20)),
            // help
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              child: _buildSettingsSection(
                context: context,
                title: "Help & Support",
                items: [
                  _SettingItemData(
                    icon: Icons.privacy_tip_outlined,
                    title: "About",
                    subtitle: "Terms, conditions, and privacy policy",
                    onTap: () {
                      context.push(AboutScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(30)),
          ],
        ),
      ),
    );
  }

  // Profile Info Container
  Widget _buildProfileInfoContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8A5D8), Color(0xFF7B94C4)],
        ),
        borderRadius: BorderRadius.circular(context.r(15)),
      ),
      child: Consumer(
        builder: (context, ref, _) {
          final name = ref.watch(authViewModelProvider).user?.name;
          final image = ref.watch(authViewModelProvider).user?.clinic?.logo;
          final email = ref.watch(authViewModelProvider).user?.email;
          return Column(
            children: [
              Container(
                width: context.w(70),
                height: context.w(70),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CustomColors.softGrey,
                  border: Border.all(
                    color: CustomColors.white,
                    width: context.w(3),
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    image ?? '',
                    height: context.r(80),
                    width: context.r(80),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: context.r(40));
                    },
                  ),
                ),
              ),
              SizedBox(height: context.h(12)),
              Text(
                name ?? "N/A",
                style: context.fonts.black18w600.copyWith(
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                email ?? 'N/A',
                style: context.fonts.black13w400.copyWith(
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Reusable Settings Section
  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required List<_SettingItemData> items,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        boxShadow: [
          BoxShadow(
            color: CustomColors.black.withValues(alpha: 0.12),
            blurRadius: context.r(8),
            offset: Offset(0, context.h(2)),
          ),
        ],
        borderRadius: BorderRadius.circular(context.r(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.fonts.black16w600),
          SizedBox(height: context.h(14)),
          ...items.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: context.h(10)),
              child: _buildSettingItem(
                context: context,
                icon: item.icon,
                title: item.title,
                subtitle: item.subtitle,
                onTap: item.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Setting Item Row
  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.w(8)),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: context.r(18), color: CustomColors.black),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.fonts.black14w600.copyWith(
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.h(2)),
                Text(
                  subtitle,
                  style: context.fonts.grey12w400.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            CupertinoIcons.chevron_right,
            size: context.r(16),
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}

// Data Model
class _SettingItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _SettingItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
