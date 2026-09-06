
import '../treatment_data_models.dart';
import 'base_request.dart';

class CreateProtocolFieldRequest extends BaseRequest {
  final String title;
  final ProtocolType type;

  CreateProtocolFieldRequest({
    required this.title,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.value,
    };
  }
}
