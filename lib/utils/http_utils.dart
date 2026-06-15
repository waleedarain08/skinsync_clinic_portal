import 'enums.dart';

extension RequestTypeUtils on RequestType {
  String get method {
    return switch (this) {
      RequestType.get => 'GET',
      RequestType.post => 'POST',
      RequestType.put => 'PUT',
      RequestType.patch => 'PATH',
      RequestType.delete => 'DELETE',
      RequestType.multipartPost => 'POST',
      RequestType.multipartPatch => 'PATCH',
    };
  }
}
