import 'base_response_model.dart';
import 'register_doctor_response.dart';

class GetDoctorsResponse extends BaseResponse<List<Doctor>> {
  const GetDoctorsResponse({
    required super.status,
    required super.message,
    super.data,
  });

  factory GetDoctorsResponse.fromJson(Map<String, dynamic> json) =>
      GetDoctorsResponse(
        data: List<Doctor>.from(json["data"].map((x) => Doctor.fromJson(x))),
        status: json["is_success"] ?? false,
        message: json["message"] ?? "",
      );
}

// class Datum {
//   final int id;
//   final String name;
//   final String email;
//   final String role;
//   final String status;
//   final String image;
//   final String specialization;
//   final String phone;
//   final List<Treatment> treatments;
//   final List<Availability> availability;
//
//   Datum({
//     this.id,
//     this.name,
//     this.email,
//     this.role,
//     this.status,
//     this.image,
//     this.specialization,
//     this.phone,
//     this.treatments,
//     this.availability,
//   });
//
//   factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"],
//     name: json["name"],
//     email: json["email"],
//     role: json["role"],
//     status: json["status"],
//     image: json["image"],
//     specialization: json["specialization"],
//     phone: json["phone"],
//     treatments: List<Treatment>.from(json["treatments"].map((x) => Treatment.fromJson(x))),
//     availability: List<Availability>.from(json["availability"].map((x) => Availability.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "email": email,
//     "role": role,
//     "status": status,
//     "image": image,
//     "specialization": specialization,
//     "phone": phone,
//     "treatments": List<dynamic>.from(treatments.map((x) => x.toJson())),
//     "availability": List<dynamic>.from(availability.map((x) => x.toJson())),
//   };
// }
//
// class Availability {
//   final String startTime;
//   final String endTime;
//   final List<String> days;
//
//   Availability({
//     this.startTime,
//     this.endTime,
//     this.days,
//   });
//
//   factory Availability.fromRawJson(String str) => Availability.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Availability.fromJson(Map<String, dynamic> json) => Availability(
//     startTime: json["start_time"],
//     endTime: json["end_time"],
//     days: List<String>.from(json["days"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "start_time": startTime,
//     "end_time": endTime,
//     "days": List<dynamic>.from(days.map((x) => x)),
//   };
// }
//
// class Treatment {
//   final int treatmentId;
//   final String treatmentName;
//   final List<SideArea> sideAreas;
//
//   Treatment({
//     this.treatmentId,
//     this.treatmentName,
//     this.sideAreas,
//   });
//
//   factory Treatment.fromRawJson(String str) => Treatment.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
//     treatmentId: json["treatment_id"],
//     treatmentName: json["treatment_name"],
//     sideAreas: List<SideArea>.from(json["side_areas"].map((x) => SideArea.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "treatment_id": treatmentId,
//     "treatment_name": treatmentName,
//     "side_areas": List<dynamic>.from(sideAreas.map((x) => x.toJson())),
//   };
// }
//
// class SideArea {
//   final int sideAreaId;
//   final String sideAreaName;
//
//   SideArea({
//     this.sideAreaId,
//     this.sideAreaName,
//   });
//
//   factory SideArea.fromRawJson(String str) => SideArea.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory SideArea.fromJson(Map<String, dynamic> json) => SideArea(
//     sideAreaId: json["side_area_id"],
//     sideAreaName: json["side_area_name"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "side_area_id": sideAreaId,
//     "side_area_name": sideAreaName,
//   };
// }
