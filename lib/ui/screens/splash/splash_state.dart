import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'splash_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class SplashState with _$SplashState implements ExceptionState {
  const factory SplashState({
    Exception? exception,
  }) = _SplashStatePerson;
}
