import 'dart:async';

import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppAuthListener with Initializable {
  AppAuthListener(this._router, this._dataService);

  final GolfRouter _router;
  final DataService _dataService;

  late final StreamSubscription<Profile?> _profileSubscription;

  Profile? _prevProfile = null;

  void init() {
    if (initialized) return;

    _profileSubscription =
        _dataService.profileStream.distinct().listen(_onProfileChange);

    initialized = true;
  }

  @disposeMethod
  Future<void> dispose() async {
    _profileSubscription.cancel();
  }

  void _onProfileChange(Profile? newProfile) {
    final prevProfile = _prevProfile;

    print('AppAuthListener._onProfileChange: $prevProfile|$newProfile');

    if ((prevProfile == null && newProfile != null) ||
        (prevProfile != null && newProfile != null && prevProfile.isEmpty && !newProfile.isEmpty)) {
      print('AppAuthListener._onProfileChange: signed in: ${newProfile.isEmpty}');

      if (newProfile.isEmpty) {
        _router.replaceAll([SignUpRoute()]);
      } else {
        _router.replaceAll([MainRoute()]);
      }
    } else if (prevProfile != null && newProfile == null) {
      print('AppAuthListener._onProfileChange: signed out');
      _router.replaceAll([SplashRoute()]);
    }
  }
}
