import 'base_request.dart';

class StatusRequest extends BaseRequest {
  final String? status;

  StatusRequest({this.status});

  @override
  Map<String, dynamic> toJson() => {"status": status};
}
