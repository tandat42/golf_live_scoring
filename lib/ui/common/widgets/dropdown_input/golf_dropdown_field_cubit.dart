import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/ui/common/widgets/dropdown_input/golf_dropdown_field_state.dart';
import 'package:injectable/injectable.dart';

class GolfDropdownFieldCubit<V> extends Cubit<GolfDropdownFieldState<V>> {
  GolfDropdownFieldCubit({
    @factoryParam V? initialValue,
    List<V> values = const [],
  }) : super(GolfDropdownFieldState(value: initialValue, values: values));

  void setValue(V? value) {
    emit(state.copyWith(value: value));
  }

  void update(V? value, List<V>? values) {
    emit(state.copyWith(value: value, values: values ?? []));
  }

  void setException(Exception? exception) {
    emit(state.copyWith(exception: exception));
  }

  V? get value => state.value;
}
