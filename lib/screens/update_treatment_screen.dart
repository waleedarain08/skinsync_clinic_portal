import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/custom_fonts.dart';
import '../widgets/header__with_back_btn.dart';

class UpdateTreatmentScreen extends StatefulWidget {
  const UpdateTreatmentScreen({super.key});
  static const String routeName = '/update-treatment';

  @override
  State<UpdateTreatmentScreen> createState() => _UpdateTreatmentScreenState();
}

class _UpdateTreatmentScreenState extends State<UpdateTreatmentScreen> {
  List<TreatmentModel> treatments = [
    TreatmentModel(
      image:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=200',
      name: 'Treatment Name',
      originalPrice: 800,
      currentPrice: 650,
      isActive: true,
    ),
    TreatmentModel(
      image:
          'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=200',
      name: 'Treatment Name',
      originalPrice: 800,
      currentPrice: 650,
      isActive: true,
    ),
    TreatmentModel(
      image:
          'https://images.unsplash.com/photo-1519824145371-296894a0daa9?w=200',
      name: 'Treatment Name',
      originalPrice: 800,
      currentPrice: 650,
      isActive: true,
    ),
    TreatmentModel(
      image:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
      name: 'Treatment Name',
      originalPrice: 800,
      currentPrice: 650,
      isActive: true,
    ),
    TreatmentModel(
      image:
          'https://images.unsplash.com/photo-1616394584738-fc6e612e71b9?w=200',
      name: 'Treatment Name',
      originalPrice: 800,
      currentPrice: 650,
      isActive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFBDBDBD),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 250.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              BuildHeader(title: "Update Treatment"),

              SizedBox(height: 24.h),

              // Treatment List
              Expanded(
                child: SizedBox(
                  width: 399.w,
                  child: ListView.separated(
                    itemCount: treatments.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 24.h,
                      thickness: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      return _buildTreatmentItem(treatments[index], index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentItem(TreatmentModel treatment, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Treatment Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            treatment.image,
            width: 90.w,
            height: 150.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 90.w,
                height: 70.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.image,
                  color: Colors.grey.shade400,
                  size: 30.sp,
                ),
              );
            },
          ),
        ),

        SizedBox(width: 12.w),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(treatment.name, style: CustomFonts.black18w600),

              SizedBox(height: 4.h),

              // Price
              Row(
                children: [
                  Text(
                    '\$${treatment.originalPrice}',
                    style: CustomFonts.grey14w400.copyWith(decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '\$ ${treatment.currentPrice}',
                    style: CustomFonts.black14w500,
                  ),
                ],
              ),

              SizedBox(height: 38.h),

              // Edit Button
              GestureDetector(
                onTap: () {
                  // TODO: Edit treatment
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4081),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text('Edit', style: CustomFonts.black12w600),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Toggle Switch
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: treatment.isActive,
            onChanged: (value) {
              setState(() {
                treatments[index].isActive = value;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF4DD0E1),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class TreatmentModel {
  final String image;
  final String name;
  final int originalPrice;
  final int currentPrice;
  bool isActive;

  TreatmentModel({
    required this.image,
    required this.name,
    required this.originalPrice,
    required this.currentPrice,
    required this.isActive,
  });
}
