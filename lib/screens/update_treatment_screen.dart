import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/custom_primary_button.dart';
import '../widgets/gradient_scaffold.dart';

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
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(250),
            vertical: context.h(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const BuildHeader(title: "Update Treatment"),

              SizedBox(height: context.h(24)),

              // Treatment List
              Expanded(
                child: SizedBox(
                  width: context.w(399),
                  child: ListView.separated(
                    itemCount: treatments.length,
                    separatorBuilder: (context, index) => Divider(
                      height: context.h(24),
                      thickness: 1,
                      color: CustomColors.border,
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
          borderRadius: BorderRadius.circular(context.r(8)),
          child: Image.network(
            treatment.image,
            width: context.w(90),
            height: context.h(150),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: context.w(90),
                height: context.h(70),
                decoration: BoxDecoration(
                  color: CustomColors.softGrey,
                  borderRadius: BorderRadius.circular(context.r(8)),
                ),
                child: Icon(
                  Icons.image,
                  color: CustomColors.grey,
                  size: context.r(30),
                ),
              );
            },
          ),
        ),

        SizedBox(width: context.w(12)),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(treatment.name, style: context.fonts.black18w600),

              SizedBox(height: context.h(4)),

              // Price
              Row(
                children: [
                  Text(
                    'AED ${treatment.originalPrice}',
                    style: context.fonts.grey14w400.copyWith(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: context.w(6)),
                  Text(
                    'AED ${treatment.currentPrice}',
                    style: context.fonts.black14w500,
                  ),
                ],
              ),

              SizedBox(height: context.h(38)),

              // Edit Button
              CustomPrimaryButton(
                onTap: () {
                  // TODO: Edit treatment
                },
                label: 'Edit',
                icon: Icons.edit_outlined,
                height: context.h(32),
                width: context.w(80),
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
            activeThumbColor: CustomColors.white,
            activeTrackColor: const Color(0xFF4DD0E1),
            inactiveThumbColor: CustomColors.white,
            inactiveTrackColor: CustomColors.border,
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
