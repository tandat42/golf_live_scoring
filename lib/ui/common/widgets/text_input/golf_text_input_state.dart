import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'golf_text_input_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GolfTextInputState with _$GolfTextInputState implements ExceptionState {
  const factory GolfTextInputState({
    Exception? exception,
  }) = _GolfTextInputState;
}
