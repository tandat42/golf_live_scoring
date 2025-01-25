
import 'dart:async';

import 'package:golf_live_scoring/core/common/initializable.dart';
import 'package:golf_live_scoring/core/data/auth_status.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@singleton
class AppSignInListener with Initializable {
  AppSignInListener(this._router, this._authService);

  final GolfRouter _router;
  final AuthService _authService;

  late final StreamSubscription<List<AuthStatus>> _signInStatusSubscription;

  void init() {
    if (initialized) return;

    _signInStatusSubscription =
        _authService.signedInStatusStream.distinct().bufferCount(3, 1).listen(_onSignInStatusChange);

    initialized = true;
  }

  @disposeMethod
  Future<void> dispose() async {
    _signInStatusSubscription.cancel();
  }

  void _onSignInStatusChange(List<AuthStatus> event) {
    if (event.length == 3 &&
        event[0] == AuthStatus.unsigned &&
        event[1] == AuthStatus.inProgress &&
        event[2] == AuthStatus.signed) {
      _router.replaceAll([MainRoute()]);
    } else if (event.length == 3 &&
        event[0] == AuthStatus.signed &&
        event[1] == AuthStatus.inProgress &&
        event[2] == AuthStatus.unsigned) {
      _router.replaceAll([SplashRoute()]);
    }
  }
}
