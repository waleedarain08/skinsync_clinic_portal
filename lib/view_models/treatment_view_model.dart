import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/treatment_model.dart';
import '../repositories/treatment_repository.dart';
import '../models/requests/add_treatment_req_model.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final treatmentViewModelProvider = NotifierProvider<TreamententViewModel, TreatmentState>(
  () => TreamententViewModel._(),
);

class TreamententViewModel extends BaseViewModel<TreatmentState> {
  TreamententViewModel._();

  @override
  TreatmentState build() {
    init();
    ref.onDispose(dispose);
    return TreatmentState();
  }

  final TreatmentRepository _treatmentRepository =
      locator<TreatmentRepository>();

  Future<bool> getTreatments() async {
    return await runSafely<bool?>(showLoading: false, () async {
          state = state.copyWith(loading: true);
          final response = await _treatmentRepository.getClinicTreatments();

          state = state.copyWith(treatments: response, loading: false);

          return true;
        }) ??
        false;
  }

  Future<List<TreatmentModel>> getAdminTreatments() async {
    return await runSafely<List<TreatmentModel>?>(showLoading: false, () async {
          final response = await _treatmentRepository.getAdminTreatments();
          return response;
        }) ??
        [];
  }

  Future<List<SideAreaModel>> getTreatmentsSideAreas({
    required int treatmentId,
  }) async {
    return await runSafely<List<SideAreaModel>?>(showLoading: true, () async {
          final response = await _treatmentRepository.getTreatmentsSideArea(
            treatmentId,
          );
          return response;
        }) ??
        [];
  }

  Future<bool> addClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _treatmentRepository.addTreatment(treatment);
          state = state.copyWith(treatments: state.treatments..add(response));
          return true;
        }) ??
        false;
  }

  Future<bool> editClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final response = await _treatmentRepository.editTreatment(treatment);

          final updatedList = [...state.treatments];

          final index = updatedList.indexWhere((e) => e.id == response.id);

          if (index != -1) {
            updatedList[index] = response;
          }

          // Update state
          state = state.copyWith(treatments: updatedList);

          return true;
        }) ??
        false;
  }

  Future<bool> deleteTreatment({required int treatmentId}) async {
    return await runSafely<bool?>(showLoading: true, () async {
          final _ = await _treatmentRepository.deleteTreatment(treatmentId);

          final updatedList = [...state.treatments];

          final index = updatedList.indexWhere((e) => e.id == treatmentId);

          updatedList.removeAt(index);

          // Update state
          state = state.copyWith(treatments: updatedList);

          return true;
        }) ??
        false;
  }

  void setTreatment(int treatmentId) {
    state = state.copyWith(selectedTreatmentId: treatmentId);
  }
}

class TreatmentState {
  final List<TreatmentModel> treatments;
  final int? selectedTreatmentId;
  final bool loading;

  TreatmentState({
    this.treatments = const [],
    this.loading = false,
    this.selectedTreatmentId,
  });

  TreatmentState copyWith({
    bool? loading,
    List<TreatmentModel>? treatments,
    int? selectedTreatmentId,
  }) {
    return TreatmentState(
      loading: loading ?? this.loading,
      treatments: treatments ?? this.treatments,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
    );
  }
}
