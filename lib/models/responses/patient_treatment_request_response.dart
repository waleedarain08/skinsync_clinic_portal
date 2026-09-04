import 'base_response_model.dart';

class PatientTreatmentRequestResponse
    extends BaseResponse<List<PatientTreatmentRequestData>> {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  PatientTreatmentRequestResponse({
    required super.success,
    required super.message,
    super.data,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory PatientTreatmentRequestResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentRequestResponse(
      success: json['is_success'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentRequestData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'is_success': success,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'page': page,
        'limit': limit,
        'total': total,
        'total_pages': totalPages,
      };
}

class PatientTreatmentRequestData {
  final int id;
  final int userId;
  final int groupId;
  final String name;

  // Patient information
  final String? patientName;
  final String? patientImage;
  final String? patientEmail;

  final String? frontImageBefore;
  final String? frontImageAfter;

  final String? rightImageBefore;
  final String? rightImageAfter;

  final String? leftImageBefore;
  final String? leftImageAfter;

  final List<PatientTreatmentData> treatments;

  final String? createdAt;
  final String? updatedAt;

  // Additional fields from response
  final dynamic referenceId;
  final List<PreferredSlotData>? preferredSlots;
  final PatientMedicalHistoryData? medicalHistory;

  PatientTreatmentRequestData({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    this.patientName,
    this.patientImage,
    this.patientEmail,
    this.frontImageBefore,
    this.frontImageAfter,
    this.rightImageBefore,
    this.rightImageAfter,
    this.leftImageBefore,
    this.leftImageAfter,
    required this.treatments,
    this.createdAt,
    this.updatedAt,
    this.referenceId,
    this.preferredSlots,
    this.medicalHistory,
  });

  factory PatientTreatmentRequestData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentRequestData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      groupId: json['group_id'] ?? 0,
      name: json['name'] ?? '',

      // Patient information
      patientName: json['patient_name'],
      patientImage: json['patient_image'],
      patientEmail: json['patient_email'],

      frontImageBefore: json['front_image_before'],
      frontImageAfter: json['front_image_after'],
      rightImageBefore: json['right_image_before'],
      rightImageAfter: json['right_image_after'],
      leftImageBefore: json['left_image_before'],
      leftImageAfter: json['left_image_after'],

      treatments:
          (json['treatments'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],

      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      referenceId: json['reference_id'],
      preferredSlots: json['preferred_slots'] != null
          ? (json['preferred_slots'] as List<dynamic>)
              .map((e) => PreferredSlotData.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      medicalHistory: json['medical_history'] != null
          ? PatientMedicalHistoryData.fromJson(
              json['medical_history'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'group_id': groupId,
        'name': name,
        'patient_name': patientName,
        'patient_image': patientImage,
        'patient_email': patientEmail,
        'front_image_before': frontImageBefore,
        'front_image_after': frontImageAfter,
        'right_image_before': rightImageBefore,
        'right_image_after': rightImageAfter,
        'left_image_before': leftImageBefore,
        'left_image_after': leftImageAfter,
        'treatments': treatments.map((e) => e.toJson()).toList(),
        'created_at': createdAt,
        'updated_at': updatedAt,
        'reference_id': referenceId,
        'preferred_slots': preferredSlots?.map((e) => e.toJson()).toList(),
        'medical_history': medicalHistory?.toJson(),
      };
}

class PreferredSlotData {
  final String? date;
  final String? time;

  PreferredSlotData({
    this.date,
    this.time,
  });

  factory PreferredSlotData.fromJson(Map<String, dynamic> json) =>
      PreferredSlotData(
        date: json['date'],
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'time': time,
      };
}

class PatientMedicalHistoryData {
  final int? id;
  final int? patientId;
  final List<String> allergies;
  final List<String> medicalConditions;
  final List<String> currentMedications;
  final String? createdAt;
  final String? updatedAt;

  PatientMedicalHistoryData({
    this.id,
    this.patientId,
    this.allergies = const [],
    this.medicalConditions = const [],
    this.currentMedications = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory PatientMedicalHistoryData.fromJson(Map<String, dynamic> json) {
    return PatientMedicalHistoryData(
      id: json['id'],
      patientId: json['patient_id'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : [],
      medicalConditions: json['medical_conditions'] != null
          ? List<String>.from(json['medical_conditions'])
          : [],
      currentMedications: json['current_medications'] != null
          ? List<String>.from(json['current_medications'])
          : [],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'allergies': allergies,
        'medical_conditions': medicalConditions,
        'current_medications': currentMedications,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class PatientTreatmentData {
  final int treatmentId;
  final String treatmentName;
  final String? description;
  final String? image;
  final String? icon;
  final List<PatientTreatmentAreaData> areas;

  PatientTreatmentData({
    required this.treatmentId,
    required this.treatmentName,
    this.description,
    this.image,
    this.icon,
    required this.areas,
  });

  factory PatientTreatmentData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentData(
      treatmentId: json['treatment_id'] ?? 0,
      treatmentName: json['treatment_name'] ?? '',
      description: json['treatment_desc'],
      image: json['treatment_image'],
      icon: json['treatment_icon'],
      areas:
          (json['areas'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentAreaData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'treatment_id': treatmentId,
        'treatment_name': treatmentName,
        'treatment_desc': description,
        'treatment_image': image,
        'treatment_icon': icon,
        'areas': areas.map((e) => e.toJson()).toList(),
      };
}

class PatientTreatmentAreaData {
  final int areaId;
  final String areaName;
  final String? image;
  final String? icon;
  final double? price;
  final List<PatientTreatmentMaterialData> materials;

  PatientTreatmentAreaData({
    required this.areaId,
    required this.areaName,
    this.image,
    this.icon,
    this.price,
    required this.materials,
  });

  factory PatientTreatmentAreaData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentAreaData(
      areaId: json['area_id'] ?? 0,
      areaName: json['area_name'] ?? '',
      image: json['area_image'],
      icon: json['area_icon'],
      price: (json['price'] as num?)?.toDouble(),
      materials:
          (json['materials'] as List<dynamic>?)
              ?.map(
                (e) => PatientTreatmentMaterialData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'area_id': areaId,
        'area_name': areaName,
        'area_image': image,
        'area_icon': icon,
        'price': price,
        'materials': materials.map((e) => e.toJson()).toList(),
      };
}

class PatientTreatmentMaterialData {
  final int id;
  final String name;
  final int selectedQuantity;

  PatientTreatmentMaterialData({
    required this.id,
    required this.name,
    required this.selectedQuantity,
  });

  factory PatientTreatmentMaterialData.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientTreatmentMaterialData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      selectedQuantity: json['selected_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'selected_quantity': selectedQuantity,
      };
}
