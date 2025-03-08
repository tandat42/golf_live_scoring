import 'dart:async';

import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

mixin ExceptionDisplayer<T extends StatefulWidget> on State<T> {
  Map<Stream, StreamSubscription> subscriptions = {};

  void listenExceptions<V extends ExceptionState>(Stream<V> stream) {
    if (subscriptions.containsKey(stream)) return;

    subscriptions[stream] = stream
        .map((s) => s.exception)
        .where((e) => e != null)
        .distinct()
        .listen(showExceptionMessage);
  }

  void cancelListeningExceptions<V extends ExceptionState>(Stream<V> stream) {
    subscriptions.remove(stream)?.cancel();
  }

  @override
  void dispose() {
    for (final subscriptions in subscriptions.values) {
      subscriptions.cancel();
    }

    super.dispose();
  }

  void showExceptionMessage(Exception? exception) {
    //todo
    print('==== ExceptionDisplayer ====\n    showExceptionMessage: $exception|${runtimeType}');
  }
}
