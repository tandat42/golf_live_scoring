import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';

part 'golf_dropdown_field_state.freezed.dart';

@Freezed(toJson: false, fromJson: false, genericArgumentFactories: true)
abstract class GolfDropdownFieldState<V> with _$GolfDropdownFieldState<V> implements ExceptionState {
  const factory GolfDropdownFieldState({
    Exception? exception,
    V? value,
    required List<V> values,
    @Default(false) bool enabled,
  }) = _GolfDropdownFieldState<V>;
}
