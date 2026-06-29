class TreatmentModel {
  int? id;
  int? price;
  String? name;
  String? description;
  String? shortDescription;
  String? globalSku;
  String? icon;
  String? image;
  String? status;
  bool? isArea;
  List<SideAreaModel>? sideAreas;

  TreatmentModel({
    this.id,
    this.name,
    this.description,
    this.shortDescription,
    this.globalSku,
    this.icon,
    this.image,
    this.status,
    this.isArea,
    this.sideAreas,
    this.price,
  });

  TreatmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['treatment_price'] ?? json['price'];
    name = json['name'];
    description = json['description'] ?? json['short_description'];
    shortDescription = json['short_description'];
    globalSku = json['global_sku'];
    icon = json['icon'];
    image = json['image'];
    status = json['status'];
    isArea = json['is_area'];
    sideAreas = json['side_areas'] != null
        ? (json['side_areas'] as List)
              .map((e) => SideAreaModel.fromJson(e))
              .toList()
        : null;
  }

  TreatmentModel copyWith({
    int? id,
    String? name,
    String? description,
    String? shortDescription,
    String? globalSku,
    String? icon,
    String? image,
    String? status,
    bool? isArea,
    List<SideAreaModel>? sideAreas,
    int? price,
  }) {
    return TreatmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      globalSku: globalSku ?? this.globalSku,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      status: status ?? this.status,
      isArea: isArea ?? this.isArea,
      sideAreas: sideAreas ?? this.sideAreas,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toRequest() {
    return {
      'treatment_id': id,
      'treatments_sub_sec_id': sideAreas
          ?.map((sideArea) => sideArea.id)
          .toList(),
    };
  }
}

class SideAreaModel {
  int? id;
  String? name;
  double? perSyringePrice;
  int? maxSyringe;

  SideAreaModel({this.id, this.name, this.perSyringePrice, this.maxSyringe});

  SideAreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    perSyringePrice = json['per_syringe_price'];
    maxSyringe = json['max_syringe'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "per_syringe_price": perSyringePrice,
      "max_syringe": maxSyringe,
    };
  }
}
