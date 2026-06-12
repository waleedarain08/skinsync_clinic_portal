import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/appointment_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/inventory_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/payment_and_wallet_screen.dart';
import 'package:skinsync_clinic_portal/screens/dashboard/roles_screen.dart';
import 'package:skinsync_clinic_portal/utils/responsive.dart';

import '../../utils/assets.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_app_bar.dart';
import 'home_screen.dart';
import 'manage_doc_injector_screen.dart';
import 'mange_staff_screen.dart';
import 'patient_management.dart';
import 'profile_screen.dart';
import 'treatment_screen.dart';

class Dashboard extends StatelessWidget {
  static const String routeName = '/dashboard';
  final Widget child;

  const Dashboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteGrey,
      drawer: context.isLandscape ? const SizedBox.shrink() : _buildDrawer(context),
      body: Row(
        children: [
          context.isLandscape ? _buildDrawer(context) : const SizedBox.shrink(),
          Expanded(
            child: Column(
              children: [
                const CustomAppBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          width: context.w(270),
          height: double.infinity,
          padding: EdgeInsets.only(top: context.h(38), bottom: context.h(20)),
          margin: EdgeInsets.all(context.w(10)),
          decoration: BoxDecoration(
            color: CustomColors.lightPurple2,
            borderRadius: BorderRadius.circular(context.r(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(PngAssets.splashLogo, width: context.r(48), height: context.r(48)),
              SizedBox(width: context.w(5)),
              Image.asset(PngAssets.logo, height: context.r(20)),
              SizedBox(height: context.h(20)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildRailItem(
                        context: context,
                        title: 'Home',
                        chipIcon: Iconsax.home_2,
                        routeName: HomeScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Patient Management',
                        chipIcon: Iconsax.profile_2user,
                        routeName: PatientManagementScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Appointments',
                        chipIcon: Iconsax.calendar,
                        routeName: AppointmentScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Treatments',
                        chipIcon: Icons.vaccines_outlined,
                        routeName: TreatmentScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Doctors / Injectors',
                        chipIcon: Icons.masks_outlined,
                        routeName: MangeDoctorsInjectorsScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Inventory',
                        chipIcon: Icons.inventory,
                        routeName: InventoryScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Roles',
                        chipIcon: Icons.person_outline,
                        routeName: RolesScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Staff',
                        chipIcon: Iconsax.user_octagon,
                        routeName: ManageStaffScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Payments & Wallets',
                        chipIcon: Iconsax.wallet_3,
                        routeName: PaymentAndWalletScreen.routeName,
                      ),
                      _buildRailItem(
                        context: context,
                        title: 'Profile',
                        chipIcon: Iconsax.profile_circle,
                        routeName: ProfileScreen.routeName,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRailItem({
    required BuildContext context,
    required String title,
    required IconData chipIcon,
    required String routeName,
  }) {
    final uri = GoRouter.of(context).state.path;
    final isSelected = uri == routeName;
    return ElevatedButton.icon(
      onPressed: () {
        context.go(routeName);
        if (Scaffold.of(context).hasDrawer) {
          Scaffold.of(context).closeDrawer();
        }
      },
      label: Text(
        title,
        style: TextStyle(
          fontSize: context.sp(15),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected
              ? CustomColors.black
              : CustomColors.grey,
        ),
      ),
      icon: Icon(
        chipIcon,
        size: context.r(20),
        color: isSelected ? CustomColors.purple : CustomColors.blue,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        minimumSize: Size(double.infinity, context.h(22)),
        alignment: Alignment.centerLeft,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.all(context.w(15)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(15)),
        ),
      ),
    );
  }
}
