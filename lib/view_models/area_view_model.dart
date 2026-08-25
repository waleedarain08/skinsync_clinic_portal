import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/add_area_request.dart';
import '../models/responses/area_list_response.dart';
import '../repositories/area_repository.dart';
import '../services/area_services.dart';
import '../services/locator.dart';

import 'base_view_model.dart';
import 'treatment_view_model.dart';

final areaViewModelProvider = NotifierProvider<AreaViewModel, AreaState>(
  () => AreaViewModel._(),
);

class AreaState {
  final List<AreaModel> areas;
  final AreaModel? selectedAreas;
  final bool loading;

  AreaState({
    this.loading = false,
    this.areas = const [],
    this.selectedAreas ,
  });

  AreaState copyWith({
    bool? loading,
    List<AreaModel>? areas,
    AreaModel? selectedAreas,
      bool clearSelectedArea = false,
  }) {
    return AreaState(
      loading: loading ?? this.loading,
      areas: areas ?? this.areas,
       selectedAreas: clearSelectedArea
          ? null
          : (selectedAreas ?? this.selectedAreas),    );
  }
}

class AreaViewModel extends BaseViewModel<AreaState> {
  AreaViewModel._();

  @override
  AreaState build() {
    init();
    ref.onDispose(dispose);
    return AreaState();
  }

  final AreaRepository _areaRepository = locator<AreaServices>();

  Future<List<AreaModel>> fetchAreas({bool showLoading = true,required int treatmentId}) async {
   

    state = state.copyWith(loading: showLoading);

    await runSafely(showLoading:  false,() async {
      final fetched = await _areaRepository.getAreas(treatmentId: treatmentId);

      state = state.copyWith(areas: fetched, loading: false);
    });
    return state.areas;
  }

Future<void> addAreas() async {
  final treatmentId = ref
      .read(treatmentViewModelProvider)
      .selectedTreatmentDetail
      ?.id;

  if (treatmentId == null || state.selectedAreas == null) {
    return;
  }

  final request = AddAreaRequest(
    areaId: state.selectedAreas!.id,
  );

  await runSafely( () async {
    final response = await _areaRepository.addAreas(
      request: request,
      treatmentId: treatmentId,
    );

    if (response.success) {
      await fetchAreas(showLoading: false, treatmentId: treatmentId);
    }
  });
}
 void toggleSelectedArea(AreaModel area) {
  if (state.selectedAreas?.id == area.id) {
    state = state.copyWith(clearSelectedArea: true);
  } else {
    state = state.copyWith(selectedAreas: area);
  }
}

void clearSelectedAreas() {
  state = state.copyWith(clearSelectedArea: true);
}
  @override
  void onError(String message) {
    super.onError(message);
    state = state.copyWith(loading: false);
    EasyLoading.showError(message);
  }
}
