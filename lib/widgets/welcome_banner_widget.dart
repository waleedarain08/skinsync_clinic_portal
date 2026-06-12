import 'package:flutter/material.dart';
import 'package:skinsync_clinic_portal/services/locator.dart';
import 'package:skinsync_clinic_portal/services/storage_service.dart';

import '../utils/theme.dart';

class WelcomeBannerWidget extends StatelessWidget {
  const WelcomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7DD3D3), Color(0xFF9BA7D4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(context.r(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: locator<SecureStorageService>().getUser(),
            builder: (context, snapshot) {
              final name = snapshot.data?.name;
              return Text(
                name != null ? 'Welcome back, $name 👋' : 'Welcome back 👋',
                style: CustomFonts.black20w600,
              );
            },
          ),
          SizedBox(height: context.h(6)),
          Text(
            "Here's what's happening at your clinic today",
            style: CustomFonts.grey14w400,
          ),
        ],
      ),
    );
  }
}
