
import '../requests/create_session_requests/protocol_request.dart';
import 'base_response_model.dart';

class SessionDetailResponse
    extends BaseApiResponseModel<SessionDetailDto> {
  SessionDetailResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory SessionDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionDetailResponse(
      data: json['data'] != null
          ? SessionDetailDto.fromJson(
              Map<String, dynamic>.from(json['data']),
            )
          : null,
      success: json['is_success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}

class SessionDetailDto {
  final int id;
  final int treatmentId;
  final int areaId;
  final String areaName;
  final String title;
  final int sessionNumber;
  final String status;
  final bool isCompleted;
  final int currentStep;
  final List<SessionProductUsageDto> productUsages;

  final int baseDuration;
  final int prepTime;
  final int cleanupTime;

  final List<SessionProductDurationDto> productDurations;

  final bool allowClinicOverride;
  final bool allowProviderOverride;
  final bool onlineBookable;
  final bool manualApprovalRequired;
  final int minimumBookingNotice;
  final int maximumDaysInAdvance;
  final int calculatedTotalDuration;

  final bool isFixedDuration;
  final int fixedDuration;

  final double basePrice;
  final bool isFixedPrice;
  final double fixedPrice;

  final List<SessionUnitPriceOverrideDto> unitPriceOverrides;

  final SessionAttachmentDto? clinicalProtocolPdf;

  final String preTreatmentInstructions;
  final List<SessionAttachmentDto> preTreatmentAttachments;

  final String postTreatmentInstructions;
  final List<SessionAttachmentDto> postTreatmentAttachments;

  final bool requirePostTreatmentPhotos;
  final List<PhotoMilestoneDto> photoMilestone;

  final List<SessionNotificationDto> preNotifications;
  final List<SessionNotificationDto> postNotifications;

  final String downtimeLevel;
  final int downtimeDays;
  final List<DowntimeLevelDto> downtimeLevels;

  final List<String> allowedRoles;
  final List<String> inventoryProductsRoles;
  final List<String> schedulingRoles;
  final List<String> pricingRoles;

  final bool isDiffPrice;

  final List<SessionFollowUpDto> followUps;

  final SessionAttachmentDto? preTreatmentConsentForm;

  final List<ProtocolRequestItem> protocols;
  final List<ProtocolInstructionItem> instructions;

  // Materials
  final int? selectedUnitTypeId;
  final String? selectedUnitTypeName;
  final double? minimumUnits;
  final double? maximumUnits;
  final List<int> otherMaterials;

  SessionDetailDto({
    required this.id,
    required this.treatmentId,
    required this.areaId,
    required this.areaName,
    required this.title,
    required this.sessionNumber,
    required this.status,
    required this.isCompleted,
    required this.productUsages,
    required this.baseDuration,
    required this.prepTime,
    required this.cleanupTime,
    required this.productDurations,
    required this.allowClinicOverride,
    required this.allowProviderOverride,
    required this.onlineBookable,
    required this.manualApprovalRequired,
    required this.minimumBookingNotice,
    required this.maximumDaysInAdvance,
    required this.calculatedTotalDuration,
    required this.isFixedDuration,
    required this.fixedDuration,
    required this.basePrice,
    required this.isFixedPrice,
    required this.fixedPrice,
    required this.unitPriceOverrides,
    this.clinicalProtocolPdf,
    required this.preTreatmentInstructions,
    required this.preTreatmentAttachments,
    required this.postTreatmentInstructions,
    required this.postTreatmentAttachments,
    required this.requirePostTreatmentPhotos,
    required this.photoMilestone,
    required this.preNotifications,
    required this.postNotifications,
    required this.downtimeLevel,
    required this.downtimeDays,
    this.downtimeLevels = const [],
    required this.allowedRoles,
    this.inventoryProductsRoles = const [],
    this.schedulingRoles = const [],
    this.pricingRoles = const [],
    this.isDiffPrice = false,
    required this.followUps,
    this.preTreatmentConsentForm,
    this.protocols = const [],
    this.instructions = const [],
    this.selectedUnitTypeId,
    this.selectedUnitTypeName,
    this.minimumUnits,
    this.maximumUnits,
    required this.currentStep,
    required this.otherMaterials,
  });

  factory SessionDetailDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionDetailDto(
      id: json['id'] as int? ?? 0,
       currentStep: json['current_step'] as int? ?? 1,
      // API returns clinic_treatment_id
      treatmentId:
          json['clinic_treatment_id'] as int? ?? 0,

      areaId:
          json['area_id'] as int? ?? 0,

      areaName:
          json['area_name'] as String? ?? '',

      title:
          json['title'] as String? ?? '',

      sessionNumber:
          json['session_number'] as int? ?? 1,

      status:
          json['status'] as String? ?? 'Active',

      isCompleted:
          json['is_completed'] as bool? ?? false,

      // Billable Materials
      productUsages:
          (json['billable_materials'] as List?)
                  ?.map(
                    (e) => SessionProductUsageDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      baseDuration:
          json['base_duration'] as int? ?? 0,

      prepTime:
          json['prep_time'] as int? ?? 0,

      cleanupTime:
          json['cleanup_time'] as int? ?? 0,

      productDurations:
          (json['product_durations'] as List?)
                  ?.map(
                    (e) => SessionProductDurationDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      allowClinicOverride:
          json['allow_clinic_override'] as bool? ?? false,

      allowProviderOverride:
          json['allow_provider_override'] as bool? ?? false,

      onlineBookable:
          json['online_bookable'] as bool? ?? false,

      manualApprovalRequired:
          json['manual_approval_required'] as bool? ?? false,

      minimumBookingNotice:
          json['minimum_booking_notice'] as int? ?? 0,

      maximumDaysInAdvance:
          json['maximum_days_in_advance'] as int? ?? 0,

      calculatedTotalDuration:
          json['calculated_total_duration'] as int? ?? 0,

      isFixedDuration:
          json['is_fixed_duration'] as bool? ?? false,

      fixedDuration:
          json['fixed_duration'] as int? ?? 0,

      basePrice:
          (json['base_price'] as num?)?.toDouble() ?? 0.0,

      isFixedPrice:
          json['is_fixed_price'] as bool? ?? false,

      fixedPrice:
          (json['fixed_price'] as num?)?.toDouble() ?? 0.0,

      unitPriceOverrides:
          (json['unit_price_overrides'] as List?)
                  ?.map(
                    (e) => SessionUnitPriceOverrideDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      // Clinical Protocol PDF
      clinicalProtocolPdf:
          json['clinical_protocol_pdf'] != null
              ? SessionAttachmentDto.fromJson(
                  Map<String, dynamic>.from(
                    json['clinical_protocol_pdf'],
                  ),
                )
              : null,

      preTreatmentInstructions:
          json['pre_treatment_instructions'] as String? ?? '',

      preTreatmentAttachments:
          (json['pre_treatment_attachments'] as List?)
                  ?.map(
                    (e) => SessionAttachmentDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      postTreatmentInstructions:
          json['post_treatment_instructions'] as String? ?? '',

      postTreatmentAttachments:
          (json['post_treatment_attachments'] as List?)
                  ?.map(
                    (e) => SessionAttachmentDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      requirePostTreatmentPhotos:
          json['require_post_treatment_photos'] as bool? ?? false,

      photoMilestone:
          (json['photo_milestone'] as List?)
                  ?.map(
                    (e) => PhotoMilestoneDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      preNotifications:
          (json['pre_notifications'] as List?)
                  ?.map(
                    (e) => SessionNotificationDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      postNotifications:
          (json['post_notifications'] as List?)
                  ?.map(
                    (e) => SessionNotificationDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      downtimeLevel:
          json['downtime_level'] as String? ?? 'none',

      downtimeDays:
          json['downtime_days'] as int? ?? 0,

      downtimeLevels:
          (json['downtime_levels'] as List?)
                  ?.map(
                    (e) => DowntimeLevelDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      allowedRoles:
          (json['allowed_roles'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],

      inventoryProductsRoles:
          (json['inventory_products_roles'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],

      schedulingRoles:
          (json['scheduling_roles'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],

      pricingRoles:
          (json['pricing_roles'] as List?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],

      isDiffPrice:
          json['is_diff_price'] as bool? ?? false,

      followUps:
          (json['follow_ups'] as List?)
                  ?.map(
                    (e) => SessionFollowUpDto.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      preTreatmentConsentForm:
          json['pre_treatment_consent_form'] != null
              ? SessionAttachmentDto.fromJson(
                  Map<String, dynamic>.from(
                    json['pre_treatment_consent_form'],
                  ),
                )
              : null,

      protocols:
          (json['protocols'] as List?)
                  ?.map(
                    (e) => ProtocolRequestItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      instructions:
          (json['instructions'] as List?)
                  ?.map(
                    (e) => ProtocolInstructionItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList() ??
              [],

      selectedUnitTypeId:
          json['selected_unit_type_id'] as int?,

      selectedUnitTypeName:
          json['selected_unit_type_name'] as String?,

      minimumUnits:
          (json['minimum_units'] as num?)?.toDouble(),

      maximumUnits:
          (json['maximum_units'] as num?)?.toDouble(),

      otherMaterials:
          (json['other_materials'] as List?)
                  ?.map((e) {
                    if (e is int) {
                      return e;
                    }

                    if (e is num) {
                      return e.toInt();
                    }

                    if (e is Map) {
                      final value =
                          e['product_id'] ?? e['id'];

                      if (value is num) {
                        return value.toInt();
                      }
                    }

                    return 0;
                  })
                  .where((e) => e != 0)
                  .toList() ??
              [],
    );
  }
}

class SessionProductUsageDto {
  final int productId;
  final String productName;
  final String productImage;
  final String productSku;
  final String deductionTiming;
  final bool allowSubstitution;
  final String notes;
  final double minQuantity;
  final double maxQuantity;

  SessionProductUsageDto({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.productSku,
    required this.deductionTiming,
    required this.allowSubstitution,
    required this.notes,
    required this.minQuantity,
    required this.maxQuantity,
  });

  factory SessionProductUsageDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionProductUsageDto(
      productId:
          json['product_id'] as int? ?? 0,
      productName:
          json['product_name'] as String? ?? '',
      productImage:
          json['product_image'] as String? ?? '',
      productSku:
          json['product_sku'] as String? ?? '',
      deductionTiming:
          json['deduction_timing'] as String? ?? 'before',
      allowSubstitution:
          json['allow_substitution'] as bool? ?? false,
      notes:
          json['notes'] as String? ?? '',
      minQuantity:
          (json['min_quantity'] as num?)?.toDouble() ?? 0.0,
      maxQuantity:
          (json['max_quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SessionProductDurationDto {
  final int productId;
  final String productName;
  final double perUnitDuration;

  SessionProductDurationDto({
    required this.productId,
    required this.productName,
    required this.perUnitDuration,
  });

  factory SessionProductDurationDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionProductDurationDto(
      productId:
          json['product_id'] as int? ?? 0,
      productName:
          json['product_name'] as String? ?? '',
      perUnitDuration:
          (json['per_unit_duration'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SessionUnitPriceOverrideDto {
  final int productId;
  final String productName;
  final double pricePerUnit;
  final List<int> pricePerUnitList;

  SessionUnitPriceOverrideDto({
    required this.productId,
    required this.productName,
    required this.pricePerUnit,
    required this.pricePerUnitList,
  });

  factory SessionUnitPriceOverrideDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionUnitPriceOverrideDto(
      productId:
          json['product_id'] as int? ?? 0,
      productName:
          json['product_name'] as String? ?? '',
      pricePerUnit:
          (json['price_per_unit'] as num?)?.toDouble() ?? 0.0,
      pricePerUnitList:
          (json['price_per_unit_list'] as List?)
                  ?.map((e) {
                    if (e is num) {
                      return e.toInt();
                    }
                    return 0;
                  })
                  .where((e) => e != 0)
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price_per_unit': pricePerUnit,
      'price_per_unit_list': pricePerUnitList,
    };
  }
}

class SessionAttachmentDto {
  final String name;
  final String url;
  final String? type;

  SessionAttachmentDto({
    required this.name,
    required this.url,
    this.type,
  });

  factory SessionAttachmentDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionAttachmentDto(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
      type: json['type'] as String?,
    );
  }
}

class SessionNotificationDto {
  final String title;
  final String message;
  final int timing;
  final String timingUnit;
  final String type;

  SessionNotificationDto({
    required this.title,
    required this.message,
    required this.timing,
    required this.timingUnit,
    required this.type,
  });

  factory SessionNotificationDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionNotificationDto(
      title:
          json['title'] as String? ?? '',
      message:
          json['message'] as String? ?? '',
      timing:
          json['timing'] as int? ?? 0,
      timingUnit:
          json['timing_unit'] as String? ?? 'days',
      type:
          json['type'] as String? ?? 'sms',
    );
  }
}

class PhotoMilestoneDto {
  final int numberOfDays;
  final int requiredPhotos;

  PhotoMilestoneDto({
    required this.numberOfDays,
    required this.requiredPhotos,
  });

  factory PhotoMilestoneDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return PhotoMilestoneDto(
      numberOfDays:
          json['number_of_days'] as int? ?? 0,
      requiredPhotos:
          json['required_photos'] as int? ?? 0,
    );
  }
}

class DowntimeLevelDto {
  final String level;
  final int days;

  DowntimeLevelDto({
    required this.level,
    required this.days,
  });

  factory DowntimeLevelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DowntimeLevelDto(
      level:
          json['level'] as String? ?? '',
      days:
          json['days'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'days': days,
    };
  }
}

class SessionFollowUpDto {
  final String type;
  final String durationUnit;
  final int durationValue;
  final String notes;
  final int intervalValue;
  final String intervalUnit;
  final bool isImageRequired;

  SessionFollowUpDto({
    required this.type,
    required this.durationUnit,
    required this.durationValue,
    required this.notes,
    required this.intervalValue,
    required this.intervalUnit,
    required this.isImageRequired,
  });

  factory SessionFollowUpDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return SessionFollowUpDto(
      type:
          json['type'] as String? ?? '',
      durationUnit:
          json['duration_unit'] as String? ?? '',
      durationValue:
          json['duration_value'] as int? ?? 0,
      notes:
          json['notes'] as String? ?? '',
      intervalValue:
          json['interval_value'] as int? ?? 0,
      intervalUnit:
          json['interval_unit'] as String? ?? '',
      isImageRequired:
          json['is_image_required'] as bool? ?? false,
    );
  }
}
