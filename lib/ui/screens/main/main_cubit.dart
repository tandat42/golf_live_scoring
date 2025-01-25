import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MainCubit extends Cubit<SplashState> {
  MainCubit(this._router) : super(SplashState());

  final GolfRouter _router;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!isClosed) {
      _router.replace(SignInRoute());
    }
  }
}
