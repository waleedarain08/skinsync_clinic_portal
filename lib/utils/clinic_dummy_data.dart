import '../models/ai_chat_message_model.dart';
import '../models/chat_appointment_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_treatment_request_model.dart';
import '../models/dummy/patient_dummy.dart';
import '../models/responses/treatment_products_response.dart';
import 'enums.dart';

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
  static const List<TreatmentProductData> dummyTreatmentProducts = [
    TreatmentProductData(
      id: 101,
      name: 'Botox Cosmetic 100U',
      brand: 'Allergan',
      globalSku: 'BOTOX-100-ALLERGAN',
      image: '',
      status: 'Active',
    ),
    TreatmentProductData(
      id: 102,
      name: 'Juvederm Ultra XC 1mL',
      brand: 'Allergan',
      globalSku: 'JUVEDERM-ULTRA-XC-1ML',
      image: '',
      status: 'Active',
    ),
    TreatmentProductData(
      id: 103,
      name: 'Restylane Lyft 1mL',
      brand: 'Galderma',
      globalSku: 'RESTYLANE-LYFT-1ML',
      image: '',
      status: 'Active',
    ),
    TreatmentProductData(
      id: 104,
      name: 'Glycolic Acid Peel 30%',
      brand: 'Perfect Derma',
      globalSku: 'PEEL-GLYCOLIC-30',
      image: '',
      status: 'Active',
    ),
    TreatmentProductData(
      id: 105,
      name: 'SkinPen Microneedling Cartridges',
      brand: 'Crown Aesthetics',
      globalSku: 'SKINPEN-CARTRIDGE-12',
      image: '',
      status: 'Active',
    ),
    TreatmentProductData(
      id: 106,
      name: 'Hyaluronic Acid Healing Serum',
      brand: 'SkinCeuticals',
      globalSku: 'SKINC-HA-SERUM-50',
      image: '',
      status: 'Active',
    ),
  ];

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

  static const Map<String, dynamic> dummyAppointmentTreatmentDetail = {
    "treatment_id": 1,
    "treatment_name": "Botox Cosmetic",
    "area_name": "Forehead",
    "status": "Ongoing",
    "current_session": {
      "session_number": 1,
      "date": "2023-10-25",
      "consent_form_url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
      "protocols": [
        "Cleanse and disinfect target area with alcohol swab",
        "Verify patient identity and consent signature",
        "Confirm lack of contraindications"
      ],
      "instructions": "Avoid lying down for 4 hours post-treatment."
    },
    "history": [
      {
        "id": 101,
        "type": "Consultation",
        "date": "2023-09-10",
        "provider": "Dr. Smith",
        "summary": "Patient interested in forehead wrinkle reduction. No contraindications found."
      },
      {
        "id": 102,
        "type": "Session",
        "date": "2023-09-15",
        "provider": "Dr. Smith",
        "summary": "First session completed. 20 units injected in forehead area."
      },
      {
        "id": 103,
        "type": "Follow-Up",
        "date": "2023-09-30",
        "provider": "Dr. Smith",
        "summary": "Check-up after first session. Results are satisfactory. No touch-ups needed."
      }
    ]
  };

  static Map<String, dynamic> getHistoryDetail(int id) {
    if (id == 101) {
      return {
        "id": 101,
        "type": "Consultation",
        "date": "2023-09-10",
        "provider": "Dr. Smith",
        "notes": "Patient discussed expectations and potential side effects. Agreed to proceed with Botox.",
        "vitals": {"bp": "120/80", "weight": "70kg"}
      };
    } else if (id == 102) {
      return {
        "id": 102,
        "type": "Session",
        "date": "2023-09-15",
        "provider": "Dr. Smith",
        "dosage": "20 Units",
        "product": "Botox Cosmetic",
        "batch_number": "BX12345",
        "expiry_date": "2025-12-01"
      };
    } else {
      return {
        "id": 103,
        "type": "Follow-Up",
        "date": "2023-09-30",
        "provider": "Dr. Smith",
        "observations": "Facial symmetry is good. Patient is happy with the results.",
        "next_appointment": "In 3 months"
      };
    }
  }

  static const Map<String, dynamic> dummyFetchedPractitioner = {
    "basic_info": {
      "name": "Dr. John Smith",
      "title": "Dermatologist",
      "image": "https://example.com/photo.jpg",
      "gender": "male",
      "date_of_birth": "1990-01-15",
      "specialization": "Cosmetic Dermatology",
      "years_of_experience": 10,
      "qualifications": ["MBBS", "MD Dermatology", "Fellowship in Cosmetic Surgery"]
    },
    "contact_info": {
      "email": "wal@yopmail.com",
      "phone": "1234567890",
      "cc": "+1",
      "country": "US",
      "emergency_contact": {
        "name": "Jane Smith",
        "phone": "9876543210",
        "cc": "+1",
        "country": "US",
        "relationship": "Spouse"
      }
    },
    "license_info": {
      "license_number": "LIC-2024-12345",
      "license_expiry_date": "2027-12-31",
      "issuing_authority": "State Medical Board",
      "indemnity_insurance_number": "INS-98765",
      "indemnity_expiry_date": "2027-06-30",
      "documents": ["https://example.com/license.pdf", "https://example.com/insurance.pdf"]
    }
  };

  /// Dummy messages list demonstrating all 5 chat types using PatientTreatmentRequestData
  static final List<ChatMessageModel> chatDummyMessages = [
    ChatMessageModel(
      id: '1',
      senderName: 'Jane Cooper',
      time: '10:15 AM',
      isMe: false,
      messageType: ChatMessageType.normal,
      text: 'Hello doctor, I received the simulation results for Option 1.',
    ),
    ChatMessageModel(
      id: '2',
      senderName: 'You',
      time: '10:18 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.normal,
      text:
          'Hi Jane! Great. Have you had a chance to review the before/after comparison?',
    ),
    ChatMessageModel(
      id: '3',
      senderName: 'Jane Cooper',
      time: '10:20 AM',
      isMe: false,
      messageType: ChatMessageType.media,
      text: 'Here is my current progress photo for your review.',
      mediaUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&q=80',
      mediaCaption: 'Pre-treatment Skin Assessment Photo',
    ),
    ChatMessageModel(
      id: '4',
      senderName: 'You',
      time: '10:22 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.document,
      text: 'Here is the detailed PDF outline for your upcoming treatment plan.',
      documentName: 'Facial_Rejuvenation_Option_1.pdf',
      documentSize: '1.4 MB',
    ),
    ChatMessageModel(
      id: '5',
      senderName: 'Jane Cooper',
      time: '10:25 AM',
      isMe: false,
      messageType: ChatMessageType.sharedRequest,
      text: 'I submitted a shared treatment request with before & after simulation.',
      sharedRequestData: dummyTreatmentRequests.isNotEmpty
          ? ChatTreatmentRequestModel.fromPatientTreatmentRequestData(
              dummyTreatmentRequests[0],
            )
          : null,
    ),
    ChatMessageModel(
      id: '6',
      senderName: 'You',
      time: '10:28 AM',
      isMe: true,
      isRead: true,
      messageType: ChatMessageType.appointment,
      text: 'I have scheduled your next follow-up appointment below.',
      appointmentData: ChatAppointmentData(
        appointmentId: 405,
        patientName: 'Jane Cooper',
        serviceName: 'Botox Follow-up & Touch-up Session',
        date: 'Sep 05, 2026',
        time: '10:00 AM',
        practitionerName: 'Dr. Sarah Johnson',
        status: 'Confirmed',
      ),
    ),
  ];

  /// AI Onboarding Dummy Messages list
  static final List<AiChatMessageModel> aiOnboardingDummyMessages = [
    AiChatMessageModel(
      id: 'ai_1',
      senderName: 'SkinSync AI',
      time: '10:00 AM',
      isAi: true,
      isMe: false,
      messageType: AiChatMessageType.optionSelection,
      text:
          'Hello Doctor! Welcome to SkinSync AI Onboarding Assistant. I am here to help you quickly set up your clinic treatments, pricing, and protocols. What would you like to configure first?',
      options: [
        'Create Botox Treatment Template',
        'Configure Dermal Fillers',
        'Set Aftercare Protocols',
        'Setup Allowed Provider Roles',
      ],
    ),
    AiChatMessageModel(
      id: 'user_1',
      senderName: 'You',
      time: '10:01 AM',
      isAi: false,
      isMe: true,
      messageType: AiChatMessageType.text,
      text: 'I want to create a new treatment template for Botox Cosmetic.',
    ),
    AiChatMessageModel(
      id: 'ai_2',
      senderName: 'SkinSync AI',
      time: '10:01 AM',
      isAi: true,
      isMe: false,
      messageType: AiChatMessageType.treatmentDraft,
      text:
          'Excellent! I have generated an automated draft for Botox Anti-Wrinkle Treatment based on clinic standard guidelines. Please review:',
      treatmentDraftData: AiTreatmentDraftData(
        treatmentName: 'Botox Anti-Wrinkle Treatment',
        category: 'Injectables',
        subcategory: 'Neuromodulators',
        price: '\$150.00 / syringe',
        sessions: 1,
        downtime: 'None',
        allowedRoles: 'Injector, MD, Nurse',
      ),
    ),
    AiChatMessageModel(
      id: 'ai_3',
      senderName: 'SkinSync AI',
      time: '10:02 AM',
      isAi: true,
      isMe: false,
      messageType: AiChatMessageType.optionSelection,
      text: 'How would you like to proceed with this treatment configuration?',
      options: [
        'Confirm & Save Template',
        'Customize Pricing Override',
        'Add Post-Care Instructions',
      ],
    ),
    AiChatMessageModel(
      id: 'user_2',
      senderName: 'You',
      time: '10:03 AM',
      isAi: false,
      isMe: true,
      messageType: AiChatMessageType.text,
      text: 'Add Post-Care Instructions and Confirm.',
    ),
    AiChatMessageModel(
      id: 'ai_4',
      senderName: 'SkinSync AI',
      time: '10:03 AM',
      isAi: true,
      isMe: false,
      messageType: AiChatMessageType.text,
      text:
          'Done! Post-care guidelines added: "Stay upright for 4 hours, avoid massaging the treated area, and avoid strenuous exercise for 24 hours." Your Botox treatment template is now active in your clinic portal.',
    ),
  ];
}

