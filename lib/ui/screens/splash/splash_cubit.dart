import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/services/app_service.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/ui/app/app_auth_listener.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_state.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._router,
    this._appService,
    this._authService,
    this._dataService,
    this._appAuthListener,
  ) : super(SplashState());

  final GolfRouter _router;

  final AppService _appService;
  final AuthService _authService;
  final DataService _dataService;

  final AppAuthListener _appAuthListener;

  bool _started = false;

  Future<void> init() async {
    if (_started) return;
    _started = true;

    while (true) {
      try {
        await Future.wait([
          Future.delayed(const Duration(seconds: 1)),
          () async {
            await _appService.init();
            await _authService.init();
            await _dataService.init();

            _appAuthListener.init();
          }.call(),
        ]);

        break;
      } on Exception catch (e) {
        print('SplashCubit.init: initialization: exception=$e');
        emit(state.copyWith(exception: e));
      }
    }

    if (isClosed) return;

    _appService.readyToWork = true;

    if (_authService.isSignedIn()) {
      final profile = _dataService.profile;
      print('SplashCubit.init: signed in: profile?.isEmpty=${profile?.isEmpty}');
      if (profile?.isEmpty ?? true) {
        _router.replaceAll([SignUpRoute()]);
      } else {
        _router.replaceAll([MainRoute()]);
      }
    } else {
      print('SplashCubit.init: signed out');
      _router.replace(SignInRoute());
    }
  }
}
