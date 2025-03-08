import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_state.dart';
import 'package:injectable/injectable.dart';

class GolfTextFieldCubit extends Cubit<GolfTextFieldState> {
  GolfTextFieldCubit({@factoryParam String? initialText}) : super(GolfTextFieldState()) {
    controller.text = initialText ?? "";
  }

  final controller = TextEditingController();

  void setText(String? text) {
    controller.text = text ?? "";
  }

  void setException(Exception? exception) {
    emit(state.copyWith(exception: exception));
  }

  String get text => controller.text.trim();
}


