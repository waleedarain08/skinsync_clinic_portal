import 'base_request.dart';

class CreateAppointmentRequest extends BaseRequest {
  final List<AppointmentPractitionerRequest>? practitioners;
  final int? patientId;
  final int? date;
  final int? startTime;
  final int? endTime;
  final int? appointmentTypeId;
  final String? bookingType;
  final AppointmentSimulationsRequest? simulations;
  final List<AppointmentTreatmentItemRequest>? treatment;
  final double? treatmentTotal;
  final AppointmentPaymentTypeRequest? paymentType;
  final String? discountType;
  final double? discount;
  final double? amountPaid;
  final double? payable;

  CreateAppointmentRequest({
    this.practitioners,
    this.patientId,
    this.date,
    this.startTime,
    this.endTime,
    this.appointmentTypeId,
    this.bookingType = 'online',
    this.simulations,
    this.treatment,
    this.treatmentTotal,
    this.paymentType,
    this.discountType = 'flat',
    this.discount = 0,
    this.amountPaid = 0,
    this.payable = 0,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      if (practitioners != null)
        'practitioners': practitioners!.map((e) => e.toJson()).toList(),
      if (patientId != null) 'patient_id': patientId,
      if (date != null) 'date': date,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (appointmentTypeId != null)
        'appointment_type_id': appointmentTypeId,
      if (bookingType != null) 'booking_type': bookingType,
      if (simulations != null) 'simulations': simulations!.toJson(),
      if (treatment != null)
        'treatment': treatment!.map((e) => e.toJson()).toList(),
      if (treatmentTotal != null) 'treatment_total': treatmentTotal,
      if (paymentType != null) 'payment_type': paymentType!.toJson(),
      if (discountType != null) 'discount_type': discountType,
      if (discount != null) 'discount': discount,
      if (amountPaid != null) 'ammount_paid': amountPaid,
      if (payable != null) 'payable': payable,
    };
  }

  factory CreateAppointmentRequest.fromJson(Map<String, dynamic> json) {
    return CreateAppointmentRequest(
      practitioners: json['practitioners'] != null
          ? (json['practitioners'] as List)
              .map((e) => AppointmentPractitionerRequest.fromJson(e))
              .toList()
          : null,
      patientId: json['patient_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      appointmentTypeId: json['appointment_type_id'],
      bookingType: json['booking_type'],
      simulations: json['simulations'] != null
          ? AppointmentSimulationsRequest.fromJson(json['simulations'])
          : null,
      treatment: json['treatment'] != null
          ? (json['treatment'] as List)
              .map((e) => AppointmentTreatmentItemRequest.fromJson(e))
              .toList()
          : null,
      treatmentTotal: json['treatment_total']?.toDouble(),
      paymentType: json['payment_type'] != null
          ? AppointmentPaymentTypeRequest.fromJson(json['payment_type'])
          : null,
      discountType: json['discount_type'],
      discount: json['discount']?.toDouble(),
      amountPaid: json['ammount_paid']?.toDouble(),
      payable: json['payable']?.toDouble(),
    );
  }
}

class AppointmentPractitionerRequest {
  final int? id;
  final String? role;

  AppointmentPractitionerRequest({
    this.id,
    this.role = 'doctor',
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (role != null) 'role': role,
      };

  factory AppointmentPractitionerRequest.fromJson(
      Map<String, dynamic> json) {
    return AppointmentPractitionerRequest(
      id: json['id'],
      role: json['role'],
    );
  }
}

class AppointmentSimulationsRequest {
  final String? frontImageBefore;
  final String? frontImageAfter;
  final String? rightImageBefore;
  final String? rightImageAfter;
  final String? leftImageBefore;
  final String? leftImageAfter;

  AppointmentSimulationsRequest({
    this.frontImageBefore = '',
    this.frontImageAfter = '',
    this.rightImageBefore = '',
    this.rightImageAfter = '',
    this.leftImageBefore = '',
    this.leftImageAfter = '',
  });

  Map<String, dynamic> toJson() => {
        'front_image_before': frontImageBefore ?? '',
        'front_image_after': frontImageAfter ?? '',
        'right_image_before': rightImageBefore ?? '',
        'right_image_after': rightImageAfter ?? '',
        'left_image_before': leftImageBefore ?? '',
        'left_image_after': leftImageAfter ?? '',
      };

  factory AppointmentSimulationsRequest.fromJson(
      Map<String, dynamic> json) {
    return AppointmentSimulationsRequest(
      frontImageBefore: json['front_image_before'],
      frontImageAfter: json['front_image_after'],
      rightImageBefore: json['right_image_before'],
      rightImageAfter: json['right_image_after'],
      leftImageBefore: json['left_image_before'],
      leftImageAfter: json['left_image_after'],
    );
  }
}

class AppointmentTreatmentItemRequest {
  final int? treatmentId;
  final int? areaId;
  final double? treatmentCost;
  final AppointmentMaterialItemRequest? material;

  AppointmentTreatmentItemRequest({
    this.treatmentId,
    this.areaId,
    this.treatmentCost,
    this.material,
  });

  Map<String, dynamic> toJson() => {
        if (treatmentId != null) 'treatment_id': treatmentId,
        if (areaId != null) 'area_id': areaId,
        if (treatmentCost != null) 'treatment_cost': treatmentCost,
        if (material != null) 'material': material!.toJson(),
      };

  factory AppointmentTreatmentItemRequest.fromJson(
      Map<String, dynamic> json) {
    return AppointmentTreatmentItemRequest(
      treatmentId: json['treatment_id'],
      areaId: json['area_id'],
      treatmentCost: json['treatment_cost']?.toDouble(),
      material: json['material'] != null
          ? AppointmentMaterialItemRequest.fromJson(json['material'])
          : null,
    );
  }
}

class AppointmentMaterialItemRequest {
  final int? id;
  final int? selectedQuantity;

  AppointmentMaterialItemRequest({
    this.id,
    this.selectedQuantity,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (selectedQuantity != null)
          'selected_quantity': selectedQuantity,
      };

  factory AppointmentMaterialItemRequest.fromJson(
      Map<String, dynamic> json) {
    return AppointmentMaterialItemRequest(
      id: json['id'],
      selectedQuantity: json['selected_quantity'],
    );
  }
}

class AppointmentPaymentTypeRequest {
  final String? type;
  final String? status;

  AppointmentPaymentTypeRequest({
    this.type = 'cash',
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() => {
        if (type != null) 'type': type,
        if (status != null) 'status': status,
      };

  factory AppointmentPaymentTypeRequest.fromJson(
      Map<String, dynamic> json) {
    return AppointmentPaymentTypeRequest(
      type: json['type'],
      status: json['status'],
    );
  }
}
