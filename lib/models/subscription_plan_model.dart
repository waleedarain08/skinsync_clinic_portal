class ClinicSubscriptionPlanModel {
  String? id;
  String? name;
  double? basePrice;
  int doctorSeats;
  bool unlimitedDoctors;
  int staffSeats;
  bool unlimitedStaff;
  double standardBookingCommissionPercent;
  double dynamicBookingCommissionPercent;
  double technologyFeePerTreatment;
  List<PlanBenefit>? benefits;
  List<String>? assignedClinics;
  bool isActive;
  bool isDefault;
  bool isLifetime;
  List<DurationOption>? durationOptions;

  ClinicSubscriptionPlanModel({
    this.id,
    this.name,
    this.basePrice,
    this.doctorSeats = 0,
    this.unlimitedDoctors = false,
    this.staffSeats = 0,
    this.unlimitedStaff = false,
    this.standardBookingCommissionPercent = 0.0,
    this.dynamicBookingCommissionPercent = 0.0,
    this.technologyFeePerTreatment = 0.0,
    this.benefits,
    this.assignedClinics,
    this.isActive = true,
    this.isDefault = false,
    this.isLifetime = false,
    this.durationOptions,
  });

  factory ClinicSubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return ClinicSubscriptionPlanModel(
      id: json['id']?.toString(),
      name: json['name'],
      basePrice: (json['base_price'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble(),
      doctorSeats: json['doctor_seats'] ?? 0,
      unlimitedDoctors: json['unlimited_doctors'] ?? json['unlimited_doctor'] ?? false,
      staffSeats: json['staff_seats'] ?? 0,
      unlimitedStaff: json['unlimited_staff'] ?? false,
      standardBookingCommissionPercent:
          (json['standard_booking_commission_percent'] as num?)?.toDouble() ??
              0.0,
      dynamicBookingCommissionPercent:
          (json['dynamic_booking_commission_percent'] as num?)?.toDouble() ??
              0.0,
      technologyFeePerTreatment:
          (json['technology_fee_per_treatment'] as num?)?.toDouble() ?? 0.0,
      isActive: (json['is_active'] as bool?) ?? true,
      isDefault: json['is_default'] ?? false,
      isLifetime: json['is_lifetime'] ?? false,
      benefits: json['benefits'] != null
          ? (json['benefits'] as List)
              .map((e) => PlanBenefit.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      assignedClinics: json['assigned_clinics'] != null
          ? List<String>.from(json['assigned_clinics'] as Iterable)
          : null,
      durationOptions: json['duration_options'] != null
          ? (json['duration_options'] as List)
              .map((e) => DurationOption.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_price': basePrice,
      'doctor_seats': doctorSeats,
      'unlimited_doctors': unlimitedDoctors,
      'staff_seats': staffSeats,
      'unlimited_staff': unlimitedStaff,
      'standard_booking_commission_percent': standardBookingCommissionPercent,
      'dynamic_booking_commission_percent': dynamicBookingCommissionPercent,
      'technology_fee_per_treatment': technologyFeePerTreatment,
      'is_active': isActive,
      'is_default': isDefault,
      'is_lifetime': isLifetime,
      'benefits': benefits?.map((e) => e.toJson()).toList(),
      'assigned_clinics': assignedClinics,
      'duration_options': durationOptions?.map((e) => e.toJson()).toList(),
    };
  }
}

class DurationOption {
  String? id;
  String? interval;
  double? amount;

  DurationOption({this.id, this.interval, this.amount});

  factory DurationOption.fromJson(Map<String, dynamic> json) {
    return DurationOption(
      id: json['id']?.toString(),
      interval: json['interval'],
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'interval': interval,
      'amount': amount,
    };
  }
}

class PlanBenefit {
  dynamic id;
  String? sku;
  String? title;
  String? description;
  int? freeMonths;
  bool enabled;

  PlanBenefit({this.id, this.sku, this.title, this.description, this.freeMonths, this.enabled = true});

  factory PlanBenefit.fromJson(Map<String, dynamic> json) {
    return PlanBenefit(
      id: json['id'],
      sku: json['sku'],
      title: json['title'],
      description: json['description'],
      freeMonths: json['free_months'],
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'title': title,
      'description': description,
      'free_months': freeMonths,
      'enabled': enabled,
    };
  }
}

class ClinicCurrentPlanDetails {
  String? id;
  int? clinicId;
  String? planId;
  String? name;
  int doctorSeats;
  bool unlimitedDoctor;
  int staffSeats;
  bool unlimitedStaff;
  double standardBookingCommissionPercent;
  double dynamicBookingCommissionPercent;
  double technologyFeePerTreatment;
  bool isActive;
  bool isDefault;
  String? startDate;
  String? endDate;
  String? durationId;
  String? durationName;
  double? price;
  String? createdAt;
  String? updatedAt;

  ClinicCurrentPlanDetails({
    this.id,
    this.clinicId,
    this.planId,
    this.name,
    this.doctorSeats = 0,
    this.unlimitedDoctor = false,
    this.staffSeats = 0,
    this.unlimitedStaff = false,
    this.standardBookingCommissionPercent = 0.0,
    this.dynamicBookingCommissionPercent = 0.0,
    this.technologyFeePerTreatment = 0.0,
    this.isActive = false,
    this.isDefault = false,
    this.startDate,
    this.endDate,
    this.durationId,
    this.durationName,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ClinicCurrentPlanDetails.fromJson(Map<String, dynamic> json) {
    return ClinicCurrentPlanDetails(
      id: json['id']?.toString(),
      clinicId: json['clinic_id'],
      planId: json['plan_id']?.toString(),
      name: json['name'],
      doctorSeats: json['doctor_seats'] ?? 0,
      unlimitedDoctor: json['unlimited_doctor'] ?? false,
      staffSeats: json['staff_seats'] ?? 0,
      unlimitedStaff: json['unlimited_staff'] ?? false,
      standardBookingCommissionPercent: (json['standard_booking_commission_percent'] as num?)?.toDouble() ?? 0.0,
      dynamicBookingCommissionPercent: (json['dynamic_booking_commission_percent'] as num?)?.toDouble() ?? 0.0,
      technologyFeePerTreatment: (json['technology_fee_per_treatment'] as num?)?.toDouble() ?? 0.0,
      isActive: json['is_active'] ?? false,
      isDefault: json['is_default'] ?? false,
      startDate: json['start_date'],
      endDate: json['end_date'],
      durationId: json['duration_id']?.toString(),
      durationName: json['duration_name'],
      price: (json['price'] as num?)?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ClinicCurrentPlanData {
  ClinicCurrentPlanDetails? currentPlan;
  List<ClinicSubscriptionPlanModel>? plans;

  ClinicCurrentPlanData({this.currentPlan, this.plans});

  factory ClinicCurrentPlanData.fromJson(Map<String, dynamic> json) {
    return ClinicCurrentPlanData(
      currentPlan: json['current_plan'] != null
          ? ClinicCurrentPlanDetails.fromJson(json['current_plan'] as Map<String, dynamic>)
          : null,
      plans: json['plans'] != null
          ? (json['plans'] as List)
              .map((e) => ClinicSubscriptionPlanModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class SubscribeResponseData {
  String? cancelUrl;
  String? stripeUrl;
  String? successUrl;

  SubscribeResponseData({this.cancelUrl, this.stripeUrl, this.successUrl});

  factory SubscribeResponseData.fromJson(Map<String, dynamic> json) {
    return SubscribeResponseData(
      cancelUrl: json['cancel_url'],
      stripeUrl: json['stripe_url'],
      successUrl: json['success_url'],
    );
  }
}
