import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/string_utils.dart';
import '../../utils/theme.dart';
import '../../models/responses/register_practitioner_response.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../widgets/gradient_scaffold.dart';

class PractitionerDetailScreen extends StatelessWidget {
  static const String routeName = '/practitioner-detail';

  final Practitioner practitioner;

  const PractitionerDetailScreen({
    super.key,
    required this.practitioner,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        flexibleSpace: AppDecorations.appBarGradient,
        elevation: 0,
        centerTitle: true,
        title: Text(practitioner.basicInfo?.name ?? 'Practitioner Details', style: context.fonts.black18w600),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CustomColors.black),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.w(800)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio / Profile Overview Card
                Text(
                  'PRACTITIONER BIO',
                  style: context.fonts.grey11w600ls12,
                ),
                context.verticalSpace(12),
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  borderRadius: context.r(12),
                  child: Row(
                    children: [
                      _buildAvatar(context),
                      context.horizontalSpace(20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              practitioner.basicInfo?.name ?? 'N/A',
                              style: context.fonts.black20w600,
                            ),
                            context.verticalSpace(4),
                            Text(
                              practitioner.basicInfo?.role.capitalize ?? 'N/A',
                              style: context.fonts.grey14w400,
                            ),
                            context.verticalSpace(4),
                            Text(
                              practitioner.contactInfo?.email ?? 'N/A',
                              style: context.fonts.purple14w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                context.verticalSpace(32),

                // Services and Treatments Cards
                Text(
                  'ASSIGNED SERVICES & TREATMENTS',
                  style: context.fonts.grey11w600ls12,
                ),
                context.verticalSpace(12),
                BorderdContainerWidget(
                  padding: context.appEdgeInsets(all: 24),
                  borderRadius: context.r(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assigned Services',
                        style: context.fonts.black16w600,
                      ),
                      context.verticalSpace(16),
                      // if (practitioner.treatments == null || practitioner.treatments!.isEmpty)
                      //   Text(
                      //     'No services assigned to this practitioner.',
                      //     style: context.fonts.grey14w400,
                      //   )
                      // else
                      //   Wrap(
                      //     spacing: context.w(12),
                      //     runSpacing: context.h(12),
                      //     children: practitioner.treatments!.map((treatment) {
                      //       return Container(
                      //         padding: context.appEdgeInsets(all: 16),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(context.r(10)),
                      //           color: Colors.white,
                      //           border: Border.all(color: CustomColors.border),
                      //         ),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               treatment.treatmentName ?? "",
                      //               style: context.fonts.black16w600,
                      //             ),
                      //             context.verticalSpace(12),
                      //             Wrap(
                      //               spacing: context.w(10),
                      //               runSpacing: context.h(10),
                      //               children: (treatment.sideAreas ?? []).map((sideArea) {
                      //                 return Container(
                      //                   padding: context.appEdgeInsets(horizontal: 10, vertical: 8),
                      //                   decoration: BoxDecoration(
                      //                     color: CustomColors.softGrey,
                      //                     borderRadius: BorderRadius.circular(context.r(15)),
                      //                   ),
                      //                   child: Row(
                      //                     mainAxisSize: MainAxisSize.min,
                      //                     children: [
                      //                       SvgPicture.asset(
                      //                         SvgAssets.stethoscope,
                      //                         height: context.h(16),
                      //                         width: context.w(16),
                      //                         colorFilter: const ColorFilter.mode(
                      //                           CustomColors.black,
                      //                           BlendMode.srcIn,
                      //                         ),
                      //                       ),
                      //                       context.horizontalSpace(6),
                      //                       Text(
                      //                         sideArea.sideAreaName ?? "",
                      //                         style: context.fonts.black14w500,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                    ],
                  ),
                ),
                context.verticalSpace(32),

                // Weekly Availability Hours
                if (practitioner.availabilityInfo?.availability != null && practitioner.availabilityInfo!.availability.isNotEmpty) ...[
                  Text(
                    'CLINICAL AVAILABILITY HOURS',
                    style: context.fonts.grey11w600ls12,
                  ),
                  context.verticalSpace(12),
                  BorderdContainerWidget(
                    padding: context.appEdgeInsets(all: 24),
                    borderRadius: context.r(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Schedule',
                          style: context.fonts.black16w600,
                        ),
                        context.verticalSpace(16),
                        ...practitioner.availabilityInfo!.availability!.map((availability) {
                          return Column(
                            children: availability.days.map((day) {
                              return Padding(
                                padding: context.appEdgeInsets(bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: context.appEdgeInsets(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: CustomColors.softGrey,
                                        borderRadius: BorderRadius.circular(context.r(15)),
                                      ),
                                      child: Text(
                                        day,
                                        style: context.fonts.black14w500,
                                      ),
                                    ),
                                    context.horizontalSpace(16),
                                    Text(
                                      availability.uiTimeRange(context),
                                      style: context.fonts.black14w600,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (practitioner.basicInfo?.image != null) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: practitioner.basicInfo!.image!,
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
      );
    }
    return CircleAvatar(
      radius: context.r(40),
      backgroundColor: CustomColors.softGrey,
      child: Icon(
        Icons.person,
        size: context.r(30),
        color: CustomColors.grey,
      ),
    );
  }
}
