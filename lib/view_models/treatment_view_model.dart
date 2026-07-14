import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/treatment_detail_response.dart';
import '../models/treatment_model.dart';
import '../models/requests/add_treatment_req_model.dart';
import '../models/responses/clinic_treatment_list_response.dart';
import '../repositories/treatment_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final treatmentViewModelProvider = NotifierProvider<TreamententViewModel, TreatmentState>(
  () => TreamententViewModel._(),
);

class TreamententViewModel extends BaseViewModel<TreatmentState> {
  TreamententViewModel._();

  Timer? _searchDebounce;

  @override
  TreatmentState build() {
    init();
    ref.onDispose(dispose);
    return TreatmentState();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> getTreatments({bool isRefresh = false}) async {
    if (state.loading) return;

    final int targetPage = isRefresh ? 1 : state.page;
    if (!isRefresh && !state.hasMore) return;

    state = state.copyWith(
      loading: true,
      error: null,
      page: targetPage,
      treatments: isRefresh ? [] : state.treatments,
    );

    try {
       final repository = locator<TreatmentRepository>();
       final ClinicTreatmentListResponse response = await repository.getClinicTreatments(
         page: targetPage,
         limit: state.limit,
         search: state.search,
         status: state.status,
       );

       final List<TreatmentModel> newTreatments = response.data ?? [];
       final int totalPages = response.totalPages ?? 1;

       state = state.copyWith(
         treatments: isRefresh ? newTreatments : [...state.treatments, ...newTreatments],
         loading: false,
         page: targetPage + 1,
         totalPages: totalPages,
         hasMore: targetPage < totalPages && newTreatments.isNotEmpty,
       );
    } catch (e) {
       state = state.copyWith(
         loading: false,
         error: e.toString().replaceAll('Exception:', '').trim(),
         hasMore: false,
       );
    }
  }

  void onSearchChanged(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();

    state = state.copyWith(search: query);

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      getTreatments(isRefresh: true);
    });
  }

  void onStatusChanged(String status) {
    state = state.copyWith(status: status);
    getTreatments(isRefresh: true);
  }

  Future<List<TreatmentModel>> getAdminTreatments() async {
    final repository = locator<TreatmentRepository>();
    final response = await repository.getTreatmentTemplates(page: 1, limit: 100);
    return response.data?.map((item) => TreatmentModel(
      id: item.id,
      name: item.name,
      description: item.shortDescription,
      price: 0,
      isArea: false,
    )).toList() ?? [];
  }

    Future<bool> fetchTreatmentDetail(int id, {bool loading = true}) async {
        final repository = locator<TreatmentRepository>();
    return await runSafely<bool>(showLoading: loading, () async {
          final response = await repository.getTreatmentDetail(
            id: id,
          );
          if (response.isSuccess && response.data != null) {
            state = state.copyWith(selectedTreatmentDetail: response.data);
            return true;
          }
          return false;
        }) ??
        false;
  }


  

  Future<List<SideAreaModel>> getTreatmentsSideAreas({
    required int treatmentId,
  }) async {
    try {
      final repository = locator<TreatmentRepository>();
      return await repository.getTreatmentsSideArea(treatmentId);
    } catch (e) {
      return [];
    }
  }

  Future<bool> addClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    state = state.copyWith(loading: true);
    try {
      await locator<TreatmentRepository>().addTreatment(treatment);
      await getTreatments(isRefresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false);
      return false;
    }
  }

  Future<bool> editClinicTreatment({
    required AddTreatmentReqModel treatment,
  }) async {
    state = state.copyWith(loading: true);
    try {
      await locator<TreatmentRepository>().editTreatment(treatment);
      await getTreatments(isRefresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false);
      return false;
    }
  }

  Future<bool> deleteTreatment({required int treatmentId}) async {
    state = state.copyWith(loading: true);
    try {
      await locator<TreatmentRepository>().deleteTreatment(treatmentId);
      await getTreatments(isRefresh: true);
      return true;
    } catch (e) {
      state = state.copyWith(loading: false);
      return false;
    }
  }

  void setTreatment(int treatmentId) {
    state = state.copyWith(selectedTreatmentId: treatmentId);
  }

  void setPage(int page) {
    state = state.copyWith(
      page: page,
      hasMore: true,
    );
    getTreatments(isRefresh: true);
  }
}

class TreatmentState {
  final List<TreatmentModel> treatments;
  final int? selectedTreatmentId;
  final bool loading;
  final int page;
  final int limit;
  final String search;
  final String status;
  final int totalPages;
  final bool hasMore;
  final String? error;
  final TreatmentDetailDto? selectedTreatmentDetail;

  TreatmentState({
    this.treatments = const [],
    this.loading = false,
    this.selectedTreatmentId,
    this.page = 1,
    this.limit = 10,
    this.search = '',
    this.status = '',
    this.totalPages = 1,
    this.hasMore = true,
    this.error,
    this.selectedTreatmentDetail
  });

  TreatmentState copyWith({
    bool? loading,
    List<TreatmentModel>? treatments,
    int? selectedTreatmentId,
    int? page,
    int? limit,
    String? search,
    String? status,
    int? totalPages,
    bool? hasMore,
    String? error,
    TreatmentDetailDto? selectedTreatmentDetail,
  }) {
    return TreatmentState(
      loading: loading ?? this.loading,
      treatments: treatments ?? this.treatments,
      selectedTreatmentId: selectedTreatmentId ?? this.selectedTreatmentId,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: search ?? this.search,
      status: status ?? this.status,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      selectedTreatmentDetail: selectedTreatmentDetail?? this.selectedTreatmentDetail
    );
  }
}
