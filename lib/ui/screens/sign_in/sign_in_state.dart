import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';
import 'package:golf_live_scoring/ui/common/data/progress_state.dart';

part 'sign_in_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class SignInState with _$SignInState implements ExceptionState, ProgressState {
  const factory SignInState({
    Exception? exception,
    @Default(false) bool inProgress,
  }) = _SignInState;
}
