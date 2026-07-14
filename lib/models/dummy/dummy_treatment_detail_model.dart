
import 'package:flutter/material.dart';

import '../../view_models/session_view_model.dart';
import '../responses/session_model.dart';
import '../responses/treatment_detail_response.dart';

final dummyTreatment = TreatmentDetailDto(
  id: 1,
  currentStep: 4,
  status: "Active",
  globalSku: "TRT-1001",
  patientDisplayName: "Hydra Facial",
  image: "",
  icon: "",
  shortDescription: "Professional skin rejuvenation treatment.",
  description:
      "Hydra Facial deeply cleanses, exfoliates and hydrates the skin. It is suitable for all skin types.",
  enableByDefault: true,
  useInAiSimulator: true,
  createdAt: DateTime(2025, 1, 5),
  updatedAt: DateTime(2025, 6, 10),
  selectedCategories: [
    TreatmentCategoryDetailDto(
      id: 1,
      name: "Facial",
      status: "Active",
    ),
    TreatmentCategoryDetailDto(
      id: 2,
      name: "Skin Care",
      status: "Active",
    ),
  ],
  areas: [
    TreatmentAreaDto(
      areaId: 1,
      areaName: "Face",
      sessions: [
        SessionModel(
          id: 1,
          treatmentId: 1,
          areaId: 1,
          areaName: "Face",
          title: "Consultation & Cleansing",
          sessionNumber: 1,
          status: "Active",
         
          isCompleted: true,
          createdAt: "2025-01-01",
        ),
        SessionModel(
          id: 2,
          treatmentId: 1,
          areaId: 1,
          areaName: "Face",
          title: "Hydration Session",
          sessionNumber: 2,
          status: "Draft",
         
          isCompleted: true,
          createdAt: "2025-01-02",
        ),
      ],
    ),
    TreatmentAreaDto(
      areaId: 2,
      areaName: "Neck",
      sessions: [
        SessionModel(
          id: 3,
          treatmentId: 1,
          areaId: 2,
          areaName: "Neck",
          title: "Neck Tightening",
          sessionNumber: 1,
          status: "Active",
          
          isCompleted: true,
          createdAt: "2025-01-03",
        ),
      ],
    ),
  ],
);
final dummySessionEntry = SessionViewModelEntry(
  sessionId: 1,
  sessionNumber: 1,
  title: "Consultation & Cleansing",
  status: "Active",
  isDetailedEntered: true,

  durationSnapshot: "45 Minutes",
  priceSnapshot: "\$120",

 productUsageSnapshot: [
  ProductUsageEntry(
    productId: 1,
    productName: "Hydrating Serum",
    unit: "ml",
    usageType: "Required",
    deductionTiming: "On_Completion",
    allowSubstitution: false,
    minQuantityController: TextEditingController(text: "2"),
    maxQuantityController: TextEditingController(text: "5"),
    notesController: TextEditingController(
      text: "Apply evenly on the treated area.",
    ),
    perUnitDurationController: TextEditingController(text: "10"),
    packageType: "Bottle",
    boxQuantity: 1,
    clinicCost: 25.0,
    retailPricePerUnit: 40.0,
    useDifferentPricingPerUnit: false,
  ),

  ProductUsageEntry(
    productId: 2,
    productName: "Cooling Gel",
    unit: "g",
    usageType: "Optional",
    deductionTiming: "Before_Start",
    allowSubstitution: true,
    minQuantityController: TextEditingController(text: "5"),
    maxQuantityController: TextEditingController(text: "10"),
    notesController: TextEditingController(
      text: "Use if patient experiences sensitivity.",
    ),
    perUnitDurationController: TextEditingController(text: "5"),
    packageType: "Tube",
    boxQuantity: 1,
    clinicCost: 15.0,
    retailPricePerUnit: 25.0,
    useDifferentPricingPerUnit: true,
    unitPriceControllers: [
      TextEditingController(text: "25"),
      TextEditingController(text: "45"),
      TextEditingController(text: "60"),
    ],
  ),
],

  followUps: [
  FollowUpEntry(
    type: "virtual",
    durationUnit: "minutes",
    durationValueController: TextEditingController(text: "30"),
    intervalUnit: "days",
    intervalValueController: TextEditingController(text: "7"),
    notesController: TextEditingController(
      text: "Review healing progress via video consultation.",
    ),
    isImageRequired: true,
  ),

  FollowUpEntry(
    type: "in_person",
    durationUnit: "minutes",
    durationValueController: TextEditingController(text: "45"),
    intervalUnit: "weeks",
    intervalValueController: TextEditingController(text: "4"),
    notesController: TextEditingController(
      text: "Perform skin assessment and plan the next session.",
    ),
    isImageRequired: false,
  ),
],

  preInstructionsSnapshot: "Avoid makeup before treatment.",
  postInstructionsSnapshot: "Use SPF 50 sunscreen for 48 hours.",
  downtimeSnapshot: "Low",
  consentSnapshot: "Hydra Facial Consent",
  rolesSnapshot: ["Doctor", "Nurse"],
  preNotificationsSnapshot: [
    "24 hours before appointment",
    "1 hour before appointment",
  ],
  postNotificationsSnapshot: [
    "After treatment",
    "Next day reminder",
  ],
);
