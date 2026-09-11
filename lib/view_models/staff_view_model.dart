import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/requests/create_staff_request.dart';
import '../models/responses/staff__list_response.dart';
import '../repositories/staff_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final staffViewModelProvider = NotifierProvider<StaffViewModel, StaffState>(
  StaffViewModel.new,
);

class StaffState {
  final List<StaffModel> staff;
  final bool loading;
  const StaffState({this.staff = const [],this.loading =false});

  StaffState copyWith({List<StaffModel>? staff,bool? loading}) {
    return StaffState(staff: staff ?? this.staff,loading: loading ?? this.loading);
  }
}

class StaffViewModel extends BaseViewModel<StaffState> {
  StaffViewModel();

  final StaffRepository _staffRepository = locator<StaffRepository>();

  @override
  StaffState build() {
    ref.onDispose(dispose);
    return const StaffState();
  }

  Future<bool?> createStaff({required CreateStaffRequest request}) async {
    return await runSafely<bool>(() async {
      final response = await _staffRepository.createStaff(request: request);
      if (response.success == true) {
        getStaff(); // Refresh list after adding
      }
      return response.success;
    });
  }

Future<void> getStaff({
  int page = 1,
  int limit = 10,
  String search = '',
}) async {
  state = state.copyWith(loading: true);
  await runSafely<void>(showLoading: false, () async {
    final response = await _staffRepository.getStaff(
      page: page,
      limit: limit,
      search: search,
    );
    if (response.isSuccess) {
      state = state.copyWith(staff: response.data ?? [], loading: false);
    } else {
      state = state.copyWith(loading: false);
    }
  });
}
  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}