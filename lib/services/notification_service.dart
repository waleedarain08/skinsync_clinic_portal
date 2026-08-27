import '../models/responses/notification_response.dart';
import '../repositories/notification_repository.dart';
import '../utils/enums.dart';
import 'api_base_helper.dart';
import 'locator.dart';

class NotificationService implements NotificationRepository {
  @override
  Future<NotificationResponse> fetchNotification({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await locator<ApiBaseService>().httpRequest(
      endPoint: Endpoint.notification,
      requestType: RequestType.get,
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );

    final model = NotificationResponse.fromJson(response);

    return model;
  }
}
