import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';
import 'package:skinsync_clinic_portal/utils/color_constant.dart';
import 'package:skinsync_clinic_portal/utils/custom_fonts.dart';
import 'package:skinsync_clinic_portal/widgets/custom_app_bar.dart';

class DynamicPricing extends StatefulWidget {
  static const String routeName = '/dynamic-pricing';

  const DynamicPricing({super.key});

  @override
  State<DynamicPricing> createState() => _DynamicPricingState();
}

class _DynamicPricingState extends State<DynamicPricing> {
  int selectedIndex = 1;

  List<Map<String, dynamic>> campaigns = List.generate(6, (index) {
    return {
      'name': 'Campaign Name',
      'enabled': true,
      'days': null,
      'startTime': TimeOfDay(hour: 10, minute: 0),
      'endTime': TimeOfDay(hour: 22, minute: 0),
      'discount': 20,
      'bogo': false,
    };
  });

  List<String> treatments = ['Facial', 'Laser', 'Peel'];
  String? selectedTreatment;

  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  String? selectedDay;

  TimeOfDay startTime = const TimeOfDay(hour: 10, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);

  bool isBogo = false;
  double discount = 20;

  @override
  void initState() {
    super.initState();
    loadSelectedCampaign();
  }

  void loadSelectedCampaign() {
    final c = campaigns[selectedIndex];
    selectedDay = c['days'];
    startTime = c['startTime'];
    endTime = c['endTime'];
    isBogo = c['bogo'];
    discount = c['discount'].toDouble();
  }

  void saveChanges() {
    setState(() {
      campaigns[selectedIndex]['days'] = selectedDay;
      campaigns[selectedIndex]['startTime'] = startTime;
      campaigns[selectedIndex]['endTime'] = endTime;
      campaigns[selectedIndex]['bogo'] = isBogo;
      campaigns[selectedIndex]['discount'] = discount.toInt();
    });
  }

  Future<void> pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: CustomAppBar(showLogo: true),
      body: Center(
        child: SizedBox(
          width: 0.8.sw,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  IconButton(
                    onPressed: context.pop,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: CustomColors.black,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Text('Dynamic pricing', style: CustomFonts.black20w600),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(SvgAssets.plus),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Divider(
                height: 0,
                color: CustomColors.black.withValues(alpha: 0.1),
              ),
              SizedBox(height: 24.h),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildBody() {
    return Row(
      children: [
        /// LEFT SIDE
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _searchBar(),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: campaigns.length,
                  itemBuilder: (_, index) {
                    final campaign = campaigns[index];
                    final selected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          loadSelectedCampaign();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? CustomColors.purple
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 12.w,
                              ),
                              child: Row(
                                crossAxisAlignment: .start,
                                children: [
                                  Container(
                                    width: 50.w,
                                    height: 50.w,
                                    decoration: BoxDecoration(
                                      color: CustomColors.blue
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(14.r),
                                    ),
                                    child: SvgPicture.asset(
                                      SvgAssets.discount,
                                      width: 28.w,
                                      height: 28.w,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Campaign Name',
                                          style: CustomFonts.black20w600,
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '03 Treatments Included',
                                          style: CustomFonts.grey14w400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: campaign['enabled'],
                                    onChanged: (val) {
                                      setState(() {
                                        campaign['enabled'] = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Divider(height: 32.h),
                            _buildCampaignInfoRow(
                              key: 'Offer Days',
                              value: 'Mon, Wed, Fri',
                            ),
                            _buildCampaignInfoRow(
                              key: 'Schedule Time',
                              value: '10:00 AM  - 10:00 PM',
                            ),
                            _buildCampaignInfoRow(
                              key: 'Discount',
                              value: '20% Off',
                              isImportant: true,
                            ),
                            SizedBox(height: 12.w),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 32.w),

        /// RIGHT SIDE PANEL
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Treatments', style: CustomFonts.black18w600),
                SizedBox(height: 5.h),
                DropdownButtonFormField<String>(
                  initialValue: selectedTreatment,

                  hint: const Text('Select'),
                  items: treatments
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedTreatment = val;
                    });
                  },
                ),

                SizedBox(height: 20.h),

                Text('Days of the Week', style: CustomFonts.black18w600),
                SizedBox(height: 5.h),
                DropdownButtonFormField<String>(
                  initialValue: selectedDay,

                  hint: const Text('Select'),
                  items: weekDays
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDay = val;
                    });
                  },
                ),
                SizedBox(height: 20.h),
                Text('Time Range', style: CustomFonts.black18w600),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickTime(true),
                        child: Text(
                          formatTime(startTime),
                          style: CustomFonts.black16w400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => pickTime(false),
                        child: Text(
                          formatTime(endTime),
                          style: CustomFonts.black16w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buy one get one free',
                      style: CustomFonts.black18w600,
                    ),
                    Switch(
                      value: isBogo,
                      onChanged: (val) {
                        setState(() {
                          isBogo = val;
                        });
                      },
                    ),
                  ],
                ),
                Divider(height: 5.h, thickness: 0.5),
                SizedBox(height: 20.h),
                Text('Discount', style: CustomFonts.black18w600),
                SizedBox(height: 5.h),
                TextFormField(
                  initialValue: discount.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    discount = double.tryParse(val) ?? 0;
                  },
                  decoration: const InputDecoration(
                    suffixText: '%',
                    border: OutlineInputBorder(),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveChanges,
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildCampaignInfoRow({
    required String key,
    required String value,
    bool isImportant = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 5.h),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(key, style: CustomFonts.grey14w400),
          Text(
            value,
            style: isImportant
                ? CustomFonts.black14w600.copyWith(color: Colors.red)
                : CustomFonts.black14w600,
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search Campaign',
        hintStyle: CustomFonts.grey16w400,
        prefixIcon: Icon(Icons.search),
        fillColor: CustomColors.softGrey,
        filled: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
