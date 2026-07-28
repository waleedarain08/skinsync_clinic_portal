import 'base_request.dart';

class StatusRequest extends BaseRequest {
  final String? status;

  StatusRequest({this.status});

  Map<String, dynamic> toJson() => {"status": status};
}
