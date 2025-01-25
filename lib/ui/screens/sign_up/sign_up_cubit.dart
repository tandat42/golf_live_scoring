import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/common/initializable.dart';
import 'package:golf_live_scoring/core/data/exceptions/sign_up_exception.dart';
import 'package:golf_live_scoring/core/data/auth_status.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_state.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignUpCubit extends Cubit<SignUpState> with Initializable {
  SignUpCubit(
    this._authService,
    this.emailCubit,
    this.passwordCubit,
  ) : super(SignUpState());

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

  Future<void> signUpWithEmail() async {
    try {
      await _authService.signUpWithEmail(emailCubit.text, passwordCubit.text);
      //sign in is processed by AppSignInListener

      if (!_authService.isSignedIn()) {
        throw SignUpException();
      }
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(exception: e));
    }
  }
}
