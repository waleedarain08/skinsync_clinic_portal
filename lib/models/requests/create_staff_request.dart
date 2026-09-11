import 'base_request.dart';

class CreateStaffRequest extends BaseRequest {
  final String name;
  final String email;
  final String phone;
  final String cc;
  final String country;
  final String role;

  CreateStaffRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.cc,
    required this.country,
    required this.role,
  });


  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'cc': cc,
      'country': country,
      'role': role,
    };
  }
}