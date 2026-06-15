import '../../utils/enums.dart';
import 'base_response_model.dart';

class AppointmentResponse extends BaseResponse<List<AppointmentData>> {
  int? limit;

  int? page;
  int? totalPages;

  AppointmentResponse({
    super.data,
    required super.status,
    this.limit,
    required super.message,
    this.page,
    this.totalPages,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      status: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => AppointmentData.fromJson(e))
                .toList()
          : null,
      limit: json['limit'],
      page: json['page'],
      totalPages: json['total_pages'],
    );
  }
}

class AppointmentData {
  int? appointmentId;
  String? patientName;
  Clinic? clinic;
  Clinic? doctor;
  int? date;
  int? startTime;
  int? endTime;
  Treatment? treatment;
  List<TreatmentSubsection>? treatmentSubsection;
  int? treatmentTotal;
  PaymentType? paymentType;
  int? discount;
  String? discountType;
  int? loyalityPoints;
  int? actualAmount;
  int? amountPaid;
  int? amountPayable;
  AppointmentStatus? status;

  AppointmentData({
    this.appointmentId,
    this.patientName,
    this.clinic,
    this.doctor,
    this.date,
    this.startTime,
    this.endTime,
    this.treatment,
    this.treatmentSubsection,
    this.treatmentTotal,
    this.paymentType,
    this.discount,
    this.discountType,
    this.loyalityPoints,
    this.actualAmount,
    this.amountPaid,
    this.amountPayable,
    this.status,
  });

  AppointmentData.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointment_id'];
    patientName = json['patient_name'];
    clinic = json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null;
    doctor = json['doctor'] != null ? Clinic.fromJson(json['doctor']) : null;
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    treatment = json['treatment'] != null
        ? Treatment.fromJson(json['treatment'])
        : null;
    if (json['treatment_subsection'] != null) {
      treatmentSubsection = <TreatmentSubsection>[];
      json['treatment_subsection'].forEach((v) {
        treatmentSubsection!.add(TreatmentSubsection.fromJson(v));
      });
    }
    treatmentTotal = json['treatment_total'];
    paymentType = json['payment_type'] != null
        ? PaymentType.fromJson(json['payment_type'])
        : null;
    discount = json['discount'];
    discountType = json['discount_type'];
    loyalityPoints = json['loyality_points'];
    actualAmount = json['actual_amount'];
    amountPaid = json['amount_paid'];
    amountPayable = json['amount_payable'];
    status = AppointmentStatus.fromApi(json['status']);
  }
}

class Clinic {
  int? id;
  String? name;
  String? image;

  Clinic({this.id, this.name, this.image});

  Clinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}

class Treatment {
  String? treatmentName;
  int? treatmentId;
  int? treatmentPrice;
  int? treatmentQuantity;
  String? beforeImage;
  String? afterImage;

  Treatment({
    this.treatmentId,
    this.treatmentName,
    this.treatmentPrice,
    this.treatmentQuantity,
    this.beforeImage,
    this.afterImage,
  });

  Treatment.fromJson(Map<String, dynamic> json) {
    treatmentId = json['treatment_id'];
    treatmentPrice = json['treatment_price'];
    treatmentQuantity = json['treatment_quantity'];
    beforeImage = json['before_image'];
    afterImage = json['after_image'];
    treatmentName = json['treatment_name'];
  }
}

class TreatmentSubsection {
  int? sectionId;
  int? syringesQuantity;
  int? perSyringePrice;

  TreatmentSubsection({
    this.sectionId,
    this.syringesQuantity,
    this.perSyringePrice,
  });

  TreatmentSubsection.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    syringesQuantity = json['syringes_quantity'];
    perSyringePrice = json['per_syringe_price'];
  }
}

class PaymentType {
  int? id;
  String? title;
  int? amount;

  PaymentType({this.id, this.title, this.amount});

  PaymentType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    amount = json['amount'];
  }
}
