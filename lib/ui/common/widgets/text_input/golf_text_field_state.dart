import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'golf_text_field_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GolfTextFieldState with _$GolfTextFieldState implements ExceptionState {
  const factory GolfTextFieldState({
    Exception? exception,
    @Default(false) bool readOnly,
  }) = _GolfTextFieldState;
}
