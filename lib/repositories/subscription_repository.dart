import '../models/subscription_plan_model.dart';
import '../models/requests/subscribe_request.dart';

abstract class SubscriptionRepository {
  Future<ClinicCurrentPlanData> getClinicCurrentPlan();
  Future<SubscribeResponseData> subscribe({required SubscribeRequest req});
}
