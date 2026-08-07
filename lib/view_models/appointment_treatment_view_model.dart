import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/appointment_treatment_detail_response.dart';
import '../utils/clinic_dummy_data.dart';
import 'base_view_model.dart';

class AppointmentTreatmentState {
  final AppointmentTreatmentDetailData? detail;
  final Map<int, Map<String, dynamic>> historyDetails; // Map of ID to details
  final bool loading;
  final String? error;

  AppointmentTreatmentState({
    this.detail,
    this.historyDetails = const {},
    this.loading = false,
    this.error,
  });

  AppointmentTreatmentState copyWith({
    AppointmentTreatmentDetailData? detail,
    Map<int, Map<String, dynamic>>? historyDetails,
    bool? loading,
    String? error,
  }) {
    return AppointmentTreatmentState(
      detail: detail ?? this.detail,
      historyDetails: historyDetails ?? this.historyDetails,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

final appointmentTreatmentProvider =
    NotifierProvider<AppointmentTreatmentViewModel, AppointmentTreatmentState>(
  () => AppointmentTreatmentViewModel(),
);

class AppointmentTreatmentViewModel extends BaseViewModel<AppointmentTreatmentState> {
  @override
  AppointmentTreatmentState build() {
    return AppointmentTreatmentState();
  }

  Future<void> getTreatmentDetail(int treatmentId) async {
    state = state.copyWith(loading: true);
    // Simulate API call using dummy data
    await Future.delayed(const Duration(milliseconds: 800));
    
    final detail = AppointmentTreatmentDetailData.fromJson(ClinicDummyData.dummyAppointmentTreatmentDetail);
    state = state.copyWith(detail: detail, loading: false, historyDetails: {});
  }

  Future<void> fetchHistoryDetail(int historyId) async {
    if (state.historyDetails.containsKey(historyId)) return;

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 300));
    final details = ClinicDummyData.getHistoryDetail(historyId);
    
    final newMap = Map<int, Map<String, dynamic>>.from(state.historyDetails);
    newMap[historyId] = details;
    state = state.copyWith(historyDetails: newMap);
  }
}
