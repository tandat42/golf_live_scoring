import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';
import 'package:golf_live_scoring/ui/common/data/progress_state.dart';

part 'sign_up_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class SignUpState with _$SignUpState implements ExceptionState, ProgressState {
  const factory SignUpState({
    Exception? exception,
    @Default(false) bool signedIn,
    @Default(false) bool inProgress,
  }) = _SignUpState;
}
