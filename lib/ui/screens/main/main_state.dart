import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'main_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class MainState with _$MainState implements ExceptionState {
  const factory MainState({
    Exception? exception,
    @Default(false) bool authInProgress,
  }) = _MainState;
}
