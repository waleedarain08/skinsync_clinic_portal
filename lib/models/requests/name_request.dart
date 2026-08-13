import 'base_request.dart';

class NameRequest extends BaseRequest {
  final String name;

  NameRequest({
    required this.name,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}