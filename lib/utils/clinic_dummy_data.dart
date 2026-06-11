class ClinicDummyProduct {
  final String id;
  final String name;
  final String uom; // Unit, Syringe, Vial, Kit, Tube, Box, etc.

  const ClinicDummyProduct({
    required this.id,
    required this.name,
    required this.uom,
  });
}

class ClinicDummyProductUsage {
  final ClinicDummyProduct product;
  final String usageType; // Required, Optional, Variable
  final String deductionTiming; // On Completion, Manual
  final bool allowSubstitution;
  final double minQty;
  final double maxQty;
  final List<String> targetAreas; // Forehead, Cheeks, Full Face, etc.

  ClinicDummyProductUsage({
    required this.product,
    required this.usageType,
    required this.deductionTiming,
    required this.allowSubstitution,
    required this.minQty,
    required this.maxQty,
    required this.targetAreas,
  });

  ClinicDummyProductUsage copyWith({
    ClinicDummyProduct? product,
    String? usageType,
    String? deductionTiming,
    bool? allowSubstitution,
    double? minQty,
    double? maxQty,
    List<String>? targetAreas,
  }) {
    return ClinicDummyProductUsage(
      product: product ?? this.product,
      usageType: usageType ?? this.usageType,
      deductionTiming: deductionTiming ?? this.deductionTiming,
      allowSubstitution: allowSubstitution ?? this.allowSubstitution,
      minQty: minQty ?? this.minQty,
      maxQty: maxQty ?? this.maxQty,
      targetAreas: targetAreas ?? this.targetAreas,
    );
  }
}

class ClinicDummyFollowUp {
  final String appointmentType; // In-Person, Virtual, Follow-Up
  final int intervalValue;
  final String intervalUnit; // Days, Weeks
  final bool isImageUploadMandatory;
  final String clinicalInstructions;

  ClinicDummyFollowUp({
    required this.appointmentType,
    required this.intervalValue,
    required this.intervalUnit,
    required this.isImageUploadMandatory,
    required this.clinicalInstructions,
  });

  ClinicDummyFollowUp copyWith({
    String? appointmentType,
    int? intervalValue,
    String? intervalUnit,
    bool? isImageUploadMandatory,
    String? clinicalInstructions,
  }) {
    return ClinicDummyFollowUp(
      appointmentType: appointmentType ?? this.appointmentType,
      intervalValue: intervalValue ?? this.intervalValue,
      intervalUnit: intervalUnit ?? this.intervalUnit,
      isImageUploadMandatory: isImageUploadMandatory ?? this.isImageUploadMandatory,
      clinicalInstructions: clinicalInstructions ?? this.clinicalInstructions,
    );
  }
}

class ClinicDummySession {
  final int number;
  final List<ClinicDummyFollowUp> followUps;

  ClinicDummySession({
    required this.number,
    required this.followUps,
  });

  ClinicDummySession copyWith({
    int? number,
    List<ClinicDummyFollowUp>? followUps,
  }) {
    return ClinicDummySession(
      number: number ?? this.number,
      followUps: followUps ?? this.followUps,
    );
  }
}

class ClinicDummyTreatmentTemplate {
  final String id;
  final String name;
  final String patientDisplayName;
  final String category;
  final String subcategory;
  final String sku;
  final String description;
  final String status;
  final List<ClinicDummySession> sessions;
  final String consentFormName;
  final String preTreatmentNotificationTitle;
  final String preTreatmentNotificationMessage;
  final String preTreatmentNotificationTiming; // "24 Hours Before", "2 Days Before", etc.
  final String postTreatmentNotificationTitle;
  final String postTreatmentNotificationMessage;
  final String postTreatmentNotificationTiming; // "4 Hours After", "24 Hours After", "2 Days After", etc.
  final String downtimeLevel;
  final List<String> allowedRoles;
  final List<ClinicDummyProductUsage> products;
  final double basePrice;

  ClinicDummyTreatmentTemplate({
    required this.id,
    required this.name,
    required this.patientDisplayName,
    required this.category,
    required this.subcategory,
    required this.sku,
    required this.description,
    required this.status,
    required this.sessions,
    required this.consentFormName,
    required this.preTreatmentNotificationTitle,
    required this.preTreatmentNotificationMessage,
    required this.preTreatmentNotificationTiming,
    required this.postTreatmentNotificationTitle,
    required this.postTreatmentNotificationMessage,
    required this.postTreatmentNotificationTiming,
    required this.downtimeLevel,
    required this.allowedRoles,
    required this.products,
    required this.basePrice,
  });

