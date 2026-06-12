import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/extentions.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: Column(
          children: [
            SizedBox(height: context.h(20)),
            Row(
              children: [
                Text("Treatments", style: context.fonts.black20w600),
                const Spacer(),
                CustomPrimaryButton(
                  onTap: () {
                    context.push('/clinic-add-treatment');
                  },
                  label: 'Add Treatment',
                  icon: Icons.add,
                  height: context.h(45),
                ),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(50)),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(treatmentViewModelProvider);

                  if (state.loading) {
                    return ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (context, index) => SizedBox(height: context.h(20)),
                      itemBuilder: (context, index) {
                        return Container(
                          height: context.isLandscape ? context.h(300) : context.h(100),
                          margin: EdgeInsets.symmetric(
                            horizontal: context.w(20),
                            vertical: context.h(10),
                          ),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(context.r(15)),
                          ),
                        );
                      },
                    ).withShimmer();
                  } else if (state.treatments.isEmpty) {
                    return const EmptyWidget();
                  }

                  return ListView.separated(
                    itemCount: state.treatments.length,
                    separatorBuilder: (context, index) => SizedBox(height: context.h(20)),
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
