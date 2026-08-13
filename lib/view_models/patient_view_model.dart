import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/patient_detail_response.dart';
import '../models/responses/patient_list_response.dart';
import '../models/responses/patient_treatment_request_response.dart';
import '../repositories/patient_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final patientProvider =
    NotifierProvider.autoDispose<PatientViewModel, PatientState>(
      () => PatientViewModel._(),
    );

class PatientViewModel extends BaseViewModel<PatientState> {
  PatientViewModel._();

  final TextEditingController searchController = TextEditingController();

  final PatientRepository _repository = locator<PatientRepository>();

  @override
  PatientState build() {
    init();
    ref.onDispose(dispose);
    return const PatientState();
  }

  void setPageNumber(int page) {
    state = state.copyWith(page: page);

    getPatients(initialCall: false);
  }

  Future<void> getPatients({
    bool initialCall = false,
    bool showEasyLoading = false,
  }) async {
    if (initialCall) {
      state = state.copyWith(page: 1);
    }

    return await runSafely(showLoading: showEasyLoading, () async {
      state = state.copyWith(loading: !showEasyLoading);

      final response = await _repository.getPatients(
        page: state.page,
        limit: state.pageSize,
        search: searchController.text,
      );

      if (response.success) {
        state = state.copyWith(
          loading: false,
          patients: response.data ?? [],
          totalPage: response.totalPages,
          totalResults: response.totalResults,
          page: response.page,
        );
      } else {
        state = state.copyWith(
          loading: false,
          patients: [],
          totalPage: 0,
          totalResults: 0,
        );
      }
    });

    state = state.copyWith(loading: false);
  }

  void searchPatients() {
    getPatients(initialCall: true);
  }

  void clearSearch() {
    searchController.clear();

    getPatients(initialCall: true);
  }

  Future<bool> getPatientDetail({required int patientId}) async {
    var success = false;

    await runSafely(showLoading: true, () async {
      state = state.copyWith(detailLoading: true);

      final response = await _repository.getPatientDetail(patientId: patientId);

      if (response.success) {
        state = state.copyWith(patientDetail: response.data);

        success = true;
      }
    });

    state = state.copyWith(detailLoading: false);

    return success;
  }

  void clearPatientDetail() {
    state = state.copyWith(clearPatientDetail: true);
  }

  void setTreatmentPageNumber(int page) {
    state = state.copyWith(treatmentPage: page);

    getPatientTreatmentRequests();
  }

  Future<void> getPatientTreatmentRequests({
    bool initialCall = false,
    bool showEasyLoading = false,
  }) async {
    if (initialCall) {
      state = state.copyWith(treatmentPage: 1);
    }

    return await runSafely(showLoading: showEasyLoading, () async {
      state = state.copyWith(treatmentLoading: !showEasyLoading);

      final response = await _repository.getPatientTreatmentRequests(
        page: state.treatmentPage,
        limit: state.treatmentPageSize,
      );

      if (response.success) {
        state = state.copyWith(
          treatmentLoading: false,
          treatmentRequests: response.data ?? [],
          treatmentTotalPage: response.totalPages,
          treatmentTotalResults: response.total,
          treatmentPage: response.page,
        );
      } else {
        state = state.copyWith(
          treatmentLoading: false,
          treatmentRequests: [],
          treatmentTotalPage: 0,
          treatmentTotalResults: 0,
        );
      }
    });
  }

  @mustCallSuper
  void onError(String message) {
    state.copyWith(loading: false);
    EasyLoading.dismiss();
  }
}

class PatientState {
  final bool loading;
  final int page;
  final int pageSize;
  final int? totalPage;
  final int? totalResults;
  final List<PatientData> patients;
  final bool detailLoading;
  final PatientDetailData? patientDetail;
  final bool treatmentLoading;
  final int treatmentPage;
  final int treatmentPageSize;
  final int? treatmentTotalPage;
  final int? treatmentTotalResults;
  final List<PatientTreatmentRequestData> treatmentRequests;

  const PatientState({
    this.loading = false,
    this.page = 1,
    this.pageSize = 10,
    this.totalPage,
    this.totalResults,
    this.patients = const [],
    this.detailLoading = false,
    this.patientDetail,
    this.treatmentLoading = false,
    this.treatmentPage = 1,
    this.treatmentPageSize = 10,
    this.treatmentTotalPage,
    this.treatmentTotalResults,
    this.treatmentRequests = const [],
  });

  PatientState copyWith({
    bool? loading,
    int? page,
    int? pageSize,
    int? totalPage,
    int? totalResults,
    List<PatientData>? patients,
    bool? detailLoading,
    PatientDetailData? patientDetail,
    bool clearPatientDetail = false,
    bool? treatmentLoading,
    int? treatmentPage,
    int? treatmentPageSize,
    int? treatmentTotalPage,
    int? treatmentTotalResults,
    List<PatientTreatmentRequestData>? treatmentRequests,
  }) {
    return PatientState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      totalResults: totalResults ?? this.totalResults,
      patients: patients ?? this.patients,
      detailLoading: detailLoading ?? this.detailLoading,
      patientDetail: clearPatientDetail
          ? null
          : (patientDetail ?? this.patientDetail),
      treatmentLoading: treatmentLoading ?? this.treatmentLoading,
      treatmentPage: treatmentPage ?? this.treatmentPage,
      treatmentPageSize: treatmentPageSize ?? this.treatmentPageSize,
      treatmentTotalPage: treatmentTotalPage ?? this.treatmentTotalPage,
      treatmentTotalResults:
          treatmentTotalResults ?? this.treatmentTotalResults,
      treatmentRequests: treatmentRequests ?? this.treatmentRequests,
    );
  }
}
