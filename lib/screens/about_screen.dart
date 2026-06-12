import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/widgets/header__with_back_btn.dart';

import '../utils/responsive.dart';
import '../utils/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  static const String routeName = '/About';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int selectedTab = 0; // 0 = Terms & Conditions, 1 = Privacy Policy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              const BuildHeader(title: 'About'),
              // Divider
              SizedBox(height: context.h(16)),

              const Divider(height: 1, thickness: 1, color: CustomColors.border),

              SizedBox(height: context.h(16)),

              // Tab Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                child: Container(
                  padding: EdgeInsets.all(context.w(10)),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: BorderRadius.circular(context.r(8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTab(
                          title: 'Terms & Conditions',
                          isSelected: selectedTab == 0,
                          onTap: () => setState(() => selectedTab = 0),
                        ),
                      ),
                      Expanded(
                        child: _buildTab(
                          title: 'Privacy Policy',
                          isSelected: selectedTab == 1,
                          onTap: () => setState(() => selectedTab = 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: context.h(24)),

              // Content based on selected tab
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(context.w(16)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.r(12)),
                      color: CustomColors.white,
                    ),
                    child: selectedTab == 0
                        ? _buildTermsAndConditions()
                        : _buildPrivacyPolicy(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.isLandscape ? context.w(16) : context.w(6),
          vertical: context.h(10),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? CustomColors.black : Colors.transparent,
            width: context.r(1),
          ),
          color: isSelected ? CustomColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(context.r(6)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: CustomColors.black.withValues(alpha: 0.05),
                    blurRadius: context.r(4),
                    offset: Offset(0, context.h(2)),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: CustomFonts.black14w600,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Terms & Conditions', style: CustomFonts.black20w600),
        SizedBox(height: context.h(20)),
        _buildSection(
          number: '1',
          title: 'Acceptance of Terms',
          content:
              'By accessing and using SkinSync AI, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to these terms, please do not use this service.',
        ),
        _buildSection(
          number: '2',
          title: 'Use License',
          content:
              'Permission is granted to temporarily use SkinSync AI for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title.',
        ),
        _buildSection(
          number: '3',
          title: 'Medical Information Disclaimer',
          content:
              'SkinSync AI provides AI-powered recommendations for aesthetic treatments. All recommendations should be reviewed and approved by licensed medical professionals. The AI analysis is for guidance purposes only and does not replace professional medical judgment.',
        ),
        _buildSection(
          number: '4',
          title: 'Data Security and HIPAA Compliance',
          content:
              'We are committed to protecting patient data and maintaining HIPAA compliance. All patient information is encrypted and stored securely. Access to patient data is restricted to authorized personnel only.',
        ),
        _buildSection(
          number: '5',
          title: 'Limitation of Liability',
          content:
              'SkinSync AI shall not be liable for any damages arising out of or in connection with the use or inability to use the service, even if we have been advised of the possibility of such damages.',
        ),
        _buildSection(
          number: '6',
          title: 'Modifications',
          content:
              'SkinSync AI may revise these terms at any time without notice. By using this application, you are agreeing to be bound by the current version of these terms.',
        ),
        SizedBox(height: context.h(24)),
      ],
    );
  }

  Widget _buildPrivacyPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacy Policy', style: CustomFonts.black20w600),
        SizedBox(height: context.h(20)),
        _buildSection(
          number: '1',
          title: 'Information Collection',
          content:
              'We collect information you provide directly to us, including personal information such as your name, email address, and any other information you choose to provide.',
        ),
        _buildSection(
          number: '2',
          title: 'Use of Information',
          content:
              'We use the information we collect to provide, maintain, and improve our services, to communicate with you, and to personalize your experience.',
        ),
        _buildSection(
          number: '3',
          title: 'Information Sharing',
          content:
              'We do not share your personal information with third parties except as described in this privacy policy or with your consent.',
        ),
        _buildSection(
          number: '4',
          title: 'Data Security',
          content:
              'We take reasonable measures to help protect your personal information from loss, theft, misuse, unauthorized access, disclosure, alteration, and destruction.',
        ),
        _buildSection(
          number: '5',
          title: 'Your Rights',
          content:
              'You have the right to access, update, or delete your personal information at any time. You may also opt out of receiving promotional communications from us.',
        ),
        _buildSection(
          number: '6',
          title: 'Contact Us',
          content:
              'If you have any questions about this Privacy Policy, please contact us through the app or via email at support@skinsync.ai.',
        ),
        SizedBox(height: context.h(24)),
      ],
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. $title', style: CustomFonts.black16w600),
          SizedBox(height: context.h(8)),
          Text(content, style: CustomFonts.grey16w400),
        ],
      ),
    );
  }
}
