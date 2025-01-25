import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'main_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class MainState with _$MainState implements ExceptionState {
  const factory MainState({
    Exception? exception,
  }) = _MainState;
}
