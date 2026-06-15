import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/gradient_scaffold.dart';

import '../utils/responsive.dart';
import '../widgets/header__with_back_btn.dart';

class TwoFactorAuthScreen extends StatefulWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  State<TwoFactorAuthScreen> createState() => _TwoFactorAuthScreenState();
}

class _TwoFactorAuthScreenState extends State<TwoFactorAuthScreen> {
  bool _isTwoFactorEnabled = false;
  String _selectedMethod = 'sms'; // 'sms' or 'email'

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
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
              const BuildHeader(title: 'Two-Factor Authentication'),
              SizedBox(height: context.h(12)),
              // Divider
              const Divider(height: 1, thickness: 1, color: CustomColors.border),
              SizedBox(height: context.h(12)),
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
      padding: EdgeInsets.all(context.w(24)),
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
        children: [
          // Business Information Row
          _buildBusinessInfoRow(),
          SizedBox(height: context.h(30)),
          // Two-Factor Authentication Toggle Row
          _buildTwoFactorToggleRow(),

          if (_isTwoFactorEnabled) ...[
            SizedBox(height: context.h(24)),
            _buildVerificationMethodSection(),
            SizedBox(height: context.h(16)),
            _buildImportantNote(),
          ],
        ],
      ),
    );
  }

  Widget _buildBusinessInfoRow() {
    return Row(
      children: [
        // Purple Circle Icon
        Container(
          width: context.w(40),
          height: context.w(40),
          decoration: const BoxDecoration(
            color: Color(0xFFEEEBFF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.shield_outlined,
              size: context.r(20),
              color: const Color(0xFF6B5DD3),
            ),
          ),
        ),
        SizedBox(width: context.w(14)),
        // Text Column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Information', style: context.fonts.black16w600),
            SizedBox(height: context.h(4)),
            Text(
              'Update clinic details and contact info',
              style: context.fonts.grey16w400,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTwoFactorToggleRow() {
    return Container(
      padding: EdgeInsets.all(context.w(16)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.softGrey,
        borderRadius: BorderRadius.circular(context.r(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enable Two-Factor Authentication',
                style: context.fonts.black16w600,
              ),
              SizedBox(height: context.h(4)),
              Text(
                'Require a verification code when signing in',
                style: context.fonts.grey16w400,
              ),
            ],
          ),
          // Toggle Switch
          Switch(
            value: _isTwoFactorEnabled,
            onChanged: (value) {
              setState(() {
                _isTwoFactorEnabled = value;
              });
            },
            activeThumbColor: CustomColors.white,
            activeTrackColor: const Color(0xFF6B5DD3),
            inactiveThumbColor: CustomColors.white,
            inactiveTrackColor: CustomColors.border,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Verification Method', style: context.fonts.black20w600),
        SizedBox(height: context.h(16)),
        // SMS Verification Option
        _buildVerificationOption(
          icon: Icons.phone_android_outlined,
          title: 'SMS Verification',
          subtitle: 'Receive codes via text message',
          isSelected: _selectedMethod == 'sms',
          onTap: () {
            setState(() {
              _selectedMethod = 'sms';
            });
          },
        ),
        SizedBox(height: context.h(12)),
        // Email Verification Option
        _buildVerificationOption(
          icon: Icons.email_outlined,
          title: 'Email Verification',
          subtitle: 'Receive codes via email',
          isSelected: _selectedMethod == 'email',
          onTap: () {
            setState(() {
              _selectedMethod = 'email';
            });
          },
        ),
      ],
    );
  }

  Widget _buildVerificationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2CEF1) : CustomColors.white,
          borderRadius: BorderRadius.circular(context.r(12)),
          border: isSelected
              ? Border.all(color: const Color(0xFF6B5DD3), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: CustomColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: isSelected
                    ? CustomColors.white.withValues(alpha: 0.2)
                    : CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(8)),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: context.r(20),
                  color: isSelected ? const Color(0xFF6B5DD3) : CustomColors.grey,
                ),
              ),
            ),
            SizedBox(width: context.w(14)),
            // Text Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.fonts.black16w600),
                SizedBox(height: context.h(4)),
                Text(subtitle, style: context.fonts.grey16w400),
              ],
            ),
          ],
        ),
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
