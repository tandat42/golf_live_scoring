import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/exceptions/sign_in_exception.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignInCubit extends Cubit<SignInState> with Initializable {
  SignInCubit(
    this._router,
    this._authService,
    this._dataService,
  ) : super(SignInState());

  final GolfRouter _router;
  final AuthService _authService;
  final DataService _dataService;

  late final GolfTextFieldCubit emailCubit;
  late final GolfTextFieldCubit passwordCubit;

  late final StreamSubscription<bool> _authProgressSubscription;

  void init() {
    print('SignInCubit.init: initialized: $initialized');
    if (initialized) return;

    emailCubit = GolfTextFieldCubit();
    passwordCubit = GolfTextFieldCubit();

    _authProgressSubscription =
        _authService.authProgressStream.listen((p) => emit(state.copyWith(inProgress: p)));

    initialized = true;
  }

  @override
  Future<void> close() async {
    print('SignInCubit.close: closed: $isClosed');
    _authProgressSubscription.cancel();

    emailCubit.close();
    passwordCubit.close();

    await super.close();
  }

  Future<void> signInWithEmail() {
    return _signIn(() => _authService.signInWithEmail(emailCubit.text, passwordCubit.text));
  }

  Future<void> signInWithGoogle() {
    return _signIn(() => _authService.signInWithGoogle());
  }

  Future<void> signInWithApple() async {
    //todo
  }

  Future<void> forgotPassword() async {
    //todo
  }

  Future<void> _signIn(Future<void> Function() signInAction) async {
    try {
      print('SignInCubit._signIn: start');
      await signInAction.call();
      //sign in is processed by AppAuthListener

      print('SignInCubit._signIn: sign in step completed=${_authService.isSignedIn()}');

      if (!_authService.isSignedIn()) {
        throw SignInException();
      }

      while (!isClosed) {
        try {
          print('SignInCubit._signIn: getting profile');
          await _dataService.loadSetup();
          await _dataService.loadProfile();
          print('SignInCubit._signIn: completed');
          return;
        } on Exception catch (e) {
          print('SignInCubit._signIn: profile exception=$e');
          emit(state.copyWith(exception: e));
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    } on Exception catch (e) {
      print('SignInCubit._signIn: main exception=$e');
      emit(state.copyWith(exception: e));
    }
  }

  void signUp() {
    _router.push(SignUpRoute());
  }
}
