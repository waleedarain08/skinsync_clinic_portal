import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/responses/login_response_model.dart';
import '../screens/dashboard/patient_management_detail.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import '../view_models/patient_view_model.dart';

class FrequentlyConversionTile extends StatelessWidget {
  final FrequentlyConversion data;
  

  const FrequentlyConversionTile({
    super.key,
    required this.data,
    
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => GestureDetector(
        onTap: () async {
          if (context.mounted) {
          

                      final success = await ref
                          .read(patientProvider.notifier)
                          .getPatientDetail(patientId: data.patientId);

                      if (success && context.mounted) {
                        context.push(
                          PatientManagementDetailScreen.routeName,
                          extra:  data.patientId,
                        );
                      }
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
                  data.patientImage,
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
                            data.name.capitalize,
                            style: context.fonts.black16w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        data.email,
                        style: context.fonts.grey13w500,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        "conversion Count: ${data.conversionCount}",
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
                          'Ref: ${data.appointmentRef}',
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
