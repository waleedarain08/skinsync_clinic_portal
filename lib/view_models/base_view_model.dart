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
      final response = await action.call();
            await EasyLoading.dismiss();
      return response ;

       
    } catch (e, s) {
      log('BASE: $e', stackTrace: s);
      onError(e.toString().replaceAll('Exception:', ''));
      return null;
    }
  }

  @mustCallSuper
  void onError(String message) {
   
    EasyLoading.showError( message);
    
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