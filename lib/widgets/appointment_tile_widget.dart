import 'package:flutter/material.dart';
import '../models/dummy/appointment_dummy.dart';
import 'borderd_container_widget.dart';

import '../utils/theme.dart';

class AppointmentTileWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final AppointmentModel appointment;

  const AppointmentTileWidget({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: BorderdContainerWidget(
        margin: EdgeInsets.only(bottom: context.h(15)),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(10)),
                color: CustomColors.blue.withValues(alpha: 0.15),
              ),
              padding: EdgeInsets.all(context.w(12)),
              margin: EdgeInsets.symmetric(horizontal: context.w(14)),
              child: const Icon(
                Icons.event_outlined,
                color: CustomColors.blue,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appointment.patientName,
                        style: CustomFonts.black16w600,
                      ),
                      SizedBox(width: context.w(10)),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(context.r(10)),
                          color: appointment.status.color,
                        ),
                        padding: EdgeInsets.all(context.w(9)),
                        child: Text(
                          appointment.status.label,
                          style: CustomFonts.white12w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(10)),
                  Text(appointment.treatment, style: CustomFonts.black16w500),
                  SizedBox(height: context.h(7)),
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: context.r(17),
                        color: CustomColors.black,
                      ),
                      SizedBox(width: context.w(5)),
                      Text(appointment.date, style: CustomFonts.black14w500),
                      SizedBox(width: context.w(10)),
                      Icon(
                        Icons.schedule,
                        size: context.r(17),
                        color: CustomColors.black,
                      ),
                      SizedBox(width: context.w(5)),
                      Text(appointment.time, style: CustomFonts.black14w500),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$ ${appointment.amount.toStringAsFixed(0)}',
                  style: CustomFonts.black16w600.copyWith(
                    color: CustomColors.blue,
                  ),
                ),
                SizedBox(height: context.h(14)),
                Text(appointment.doctor, style: CustomFonts.black14w500),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
