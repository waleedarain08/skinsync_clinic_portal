import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/utils/extentions.dart';
import 'package:skinsync_clinic_portal/widgets/empty_widget.dart';
import 'package:skinsync_clinic_portal/widgets/treatment_list_tile.dart';

import '../../utils/responsive.dart';
import '../../view_models/treatment_view_model.dart';

class TreatmentScreen extends ConsumerStatefulWidget {
  const TreatmentScreen({super.key});

  static const String routeName = '/treatment';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TreatmentScreenState();
}

class _TreatmentScreenState extends ConsumerState<TreatmentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(treatmentViewModelProvider.notifier).getTreatments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(treatmentViewModelProvider);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Text("Treatments", style: CustomFonts.black20w600),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.push('/clinic-add-treatment');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    children: [
                      Center(
                        child: Icon(Icons.add, color: Colors.white, size: 20.r),
                      ),
                      SizedBox(width: 10.w),
                      Text('Add Treatment', style: CustomFonts.white14w600),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Divider(color: Colors.grey.shade300),
            SizedBox(height: 50.h),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(treatmentViewModelProvider);

                  if (state.loading) {
                    return ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) => SizedBox(height: 20.h),
                      itemBuilder: (context, index) {
                        return Container(
                          height: context.isLandscape ? 300.h : 100.h,
                          margin: EdgeInsets.all(20.w),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        );
                      },
                    ).withShimmer();
                  } else if (state.treatments.isEmpty) {
                    return EmptyWidget();
                  }

                  return ListView.separated(
                    itemCount: state.treatments.length,
                    separatorBuilder: (_, __) => SizedBox(height: 20.h),
                    itemBuilder: (context, index) {
                      final treatment = state.treatments[index];
                      return TreatmentListTile(treatment: treatment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
