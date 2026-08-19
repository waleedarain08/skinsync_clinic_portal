import 'responses/clinic_model.dart';

class UserModel {
  int? id;
  int? clinicId;
  String? email;
  String? name;
  String? role;
  String? status;
  String? logo;
  Clinic? clinic;

  UserModel({
    this.id,
    this.clinicId,
    this.email,
    this.name,
    this.role,
    this.status,
    this.logo,
    this.clinic,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clinicId = json['clinic_id'];
    email = json['email'];
    name = json['name'];
    role = json['role'];
    status = json['status'];
    logo = json['logo'];
    // clinic = json['clinic'] != null ? Clinic.fromJson(json['clinic']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clinic_id': clinicId,
      'email': email,
      'name': name,
      'role': role,
      'status': status,
      // 'clinic': clinic?.toJson(),
    };
  }

  UserModel copyWith({
    int? id,
    int? clinicId,
    String? email,
    String? name,
    String? role,
    String? status,
    Clinic? clinic,
  }) {
    return UserModel(
      id: id ?? this.id,
      clinicId: clinicId ?? this.clinicId,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      clinic: clinic ?? this.clinic,
    );
  }
}
