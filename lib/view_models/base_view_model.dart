import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BaseViewModel<S> extends Notifier<S> {
  @override
  S build();

  Future<T?> runSafely<T>(
    AsyncValueGetter<T> action, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) {
        await EasyLoading.show();
      }

      return await action.call();
    } catch (e, s) {
      log('BASE: $e', stackTrace: s);
      onError(e.toString().replaceAll('Exception:', ''));
      return null;
    } finally {
      if (showLoading) {
        unawaited(EasyLoading.dismiss());
      }
    }
  }

  @mustCallSuper
  void onError(String message) {
    EasyLoading.showError(message);
  }

  @mustCallSuper
  void init() {
    log('$runtimeType INITIALIZED', name: 'RIVERPOD');
  }

  @mustCallSuper
  void dispose() {
    log('$runtimeType DISPOSED', name: 'RIVERPOD');
  }
}