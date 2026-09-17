import '../models/requests/subscribe_request.dart';
import '../models/subscription_plan_model.dart';
import '../repositories/subscription_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final subscriptionViewModelProvider = NotifierProvider<SubscriptionViewModel, SubscriptionState>(
  () => SubscriptionViewModel._(),
);

class SubscriptionViewModel extends BaseViewModel<SubscriptionState> {
  SubscriptionViewModel._();

  final SubscriptionRepository _subscriptionRepository = locator<SubscriptionRepository>();

  @override
  SubscriptionState build() {
    return SubscriptionState();
  }

  Future<bool> fetchCurrentPlan() async {
    final result = await runSafely<ClinicCurrentPlanData>(() async {
      return await _subscriptionRepository.getClinicCurrentPlan();
    });

    if (result != null) {
      state = state.copyWith(
        currentPlanData: result,
      );
      return true;
    }
    return false;
  }

  Future<String?> subscribeToPlan({required String planId, String? durationId}) async {
    final result = await runSafely<SubscribeResponseData>(() async {
      final req = SubscribeRequest(planId: planId, durationId: durationId);
      return await _subscriptionRepository.subscribe(req: req);
    });

    return result?.stripeUrl;
  }
}

class SubscriptionState {
  final bool loading;
  final ClinicCurrentPlanData? currentPlanData;

  SubscriptionState({
    this.loading = false,
    this.currentPlanData,
  });

  SubscriptionState copyWith({
    bool? loading,
    ClinicCurrentPlanData? currentPlanData,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      currentPlanData: currentPlanData ?? this.currentPlanData,
    );
  }
}
