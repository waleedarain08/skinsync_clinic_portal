import 'base_request.dart';

class FetchPractitionerByEmailRequest extends BaseRequest {
  final String email;

  FetchPractitionerByEmailRequest({required this.email});

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
