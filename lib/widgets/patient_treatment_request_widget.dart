import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../models/responses/login_response_model.dart';
import 'app_network_image.dart';

class PatientTreatmentRequestCard extends StatelessWidget {
  final RequestClinicTreatmentModel data;
  final VoidCallback? onTap;

  const PatientTreatmentRequestCard({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final patientName = data.patientName?.isNotEmpty == true
        ? data.patientName!
        : 'Patient';

    final patientEmail = data.patientEmail ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Patient Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 52,
                width: 52,
                child: data.image != null && data.image!.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: data.image!,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(14),
                        errorIcon: Iconsax.user,
                      )
                    : Container(
                        color: theme.primaryColor.withValues(alpha: 0.08),
                        child: Icon(
                          Iconsax.user,
                          size: 25,
                          color: theme.primaryColor,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Patient Information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Patient Name
                  Text(
                    patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Email
                  if (patientEmail.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Iconsax.sms,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            patientEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Treatment Count
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Iconsax.health,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Total Request: ${data.totalTreatmentCount ?? 0} ',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Arrow
            Icon(
              Iconsax.arrow_right_3,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}