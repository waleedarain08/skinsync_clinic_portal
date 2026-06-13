import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_clinic_portal/utils/assets.dart';
import 'package:skinsync_clinic_portal/utils/theme.dart';
import 'package:skinsync_clinic_portal/widgets/custom_app_bar.dart';
import 'package:skinsync_clinic_portal/widgets/custom_outlined_button.dart';
import 'package:skinsync_clinic_portal/widgets/custom_primary_button.dart';
import 'package:skinsync_clinic_portal/widgets/gradient_scaffold.dart';

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
      'startTime': const TimeOfDay(hour: 10, minute: 0),
      'endTime': const TimeOfDay(hour: 22, minute: 0),
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
    return GradientScaffold(
      appBar: const CustomAppBar(showLogo: true),
      body: Center(
        child: SizedBox(
          width: context.screenWidth * 0.8,
          child: Column(
            children: [
              SizedBox(height: context.h(20)),
              Row(
                children: [
                  IconButton(
                    onPressed: context.pop,
                    icon: Icon(
                      Icons.arrow_back,
                      size: context.r(24),
                      color: CustomColors.black,
                    ),
                  ),
                  SizedBox(width: context.w(15)),
                  Text('Dynamic pricing', style: context.fonts.black20w600),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(SvgAssets.plus),
                  ),
                ],
              ),
              SizedBox(height: context.h(15)),
              Divider(
                height: 0,
                color: CustomColors.black.withValues(alpha: 0.1),
              ),
              SizedBox(height: context.h(24)),
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
              SizedBox(height: context.h(16)),
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
                        margin: EdgeInsets.only(bottom: context.h(16)),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(context.r(16)),
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
                                left: context.w(12),
                                right: context.w(12),
                                top: context.w(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: context.w(50),
                                    height: context.w(50),
                                    decoration: BoxDecoration(
                                      color: CustomColors.blue
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(context.r(14)),
                                    ),
                                    child: SvgPicture.asset(
                                      SvgAssets.discount,
                                      width: context.w(28),
                                      height: context.w(28),
                                    ),
                                  ),
                                  SizedBox(width: context.w(16)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Campaign Name',
                                          style: context.fonts.black20w600,
                                        ),
                                        SizedBox(height: context.h(4)),
                                        Text(
                                          '03 Treatments Included',
                                          style: context.fonts.grey14w400,
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
                            Divider(height: context.h(32)),
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
                            SizedBox(height: context.w(12)),
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

        SizedBox(width: context.w(32)),

        /// RIGHT SIDE PANEL
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: context.h(10)),
            padding: EdgeInsets.symmetric(horizontal: context.w(24), vertical: context.h(12)),
            decoration: BoxDecoration(
              color: CustomColors.white,
              borderRadius: BorderRadius.circular(context.r(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Treatments', style: context.fonts.black18w600),
                SizedBox(height: context.h(5)),
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

                SizedBox(height: context.h(20)),

                Text('Days of the Week', style: context.fonts.black18w600),
                SizedBox(height: context.h(5)),
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
                SizedBox(height: context.h(20)),
                Text('Time Range', style: context.fonts.black18w600),
                SizedBox(height: context.h(5)),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        onTap: () => pickTime(true),
                        label: formatTime(startTime),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CustomOutlinedButton(
                        onTap: () => pickTime(false),
                        label: formatTime(endTime),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buy one get one free',
                      style: context.fonts.black18w600,
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
                Divider(height: context.h(5), thickness: 0.5),
                SizedBox(height: context.h(20)),
                Text('Discount', style: context.fonts.black18w600),
                SizedBox(height: context.h(5)),
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

                CustomPrimaryButton(
                  onTap: saveChanges,
                  label: 'Save Changes',
                  width: double.infinity,
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
      padding: EdgeInsets.only(left: context.w(12), right: context.w(12), top: context.h(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: context.fonts.grey14w400),
          Text(
            value,
            style: isImportant
                ? context.fonts.black14w600.copyWith(color: CustomColors.red)
                : context.fonts.black14w600,
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search Campaign',
        hintStyle: context.fonts.grey16w400,
        prefixIcon: const Icon(Icons.search),
        fillColor: CustomColors.softGrey,
        filled: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
