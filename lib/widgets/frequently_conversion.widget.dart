import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/patient_detail_response.dart';
import '../screens/dashboard/patient_management_detail.dart';
import '../utils/theme.dart';
import '../view_models/patient_view_model.dart';

class FrequentlyConversionTile extends StatelessWidget {
  final String patientImage;
  final String name;
  final String email;
  final int appointmentId;
  final String appointmentRef;
  final int conversionCount;
  final String phoneNumber;

  const FrequentlyConversionTile({
    super.key,
    required this.patientImage,
    required this.name,
    required this.appointmentId,
    required this.email,
    required this.appointmentRef,
    required this.conversionCount,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => GestureDetector(
        onTap: () async {
          if (context.mounted) {
            context.push(PatientManagementDetailScreen.routeName);
            ref.read(patientProvider.notifier).setPatientDetail(
                  PatientDetailData(
                    id: appointmentId,
                    patientName: name,
                    email: email,
                    image: patientImage,
                    phoneNumber: phoneNumber,
                  ),
                );
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        "conversion Count: $conversionCount",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
