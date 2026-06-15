import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/requests/create_role_request_model.dart';
import '../models/responses/get_feature_response.dart';
import '../models/responses/get_roles_response.dart';
import '../services/locator.dart';
import '../services/role_service.dart';

import 'base_view_model.dart';

final roleProvider = NotifierProvider.autoDispose<RoleViewModel, RoleState>(
  () => RoleViewModel._(),
);

class RoleViewModel extends BaseViewModel<RoleState> {
  RoleViewModel._();

  @override
  RoleState build() {
    init();
    ref.onDispose(dispose);
    return const RoleState();
  }

  Feature? getSelectedFeature(int featureId) {
    try {
      return state.selectedFeatures.firstWhere((e) => e.featureId == featureId);
    } catch (_) {
      return null;
    }
  }

  Future<void> getFeature() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final feature = await locator<RoleService>().fetchFeature();
      state = state.copyWith(loading: false, features: feature.data);
    }, showLoading: false);
  }

  Future<void> getRole() async {
    return await runSafely(() async {
      state = state.copyWith(loading: true);
      final roles = await locator<RoleService>().fetchRole();
      state = state.copyWith(loading: false, roles: roles.data);
    }, showLoading: false);
  }

  Future<bool?> createRole(String roleName) async {
    final request = CreateRoleRequest(
      roleName: roleName,
      features: state.selectedFeatures.map((feature) {
        return RoleFeatureRequest(
          featureId: feature.featureId!,
          permissionIds: feature.permissions!
              .map((p) => p.permissionId!)
              .toList(),
        );
      }).toList(),
    );

    await runSafely(() async {
      state = state.copyWith(loading: true);

      await locator<RoleService>().registerRole(request: request);

      state = state.copyWith(loading: false, success: true);
    });
    return true;
  }

  /// Toggle action selection
  void toggleAction({
    required Feature feature,
    required Permissions permissions,
    required bool selected,
  }) {
    final updated = [...state.selectedFeatures];

    Feature? featureItem;
    try {
      featureItem = updated.firstWhere((e) => e.featureId == feature.featureId);
    } catch (_) {
      featureItem = null;
    }

    if (selected) {
      /// ADD action
      if (featureItem == null) {
        updated.add(
          Feature(
            featureId: feature.featureId,
            featureName: feature.featureName,
            permissions: [permissions],
          ),
        );
      } else {
        featureItem.permissions ??= [];
        if (!featureItem.permissions!.any(
          (a) => a.permissionId == permissions.permissionId,
        )) {
          featureItem.permissions!.add(permissions);
        }
      }
    } else {
      /// REMOVE action
      if (featureItem != null) {
        featureItem.permissions!.removeWhere(
          (a) => a.permissionId == permissions.permissionId,
        );

        if (featureItem.permissions!.isEmpty) {
          updated.remove(featureItem);
        }
      }
    }

    state = state.copyWith(selectedFeatures: updated);
  }

  void setSelectedRole(Roles? role) {
    state = state.copyWith(selectedRole: role);
  }



  void clear() {
    state = state.copyWith(selectedFeatures: []);
  }

  @override
  void onError(String message) {
    state = state.copyWith(loading: false);
    super.onError(message);
  }
}

class RoleState {
  final bool loading;
  final bool createRoleLoading;
  final List<Feature> features;
  final List<Feature> selectedFeatures;
  final List<Roles> roles;
  final bool success;
  final Roles? selectedRole;

  const RoleState({
    this.loading = false,
    this.selectedFeatures = const [],
    this.features = const [],
    this.roles = const [],
    this.createRoleLoading = false,
    this.success = false,
    this.selectedRole,
  });

  RoleState copyWith({
    bool? loading,
    bool? createRoleLoading,
    List<Feature>? features,
    List<Feature>? selectedFeatures,
    List<Roles>? roles,
    bool? success,
    Roles? selectedRole,
  }) {
    return RoleState(
      loading: loading ?? this.loading,
      createRoleLoading: createRoleLoading ?? this.createRoleLoading,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      roles: roles ?? this.roles,
      success: success ?? false,
      features: features ?? this.features,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }

  RoleState copyWithNull({
    bool? loading,
    bool? createRoleLoading,
    List<Feature>? selectedFeatures,
    List<Feature>? features,
    List<Roles>? roles,
    bool? success,
    Roles? selectedRole,
  }) {
    return RoleState(
      loading: loading ?? this.loading,
      createRoleLoading: createRoleLoading ?? this.createRoleLoading,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      features: features ?? this.features,
      roles: roles ?? this.roles,
      success: success ?? false,
      selectedRole: selectedRole ?? selectedRole,
    );
  }
}
