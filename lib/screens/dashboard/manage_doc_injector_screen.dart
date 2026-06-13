import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/string_utils.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/empty_widget.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';
import 'package:skinsync_clinic_portal/widgets/patient_selection_tile.dart';

import '../../../utils/assets.dart';
import '../../models/requests/register_doctor_request.dart';
import '../../models/responses/register_doctor_response.dart';
import '../../view_models/doctor_view_model.dart';
import '../../widgets/app_loader.dart';
import '../add_doctor_injector_screen.dart';

class MangeDoctorsInjectorsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/manage-doctors-injectors';

  const MangeDoctorsInjectorsScreen({super.key});

  @override
  ConsumerState<MangeDoctorsInjectorsScreen> createState() =>
      _MangeDoctorsInjectorsScreenState();
}

class _MangeDoctorsInjectorsScreenState
    extends ConsumerState<MangeDoctorsInjectorsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(doctorProvider.notifier).getDoctors(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(20),
          vertical: context.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Manage Doctors / Injectors",
                  style: context.fonts.black20w600,
                ),
                CustomPrimaryButton(
                  onTap: () => context.push(AddDoctorInjectorScreen.routeName),
                  label: 'Add Doctor / Injector',
                  icon: Icons.add,
                  height: context.h(45),
                ),
              ],
            ),
            SizedBox(height: context.h(14)),
            const Divider(color: CustomColors.border),
            SizedBox(height: context.h(32)),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(doctorProvider);
                  if (state.loading) {
                    return const Center(child: AppLoader());
                  } else if (state.doctors.isEmpty) {
                    return Center(
                      child: EmptyWidget(
                        height: context.h(300),
                        width: context.w(300),
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorSelection(state),
                      SizedBox(width: context.w(24)),
                      Expanded(child: rightSideContent(state.selectedDoctor)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rightSideContent(Doctor? selectedDoctor) {
    if (selectedDoctor == null) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          patientInfo(context: context, selectedDoctor: selectedDoctor),
          SizedBox(height: context.h(20)),
          medicalInfo(context: context, selectedDoctor: selectedDoctor),
          SizedBox(height: context.h(20)),
        ],
      ),
    );
  }

  Widget medicalInfo({
    required BuildContext context,
    required Doctor selectedDoctor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Services", style: context.fonts.black20w600),
          SizedBox(height: context.h(20)),
          Wrap(
            spacing: context.w(12),
            runSpacing: context.h(12),
            children: List.generate(selectedDoctor.treatments?.length ?? 0, (
              index,
            ) {
              final Treatment? treatment = selectedDoctor.treatments?[index];
              return Container(
                padding: EdgeInsets.all(context.w(16)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.r(10)),
                  color: CustomColors.white,
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment?.treatmentName ?? "",
                      style: context.fonts.black18w600,
                    ),
                    SizedBox(height: context.h(12)),
                    Wrap(
                      spacing: context.w(10),
                      runSpacing: context.h(10),
                      children: List.generate(
                        treatment?.sideAreas?.length ?? 0,
                        (index) {
                          final SideArea? sideArea =
                              treatment?.sideAreas?[index];

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.w(10),
                              vertical: context.h(8),
                            ),
                            decoration: BoxDecoration(
                              color: CustomColors.softGrey,
                              borderRadius: BorderRadius.circular(
                                context.r(15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  SvgAssets.stethoscope,
                                  height: context.h(16),
                                  width: context.w(16),
                                  colorFilter: const ColorFilter.mode(
                                    CustomColors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: context.w(6)),
                                Text(
                                  sideArea?.sideAreaName ?? "",
                                  style: context.fonts.black14w500,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          if (selectedDoctor.availability?.isNotEmpty ?? false) ...{
            SizedBox(height: context.h(24)),
            Text("Availability", style: context.fonts.black20w600),
            SizedBox(height: context.h(16)),
            Container(
              padding: EdgeInsets.all(context.w(16)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.r(10)),
                color: CustomColors.white,
                border: Border.all(color: CustomColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (Availability availability
                      in selectedDoctor.availability ?? [])
                    for (final day in availability.days)
                      Padding(
                        padding: EdgeInsets.only(bottom: context.h(10)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(10),
                                vertical: context.h(8),
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.softGrey,
                                borderRadius: BorderRadius.circular(
                                  context.r(15),
                                ),
                              ),
                              child: Text(
                                day,
                                style: context.fonts.black14w500,
                              ),
                            ),
                            SizedBox(width: context.w(16)),
                            Text(
                              '${availability.startTime.format(context)} to ${availability.endTime.format(context)}',
                              style: context.fonts.black14w600,
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          },
        ],
      ),
    );
  }

  Widget patientInfo({
    required BuildContext context,
    required Doctor selectedDoctor,
  }) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(15)),
        border: Border.all(color: CustomColors.border),
      ),
      child: Row(
        children: [
          if (selectedDoctor.image != null)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: selectedDoctor.image!,
                height: context.r(80),
                width: context.r(80),
                fit: BoxFit.cover,
                errorWidget: (_, _, _) {
                  return CircleAvatar(
                    radius: context.r(40),
                    backgroundColor: CustomColors.softGrey,
                    child: Icon(
                      Icons.person,
                      size: context.r(30),
                      color: CustomColors.grey,
                    ),
                  );
                },
              ),
            )
          else
            CircleAvatar(
              radius: context.r(40),
              backgroundColor: CustomColors.softGrey,
              child: Icon(
                Icons.person,
                size: context.r(30),
                color: CustomColors.grey,
              ),
            ),
          SizedBox(width: context.w(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedDoctor.name ?? 'N/A',
                  style: context.fonts.black18w600,
                ),
                SizedBox(height: context.h(4)),
                Text(
                  selectedDoctor.role?.name.capitalize ?? 'N/A',
                  style: context.fonts.grey14w400,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push(
                AddDoctorInjectorScreen.routeName,
                extra: selectedDoctor,
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: CustomColors.purple,
                  size: context.r(18),
                ),
                SizedBox(width: context.w(6)),
                Text(
                  "Edit",
                  style: context.fonts.black14w600.copyWith(
                    color: CustomColors.purple,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSelection(DoctorState state) {
    return SizedBox(
      width: context.w(386),
      child: Column(
        children: [
          const CupertinoSearchTextField(
            backgroundColor: CustomColors.softGrey,
          ),
          SizedBox(height: context.h(20)),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) =>
                  SizedBox(height: context.h(12)),
              itemCount: state.doctors.length,
              itemBuilder: (context, index) {
                return InkWell(
                  borderRadius: BorderRadius.circular(context.r(15)),
                  onTap: () => ref
                      .read(doctorProvider.notifier)
                      .setSelectedDoctor(state.doctors[index]),
                  child: PatientSelectionTile(
                    title: state.doctors[index].name ?? 'N/A',
                    subTitle: state.doctors[index].email ?? 'N/A',
                    imageUrl: state.doctors[index].image,
                    isSelected: state.selectedDoctor == state.doctors[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
