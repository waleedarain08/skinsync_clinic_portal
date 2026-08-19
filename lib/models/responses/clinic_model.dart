import '../requests/base_request.dart';

class Clinic extends BaseRequest {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? logo;
  String? status;
  String? cc;
  String? country;
  String? banner;
  String? ownerName;
  String? ownerEmail;
  num? consultationFee;
  num? initialDeposit;
  String? description;
  String? website;
  double? latitude;
  double? longitude;
  List<AvailabilityModel>? availability;

  Clinic({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.logo,
    this.status,
    this.cc,
    this.country,
    this.banner,
    this.ownerName,
    this.ownerEmail,
    this.consultationFee,
    this.initialDeposit,
    this.description,
    this.website,
    this.latitude,
    this.longitude,
    this.availability,
  });

  Clinic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['clinic_name'] ?? json['name'];
    email = json['clinic_email'] ?? json['email'];
    phone = json['clinic_phone'] ?? json['phone'];
    address = json['clinic_address'] ?? json['address'];
    logo = json['clinic_logo'] ?? json['logo'];
    status = json['status'];
    cc = json['cc'];
    country = json['country'];
    banner = json['banner'];
    ownerName = json['owner_name'];
    ownerEmail = json['owner_email'];
    consultationFee = json['consultation_fee'];
    initialDeposit = json['initial_deposit'];
    description = json['description'];
    website = json['website'];
    latitude = (json['clinic_latitude'] as num?)?.toDouble();
    longitude = (json['clinic_longitude'] as num?)?.toDouble();
    if (json['availability'] != null) {
      availability = <AvailabilityModel>[];
      json['availability'].forEach((v) {
        availability!.add(AvailabilityModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'clinic_name': name,
      'clinic_phone': phone,
      'clinic_address': address,
      'clinic_logo': logo,
      'clinic_latitude': latitude,
      'clinic_longitude': longitude,
      'consultation_fee': consultationFee,
      'initial_deposit': initialDeposit,
      'description': description,
      'website': website,
      'banner': banner,
      'cc': cc,
      'country': country,
      'availability': availability?.map((v) => v.toJson()).toList() ?? [],
    };
  }

  Clinic copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? logo,
    String? status,
    String? cc,
    String? country,
    String? banner,
    num? consultationFee,
    num? initialDeposit,
    String? description,
    String? website,
    double? latitude,
    double? longitude,
    List<AvailabilityModel>? availability,
  }) {
    return Clinic(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      status: status ?? this.status,
      cc: cc ?? this.cc,
      country: country ?? this.country,
      banner: banner ?? this.banner,
      consultationFee: consultationFee ?? this.consultationFee,
      initialDeposit: initialDeposit ?? this.initialDeposit,
      description: description ?? this.description,
      website: website ?? this.website,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availability: availability ?? this.availability,
    );
  }
}

class AvailabilityModel {
  String? openTime;
  String? closeTime;
  List<String>? days;

  AvailabilityModel({this.openTime, this.closeTime, this.days});

  AvailabilityModel.fromJson(Map<String, dynamic> json) {
    openTime = json['open_time'];
    closeTime = json['close_time'];
    days = json['days'] != null ? List<String>.from(json['days']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['days'] = days;
    return data;
  }
}
