import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/screens/main/main_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class MainCubit extends Cubit<MainState> {
  MainCubit(
    this._router,
    this._dataService,
    this._authService,
  ) : super(MainState());

  final GolfRouter _router;
  final DataService _dataService;
  final AuthService _authService;

  late final StreamSubscription<bool> _authProgressSubscription;

  Future<void> init() async {
    _authProgressSubscription =
        _authService.authProgressStream.listen((p) => emit(state.copyWith(authInProgress: p)));
  }

  @override
  Future<void> close() {
    _authProgressSubscription.cancel();

    return super.close();
  }

  //todo move to separate controller
  void signOut() {
    try {
      _authService.signOut();
      _dataService.reset();
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }
}