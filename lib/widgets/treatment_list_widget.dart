import 'package:flutter/material.dart';
import '../models/treatment_model.dart';
import '../utils/responsive.dart';
import '../utils/assets.dart';
import '../utils/theme.dart';
import 'treatment_container.dart';

class TreatmentListWidget extends StatelessWidget {
  const TreatmentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TreatmentModel> treatments = [
  TreatmentModel(
    id: 1,
    name: 'Botox Treatment',
    description: 'Botox treatment for reducing fine lines and wrinkles.',
    shortDescription: 'Reduce fine lines and wrinkles.',
    globalSku: 'BOT-001',
    icon: PngAssets.treatmentImage,
    image: PngAssets.treatmentImage,
    status: 'active',
    isArea: true,
    price: 240,
    sideAreas: [
      SideAreaModel(
        id: 101,
        name: 'Forehead',
        perSyringePrice: 120.0,
        maxSyringe: 2,
      ),
      SideAreaModel(
        id: 102,
        name: 'Crow Feet',
        perSyringePrice: 120.0,
        maxSyringe: 2,
      ),
    ],
  ),
  TreatmentModel(
    id: 2,
    name: 'Laser Treatment',
    description: 'Advanced laser treatment for skin rejuvenation.',
    shortDescription: 'Rejuvenate and refresh your skin.',
    globalSku: 'LAS-002',
    icon: PngAssets.treatmentImage,
    image: PngAssets.treatmentImage,
    status: 'active',
    isArea: false,
    price: 240,
    sideAreas: [],
  ),
  TreatmentModel(
    id: 3,
    name: 'Chemical Peels',
    description: 'Chemical peel treatment to improve skin texture and appearance.',
    shortDescription: 'Improve skin texture and tone.',
    globalSku: 'PEE-003',
    icon: PngAssets.treatmentImage,
    image: PngAssets.treatmentImage,
    status: 'active',
    isArea: true,
    price: 240,
    sideAreas: [
      SideAreaModel(
        id: 301,
        name: 'Face',
        perSyringePrice: 80.0,
        maxSyringe: 3,
      ),
    ],
  ),
  TreatmentModel(
    id: 4,
    name: 'Dermal Fillers',
    description: 'Dermal filler treatment for restoring facial volume.',
    shortDescription: 'Restore volume and enhance facial contours.',
    globalSku: 'FIL-004',
    icon: PngAssets.treatmentImage,
    image: PngAssets.treatmentImage,
    status: 'active',
    isArea: true,
    price: 350,
    sideAreas: [
      SideAreaModel(
        id: 401,
        name: 'Lips',
        perSyringePrice: 175.0,
        maxSyringe: 2,
      ),
      SideAreaModel(
        id: 402,
        name: 'Cheeks',
        perSyringePrice: 175.0,
        maxSyringe: 2,
      ),
    ],
  ),
  TreatmentModel(
    id: 5,
    name: 'Microneedling',
    description: 'Microneedling treatment to improve skin texture and reduce scars.',
    shortDescription: 'Improve skin texture and reduce scars.',
    globalSku: 'MIC-005',
    icon: PngAssets.treatmentImage,
    image: PngAssets.treatmentImage,
    status: 'active',
    isArea: false,
    price: 180,
    sideAreas: [],
  ),
];
   return AdaptiveLayoutList(
      isScrollVertical: false,
      horizontalHeight: context.r(268),
      spaceWidth: context.w(20),
      spaceHeight: context.h(20),
      children: List.generate(treatments.length, (index) {
        return  TreatmentContainer(
          treatments: treatments[index],
          // title: appointments[index]['title']!,
          // date: appointments[index]['date']!,
          // price: appointments[index]['price']!,
          // image: appointments[index]['image']!,
        );
      }),
    );
  }
}