final List<ChatMessageModel> chatDummyMessages = ClinicDummyData.chatDummyMessages;
// ignore: non_constant_identifier_names
final List<ChatMessageModel> chat_dummy_messages = ClinicDummyData.chatDummyMessages;

class ClinicDummySessionConfig {
  static final Map<int, Map<String, dynamic>> stepConfigs = {
    1: {
      'title': 'Inventory Products Config',
      'details': [
        'Required Products: Botox Cosmetic (Allergan)',
        'Dosage Range: Min 10 Units, Max 100 Units',
        'Allow Substitution: No',
        'Deduction Timing: On Completion of session',
        'Target Areas: Forehead, Glabella, Crow\'s feet'
      ],
    },
    2: {
      'title': 'Scheduling Config',
      'details': [
        'Calculation Mode: Product Usage (Dynamic calculation)',
        'Base Treatment Duration: 30 minutes',
        'Preparation Time: 10 minutes',
        'Cleanup / Reset Time: 5 minutes',
        'Online Booking Allowed: Yes',
        'Manual Approval Required: No'
      ],
    },
    3: {
      'title': 'Pricing Setup Config',
      'details': [
        'Base Price: \$150.00',
        'Sub-Area Pricing Overrides: Yes',
        'Forehead: \$350.00 per syringe',
        'Glabella: \$400.00 per syringe',
        'Crow\'s Feet: \$300.00 per syringe'
      ],
    },
    4: {
      'title': 'Clinical Protocols Config',
      'details': [
        'Required Checklists:',
        '  - Cleanse and disinfect target area with alcohol swab',
        '  - Verify patient identity and consent signature',
        '  - Confirm lack of contraindications (pregnancy, neuromuscular disorders)',
        'Required Notes / Input Fields:',
        '  - Total injected units per anatomical area',
        '  - Batch number and expiry date of vials used'
      ],
    },
    5: {
      'title': 'Pre-Treatment Instructions Config',
      'details': [
        'Mandatory Patient Warnings:',
        '  - Avoid blood thinners (aspirin, fish oil) for 7 days before.',
        '  - Do not consume alcohol for 24 hours prior.',
        'Attached Informational Documents:',
        '  - Botox_Preparation_Guide_v3.pdf (245 KB)'
      ],
    },
    6: {
      'title': 'Post-Treatment Instructions Config',
      'details': [
        'Mandatory Patient Aftercare:',
        '  - Stay upright and avoid lying down for 4 hours.',
        '  - Do not massage or apply pressure to treated areas.',
        '  - Avoid strenuous exercise and excessive heat for 24 hours.',
        'Attached Guidelines Documents:',
        '  - Botox_Clinical_Aftercare_Instructions.pdf (180 KB)'
      ],
    },
    7: {
      'title': 'Post Treatment Photos Config',
      'details': [
        'Require Post-Treatment Photos: Yes',
        'Minimum Required Photos: 3 angles',
        'Anatomical Angles Mandatory:',
        '  - Frontal View (Neutral & Maximum Frown)',
        '  - Left Lateral View (45 Degrees)',
        '  - Right Lateral View (45 Degrees)'
      ],
    },
    8: {
      'title': 'Phase Notifications Config',
      'details': [
        'Pre-Treatment Notification (24 Hours Before):',
        '  - Title: Preparing for your wrinkle relaxation treatment',
        '  - Message: Avoid aspirin and alcohol. See you tomorrow!',
        'Post-Treatment Notification (4 Hours After):',
        '  - Title: Quick Wrinkle relaxation aftercare checklist',
        '  - Message: Stay upright for 4 hours. No intense workout today!'
      ],
    },
    9: {
      'title': 'Downtime Level Config',
      'details': [
        'Default Downtime Level: None (No booking restrictions)',
        'Anatomical Booking Lockout Duration: 0 days',
        'Override Permission: Clinic manager override allowed'
      ],
    },
    10: {
      'title': 'Allowed Provider Roles Config',
      'details': [
        'Authorized Aesthetic Specialists:',
        '  - Injector (RN / Nurse Practitioner)',
        '  - MD (Medical Doctor / Aesthetic Physician)',
        '  - Nurse (Registered Aesthetic Nurse)'
      ],
    },
    11: {
      'title': 'Follow-Up Configuration Config',
      'details': [
        'Mandatory Follow-Ups: 1 session',
        'Follow-Up #1 Timing: 14 days after procedure',
        'Appointment Type: In-Person (Clinical assessment)',
        'Mandatory Photo Submission: Yes (Check symmetry)',
        'Doctor Instructions: Check Glabella action; touch-up if needed.'
      ],
    },
    12: {
      'title': 'Patient Consent Form Config',
      'details': [
        'Mandatory Informed Consent Document:',
        '  - Botox_Neurotoxin_Informed_Consent_Form.pdf',
        'Digital Signature Required: Yes (Patient must sign via portal)'
      ],
    },
  };
}
