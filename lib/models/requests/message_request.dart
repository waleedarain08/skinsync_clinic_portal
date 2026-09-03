
import 'base_request.dart';

class MessageRequest extends BaseRequest  {
    final String? message;

    MessageRequest({
        this.message,
    });
   
    Map<String, dynamic> toJson() => {
        "message": message,
    };
}