  ClinicDummyTreatmentTemplate copyWith({
    String? id,
    String? name,
    String? patientDisplayName,
    String? category,
    String? subcategory,
    String? sku,
    String? description,
    String? status,
    List<ClinicDummySession>? sessions,
    String? consentFormName,
    String? preTreatmentNotificationTitle,
    String? preTreatmentNotificationMessage,
    String? preTreatmentNotificationTiming,
    String? postTreatmentNotificationTitle,
    String? postTreatmentNotificationMessage,
    String? postTreatmentNotificationTiming,
    String? downtimeLevel,
    List<String>? allowedRoles,
    List<ClinicDummyProductUsage>? products,
    double? basePrice,
  }) {
    return ClinicDummyTreatmentTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      patientDisplayName: patientDisplayName ?? this.patientDisplayName,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      consentFormName: consentFormName ?? this.consentFormName,
      preTreatmentNotificationTitle: preTreatmentNotificationTitle ?? this.preTreatmentNotificationTitle,
      preTreatmentNotificationMessage: preTreatmentNotificationMessage ?? this.preTreatmentNotificationMessage,
      preTreatmentNotificationTiming: preTreatmentNotificationTiming ?? this.preTreatmentNotificationTiming,
      postTreatmentNotificationTitle: postTreatmentNotificationTitle ?? this.postTreatmentNotificationTitle,
      postTreatmentNotificationMessage: postTreatmentNotificationMessage ?? this.postTreatmentNotificationMessage,
      postTreatmentNotificationTiming: postTreatmentNotificationTiming ?? this.postTreatmentNotificationTiming,
      downtimeLevel: downtimeLevel ?? this.downtimeLevel,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      products: products ?? this.products,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}

class ClinicDummyData {
  static const List<String> categories = [
    'Injectables',
    'Skin Treatments',
    'Laser & Energy',
    'Body Contouring',
  ];

  static const Map<String, List<String>> subcategories = {
    'Injectables': ['Neuromodulators', 'Dermal Fillers', 'Skinboosters', 'Kybella'],
    'Skin Treatments': ['Chemical Peels', 'Microneedling', 'Facials', 'Microdermabrasion'],
    'Laser & Energy': ['IPL Photofacial', 'Fractional Laser', 'Laser Hair Removal', 'Radiofrequency'],
    'Body Contouring': ['CoolSculpting', 'Emsculpt', 'Cellulite Treatment'],
  };

  static const List<String> providerRoles = [
    'Injector',
    'MD',
    'Aesthetician',
    'Nurse',
    'Specialist',
  ];

  static const List<String> downtimeLevels = [
    'None',
    'Low',
    'Moderate',
    'High',
  ];

  static const List<String> appointmentTypes = [
    'In-Person',
    'Virtual',
    'Follow-Up',
  ];

  static const List<ClinicDummyProduct> inventoryProducts = [
    ClinicDummyProduct(id: 'prod-botox', name: 'Botox Cosmetic (Allergan)', uom: 'Unit'),
    ClinicDummyProduct(id: 'prod-dysport', name: 'Dysport (Galderma)', uom: 'Unit'),
    ClinicDummyProduct(id: 'prod-juve-voluma', name: 'Juvederm Voluma XC (1ml)', uom: 'Syringe'),
    ClinicDummyProduct(id: 'prod-juve-ultra', name: 'Juvederm Ultra Plus XC', uom: 'Syringe'),
    ClinicDummyProduct(id: 'prod-restylane-lyft', name: 'Restylane Lyft (1ml)', uom: 'Syringe'),
    ClinicDummyProduct(id: 'prod-sculptra', name: 'Sculptra Aesthetic (Vial)', uom: 'Vial'),
    ClinicDummyProduct(id: 'prod-derma-peel-kit', name: 'Perfect Derma Peel Kit', uom: 'Kit'),
    ClinicDummyProduct(id: 'prod-vi-peel-kit', name: 'VI Peel Purify Kit', uom: 'Kit'),
    ClinicDummyProduct(id: 'prod-soothing-ointment', name: 'Post-Treatment Healing Gel (Ounce)', uom: 'Tube'),
    ClinicDummyProduct(id: 'prod-collagen-booster', name: 'SkinCeuticals C E Ferulic', uom: 'Vial'),
  ];

