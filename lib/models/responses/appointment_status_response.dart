import 'dart:convert';


import 'base_response_model.dart';

class AppointmentStatusResponse extends BaseApiResponseModel<List<AppointmentStatus>> {
  AppointmentStatusResponse({
    super.data,
    required super.success,
    required super.message,
  });

  factory AppointmentStatusResponse.fromJson(Map<String, dynamic> json) =>
      AppointmentStatusResponse(
        data: json["data"] == null
            ? []
            : List<AppointmentStatus>.from(
                json["data"]!.map((x) => AppointmentStatus.fromJson(x)),
              ),
        success: json["is_success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "is_success": isSuccess,
    "message": message,
  };
}

class AppointmentStatus {
  final String? id;
  final String? name;

  AppointmentStatus({this.id, this.name});

  factory AppointmentStatus.fromRawJson(String str) =>
      AppointmentStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppointmentStatus.fromJson(Map<String, dynamic> json) =>
      AppointmentStatus(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
