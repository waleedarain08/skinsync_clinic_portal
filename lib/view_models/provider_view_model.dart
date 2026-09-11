import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../models/responses/filters_response.dart';
import '../repositories/provider_role_repository.dart';
import '../services/locator.dart';
import 'base_view_model.dart';

final providerRoleViewModelProvider =
    NotifierProvider<ProviderRoleViewModel, ProviderRoleState>(
      ProviderRoleViewModel.new,
    );

class ProviderRoleState {
  final List<Filters>? providerRoles;
  final List<String>? selectedProviderRoles;
  final List<Filters>? providerStaffRoles;
  final List<String>? selectedProviderStaffRoles;
  ProviderRoleState({this.providerRoles, this.selectedProviderRoles,this.providerStaffRoles,this.selectedProviderStaffRoles});

  ProviderRoleState copyWith({
    List<Filters>? providerRoles,
    List<String>? selectedProviderRoles,
    List<Filters>? providerStaffRoles,
    List<String>? selectedProviderStaffRoles,
  }) {
    return ProviderRoleState(
      providerRoles: providerRoles ?? this.providerRoles,
      selectedProviderRoles:
          selectedProviderRoles ?? this.selectedProviderRoles,
          providerStaffRoles : providerStaffRoles ?? this.providerStaffRoles,
          selectedProviderStaffRoles: selectedProviderStaffRoles?? this.selectedProviderStaffRoles
    );
  }
}

class ProviderRoleViewModel extends BaseViewModel<ProviderRoleState> {
  ProviderRoleViewModel() ;

 @override
  ProviderRoleState build() {
    init();
    ref.onDispose(dispose);
    return ProviderRoleState();
  }


  final ProviderRoleRepository _providerRolesRepository =
      locator<ProviderRoleRepository>();

  void toggleSelectedProvider({required String role}) {
    final selected = List<String>.from(state.selectedProviderRoles ?? []);

    if (selected.contains(role)) {
      selected.remove(role);
    } else {
      selected.add(role);
    }

    state = state.copyWith(selectedProviderRoles: selected);
  }

  Future<void> fetchProviderRoles() async {
    await runSafely(() async {
      final response = await _providerRolesRepository.providerRoles();
      state = state.copyWith(providerRoles: response.data);
    });
  }
   Future<void> fetchProviderStaffRoles() async {
    await runSafely(() async {
      final response = await _providerRolesRepository.providerStaffRoles();
      state = state.copyWith(providerStaffRoles: response.data);
    });
  }
}