  static final List<ClinicDummyTreatmentTemplate> templates = [
    ClinicDummyTreatmentTemplate(
      id: 'temp-botox',
      name: 'Botox Cosmetic',
      patientDisplayName: 'Botox Anti-Wrinkle Treatment',
      category: 'Injectables',
      subcategory: 'Neuromodulators',
      sku: 'SKU-BOTOX-101',
      description: 'Precision aesthetic injectable treatment targeting moderate to severe frown lines, forehead creases, and crow’s feet.',
      status: 'Active',
      sessions: [
        ClinicDummySession(
          number: 1,
          followUps: [
            ClinicDummyFollowUp(
              appointmentType: 'In-Person',
              intervalValue: 2,
              intervalUnit: 'Weeks',
              isImageUploadMandatory: true,
              clinicalInstructions: 'Check for facial symmetry and touch up if active lines persist.',
            ),
          ],
        ),
      ],
      consentFormName: 'Botox_Clinical_Consent_Form.pdf',
      preTreatmentNotificationTitle: 'Preparing for your Botox treatment',
      preTreatmentNotificationMessage: 'Please avoid aspirin, alcohol, and NSAIDs for 24 hours prior.',
      preTreatmentNotificationTiming: '24 Hours Before',
      postTreatmentNotificationTitle: 'Botox Aftercare Guide',
      postTreatmentNotificationMessage: 'Avoid lying down for 4 hours, and do not massage the treated area.',
      postTreatmentNotificationTiming: '4 Hours After',
      downtimeLevel: 'None',
      allowedRoles: ['Injector', 'MD', 'Nurse'],
      products: [
        ClinicDummyProductUsage(
          product: inventoryProducts[0], // Botox Cosmetic
          usageType: 'Variable',
          deductionTiming: 'On Completion',
          allowSubstitution: false,
          minQty: 10,
          maxQty: 100,
          targetAreas: ['Forehead', 'Crow\'s Feet', 'Glabella'],
        ),
      ],
      basePrice: 150.00,
    ),
    ClinicDummyTreatmentTemplate(
      id: 'temp-juve-cheek',
      name: 'Juvederm Cheek Volumizer',
      patientDisplayName: 'Juvederm Cheek Voluma Filler',
      category: 'Injectables',
      subcategory: 'Dermal Fillers',
      sku: 'SKU-JUVE-202',
      description: 'Injectable gel designed for deep injection in the cheek area to correct age-related volume loss in adults.',
      status: 'Active',
      sessions: [
        ClinicDummySession(
          number: 1,
          followUps: [
            ClinicDummyFollowUp(
              appointmentType: 'Virtual',
              intervalValue: 4,
              intervalUnit: 'Weeks',
              isImageUploadMandatory: true,
              clinicalInstructions: 'Inspect for redness or asymmetric swelling.',
            ),
          ],
        ),
      ],
      consentFormName: 'Juvederm_Dermal_Filler_Consent.pdf',
      preTreatmentNotificationTitle: 'Preparing for Juvederm Dermal Filler',
      preTreatmentNotificationMessage: 'Avoid strenuous exercise and blood thinners 24 hours prior.',
      preTreatmentNotificationTiming: '24 Hours Before',
      postTreatmentNotificationTitle: 'Juvederm Filler Aftercare',
      postTreatmentNotificationMessage: 'Apply cold compress to minimize swelling; do not apply firm pressure.',
      postTreatmentNotificationTiming: '24 Hours After',
      downtimeLevel: 'Low',
      allowedRoles: ['Injector', 'MD'],
      products: [
        ClinicDummyProductUsage(
          product: inventoryProducts[2], // Juvederm Voluma XC
          usageType: 'Variable',
          deductionTiming: 'On Completion',
          allowSubstitution: true,
          minQty: 1,
          maxQty: 4,
          targetAreas: ['Cheeks', 'Mid-Face'],
        ),
      ],
      basePrice: 650.00,
    ),
    ClinicDummyTreatmentTemplate(
      id: 'temp-perfect-peel',
      name: 'Perfect Derma Peel',
      patientDisplayName: 'The Perfect Derma Chemical Peel',
      category: 'Skin Treatments',
      subcategory: 'Chemical Peels',
      sku: 'SKU-PEEL-303',
      description: 'Medium depth medical-grade chemical peel containing TCA, retinoic acid, salicylic acid, kojic acid, and glutathione.',
      status: 'Active',
      sessions: [
        ClinicDummySession(
          number: 1,
          followUps: [
            ClinicDummyFollowUp(
              appointmentType: 'Virtual',
              intervalValue: 1,
              intervalUnit: 'Weeks',
              isImageUploadMandatory: false,
              clinicalInstructions: 'Evaluate skin peeling progress.',
            ),
          ],
        ),
        ClinicDummySession(
          number: 2,
          followUps: [
            ClinicDummyFollowUp(
              appointmentType: 'Virtual',
              intervalValue: 1,
              intervalUnit: 'Weeks',
              isImageUploadMandatory: false,
              clinicalInstructions: 'Evaluate final peel result and recovery status.',
            ),
          ],
        ),
      ],
      consentFormName: 'Chemical_Peel_Consent_Form.pdf',
      preTreatmentNotificationTitle: 'Pre-Peel Preparation Guide',
      preTreatmentNotificationMessage: 'Stop using topical retinoids 3 days before treatment.',
      preTreatmentNotificationTiming: '2 Days Before',
      postTreatmentNotificationTitle: 'Derma Peel Aftercare Steps',
      postTreatmentNotificationMessage: 'Do not pick or pull peeling skin. Apply mineral sunscreen SPF 30+ daily.',
      postTreatmentNotificationTiming: '24 Hours After',
      downtimeLevel: 'Moderate',
      allowedRoles: ['Aesthetician', 'Specialist', 'Nurse'],
      products: [
        ClinicDummyProductUsage(
          product: inventoryProducts[6], // Perfect Derma Peel Kit
          usageType: 'Required',
          deductionTiming: 'On Completion',
          allowSubstitution: false,
          minQty: 1,
          maxQty: 1,
          targetAreas: ['Full Face'],
        ),
        ClinicDummyProductUsage(
          product: inventoryProducts[8], // Healing Gel
          usageType: 'Optional',
          deductionTiming: 'Manual',
          allowSubstitution: true,
          minQty: 1,
          maxQty: 2,
          targetAreas: ['Full Face'],
        ),
      ],
      basePrice: 300.00,
    ),
  ];
}
