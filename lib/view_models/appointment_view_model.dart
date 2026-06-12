import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_clinic_portal/models/responses/appointment_response.dart';
import 'package:skinsync_clinic_portal/services/appointment_service.dart';
import 'package:skinsync_clinic_portal/services/locator.dart';
import 'package:skinsync_clinic_portal/utils/enums.dart';
import 'package:skinsync_clinic_portal/view_models/base_view_model.dart';

final appointmentProvider =
    NotifierProvider.autoDispose<AppointmentViewModel, AppointmentState>(
  () => AppointmentViewModel._(),
);

class AppointmentViewModel extends BaseViewModel<AppointmentState> {
  AppointmentViewModel._();

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

  void setFilter(AppointmentFilter? filter) {
    state = state.copyWith(filter: filter);

    getAppointments(initialCall: true);
  }

  void setStatus(AppointmentStatus? status) {
    state = state.copyWith(status: status);
    getAppointments(initialCall: true);
  }

  Future<void> getAppointments({bool? initialCall = false}) async {
    if (initialCall == true) {
      state = state.copyWith(page: 1);
    }
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final appointment = await locator<AppointmentService>().appointmentList(
        page: state.page,
        filter: state.filter,
        status: state.status,
      );
      state = state.copyWith(
        loading: false,
        appointmentList: appointment.data,
        totalPage: appointment.totalPages,
      );
    }, showLoading: false);
  }
}

class AppointmentState {
  final bool loading;
  final int page;
  final int? totalPage;
  final List<AppointmentData>? appointmentList;
  final AppointmentFilter? filter;
  final AppointmentStatus? status;

  const AppointmentState({
    this.loading = false,
    this.page = 1,
    this.totalPage,
    this.appointmentList,
    this.filter = AppointmentFilter.all,
    this.status = AppointmentStatus.allStatus,
  });

  AppointmentState copyWith({
    bool? loading,
    int? page,
    int? totalPage,
    List<AppointmentData>? appointmentList,
    AppointmentFilter? filter,
    AppointmentStatus? status,
  }) {
    return AppointmentState(
      loading: loading ?? this.loading,
      page: page ?? this.page,
      totalPage: totalPage ?? this.totalPage,
      appointmentList: appointmentList ?? this.appointmentList,
      filter: filter ?? this.filter,
      status: status ?? this.status,
    );
  }
}
