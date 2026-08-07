class AddAdministrationStaffRequest {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? image;

  AddAdministrationStaffRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        if (image != null) "image": image,
      };
}
