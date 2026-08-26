import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

import '../../view_models/auth_view_model.dart';
import '../../widgets/gradient_scaffold.dart';
import '../../widgets/analytics_grid_widget.dart';
import '../../widgets/borderd_container_widget.dart';
import '../../services/locator.dart';
import '../../services/storage_service.dart';
import '../../widgets/recent_treatment_row_widget.dart';
import '../../widgets/treatment_list_widget.dart';
import '../business_info_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
   ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    

    // Call API to fetch user details
    ref.read(authViewModelProvider.notifier).callGetMe();

    // Wait until the build phase completes before showing the dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isCompleted = ref.read(authViewModelProvider).isCompletedProfile;

      if (!isCompleted && mounted) {
        _showIncompleteProfileDialog(context);
      }
    });
    super.initState();
  }

void _showIncompleteProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force user to acknowledge
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(16)),
          ),
          child: SizedBox(
            width: context.w(360), // Decreased width constraint
            child: Padding(
              padding: EdgeInsets.all(context.w(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        color: CustomColors.purple,
                        size: context.sp(22),
                      ),
                      SizedBox(width: context.w(8)),
                      Expanded(
                        child: Text(
                          'Complete Your Profile',
                          style: CustomFonts.black16w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(12)),
                  Text(
                    'Your clinic profile is incomplete. Update your business information to access all portal features.',
                    style: CustomFonts.grey13w500,
                  ),
                  SizedBox(height: context.h(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Remind Me Later',
                          style: CustomFonts.grey13w500,
                        ),
                      ),
                      SizedBox(width: context.w(8)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.r(8)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.pushNamed(BusinessInformationScreen.routeName); 
                         
                        },
                        child: const Text(
                          'Update Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 28, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row (Matches Admin Dashboard Screen structure and styles)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: locator<SecureStorageService>().getUser(),
                    builder: (context, snapshot) {
                      final name = snapshot.data?.name ?? 'Alex';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Morning, $name',
                            style: context.fonts.level1Heading,
                          ),
                          context.verticalSpace(6),
                          Text(
                            "Here's a summary of your MedSpa clinic performance.",
                            style: context.fonts.grey13w500,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // _buildDateFilter(context),
              ],
            ),
            context.verticalSpace(32),

            // Analytics Section (styled exactly like Admin overview panels)
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Analytics", style: context.fonts.black18w600),
                  context.verticalSpace(24),
                  const AnalyticsGridWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            // Upcoming Appointments Section (styled with identical border and shadow structures)
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Treatments",
                          style: context.fonts.black18w600,
                        ),
                      ),
                      context.horizontalSpace(20),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentListWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),

            
            BorderdContainerWidget(
              padding: context.appEdgeInsets(all: 24),
              borderRadius: context.r(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AdaptiveLayoutRowColumn(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Treatments Rquest",
                        style: context.fonts.black18w600,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          children: [
                            Text("View All", style: context.fonts.purple14w600),
                            context.horizontalSpace(6),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: CustomColors.purple,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  context.verticalSpace(24),
                  const TreatmentRequestRowWidget(),
                ],
              ),
            ),
            context.verticalSpace(32),
          ],
        ),
      ),
    );
  }
}
