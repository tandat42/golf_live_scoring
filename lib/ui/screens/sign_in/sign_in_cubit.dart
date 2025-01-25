import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/common/initializable.dart';
import 'package:golf_live_scoring/core/data/auth_status.dart';
import 'package:golf_live_scoring/core/data/exceptions/sign_in_exception.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
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
    this.emailCubit,
    this.passwordCubit,
  ) : super(SignInState());

  final GolfRouter _router;
  final AuthService _authService;

  final GolfTextFieldCubit emailCubit;
  final GolfTextFieldCubit passwordCubit;

  late final StreamSubscription<AuthStatus> _signInProgressSubscription;

  void init() {
    if (initialized) return;

    _signInProgressSubscription =
        _authService.signedInStatusStream.listen((e) => emit(state.copyWith(inProgress: e == AuthStatus.inProgress)));

    initialized = true;
  }

  @override
  Future<void> close() async {
    _signInProgressSubscription.cancel();

    await super.close();
  }

  Future<void> signInWithEmail() {
    return _signIn(() async => _authService.signInWithEmail(emailCubit.text, passwordCubit.text));
  }

  Future<void> signInWithGoogle() {
    return _signIn(() async => _authService.signInWithGoogle());
  }

  Future<void> _signIn(Future<void> Function() signInAction) async {
    try {
      await signInAction.call();
      //sign in is processed by AppSignInListener

      if (!_authService.isSignedIn()) {
        throw SignInException();
      }
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(exception: e));
    }
  }

  void signUp() {
    _router.push(SignUpRoute());
  }
}
