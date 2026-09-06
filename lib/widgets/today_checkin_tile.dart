import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/dashboard/appointment_detail_screen.dart';
import '../utils/theme.dart';
import '../view_models/appointment_view_model.dart';

class TodaysCheckInTile extends StatelessWidget {
  final String patientImage;
  final String name;
  final String email;
  final int appointmentId;
  final String appointmentRef;

  const TodaysCheckInTile({
    super.key,
    required this.patientImage,
    required this.name,
    required this.appointmentId,
    required this.email,
    required this.appointmentRef,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return GestureDetector(
          onTap: () async {
            await ref
                .read(appointmentProvider.notifier)
                .getAppointmentsDetail(id: appointmentId);
            if (context.mounted) {
              context.push(AppointmentDetailScreen.routeName);
            }
          },
          child: Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.r(10)),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: .center,
              children: [
                // Patient Avatar
                ClipOval(
                  child: Image.network(
                    patientImage,
                    width: context.r(44),
                    height: context.r(44),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: context.r(44),
                      height: context.r(44),
                      color: CustomColors.purple.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: CustomColors.purple,
                        size: context.sp(22),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.w(10)),

                // Patient Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: context.fonts.black16w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        email,
                        style: context.fonts.grey13w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(2)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(3),
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.purple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(context.r(6)),
                        ),
                        child: Text(
                          'Ref: $appointmentRef',
                          style: TextStyle(
                            color: CustomColors.purple,
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
