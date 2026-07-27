import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/responses/appointment_response.dart';
import '../models/responses/appointment_status_response.dart';
import '../models/responses/filters_response.dart';
import '../services/appointment_service.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final appointmentProvider =
    NotifierProvider.autoDispose<AppointmentViewModel, AppointmentState>(
      () => AppointmentViewModel._(),
    );

class AppointmentViewModel extends BaseViewModel<AppointmentState> {
  AppointmentViewModel._();
  final TextEditingController searchController = TextEditingController();
  @override
  AppointmentState build() {
    init();
    ref.onDispose(dispose);
    return const AppointmentState();
  }

  void setPageNumber(int page) {
    state = state.copyWith(page: page);
    getAppointments(initialCall: false);
  }

  void setFilter(Filters? filter) {
    state = state.copyWith(filter: filter, clearFilter: filter == null);
    getAppointments(initialCall: true, showEasyLoading: true);
  }

  void setStatus(AppointmentStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
    getAppointments(initialCall: true, showEasyLoading: true);
  }

  Future<void> getAppointments({
    bool? initialCall = false,
    bool showEasyLoading = false,
  }) async {
    if (initialCall == true) {
      state = state.copyWith(page: 1);
    }
    await runSafely(showLoading: showEasyLoading, () async {
      state = state.copyWith(loading: !showEasyLoading);
      final appointment = await locator<AppointmentService>().appointmentList(
        page: state.page,
        filter: state.filter,
        status: state.status,
        search: searchController.text,
      );
      if (appointment.success) {
        state = state.copyWith(
          loading: false,
          appointmentList:  appointment.data?.items ?? [],
          totalPage: appointment.data?.totalPages ?? 0,
        );
      } else {
        state = state.copyWith(appointmentList: [], totalPage: 0);
      }
    });
    state = state.copyWith(loading: false);
  }

  Future<void> getAppointmentsStatus() async {
    return await runSafely(() async {
      final appointment = await locator<AppointmentService>()
          .getAppointmentStatus();
      state = state.copyWith(appointmentStatus: appointment.data ?? []);
    });
  }

  Future<void> getAppointmentsTypes() async {
    return await runSafely(() async {
      final appointment = await locator<AppointmentService>()
          .getAppointmentTypes();
      state = state.copyWith(appointmentTypes: appointment.data ?? []);
    }, );
  }
}

class AppointmentState {
  final bool loading;
  final int page;
  final int? totalPage;
  final List<AppointmentListData>? appointmentList;
  final Filters? filter;
  final AppointmentStatus? status;
  final List<Filters>? appointmentTypes;
  final List<AppointmentStatus>? appointmentStatus;

  const AppointmentState({
    this.loading = false,
    this.page = 1,
    this.totalPage,
    this.appointmentList,
    this.filter,
    this.status,
    this.appointmentTypes = const [],
    this.appointmentStatus = const [],
  });

  AppointmentState copyWith({
    bool? loading,
    int? page,
    int? totalPage,
    List<AppointmentListData>? appointmentList,
    Filters? filter,
    AppointmentStatus? status,
    List<Filters>? appointmentTypes,
    List<AppointmentStatus>? appointmentStatus,
    bool clearFilter = false,
    bool clearStatus = false,
  }) {
    return AppointmentState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      appointmentList: appointmentList ?? this.appointmentList,
      appointmentTypes: appointmentTypes ?? this.appointmentTypes,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      filter: clearFilter ? null : (filter ?? this.filter),
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}
