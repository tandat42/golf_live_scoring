import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/core/services/main_service.dart';
import 'package:golf_live_scoring/ui/app/app_sign_in_listener.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._router,
    this._mainService,
    this._authService,
    this._appSignInListener,
  ) : super(SplashState());

  final GolfRouter _router;

  final MainService _mainService;
  final AuthService _authService;

  final AppSignInListener _appSignInListener;

  Future<void> init() async {
    while (true) {
      try {
        await Future.wait([
          Future.delayed(const Duration(seconds: 1)),
          () async {
            await _mainService.init();
            await _authService.init();

            _appSignInListener.init();
          }.call(),
        ]);

        break;
      } on Exception catch (e) {
        print(e);
        emit(state.copyWith(exception: e));
      }
    }

    if (isClosed) return;

    if (_authService.isSignedIn()) {
      _router.replace(MainRoute());
    } else {
      _router.replace(SignInRoute());
    }
  }
}
