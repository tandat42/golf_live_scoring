import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_input_state.dart';
import 'package:golf_live_scoring/ui/utils/exception_utils.dart';

class GolfTextField extends StatefulWidget {
  const GolfTextField({
    super.key,
    required this.cubit,
    this.obscureText = false,
    this.hint = "",
  });

  final GolfTextFieldCubit cubit;
  final bool obscureText;
  final String hint;

  @override
  State<GolfTextField> createState() => _GolfTextFieldState();
}

class _GolfTextFieldState extends State<GolfTextField> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GolfTextFieldCubit, GolfTextInputState>(
        bloc: widget.cubit,
        builder: (context, state) {
          return TextField(
            controller: widget.cubit.controller,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              hintText: widget.hint,
              errorText: ExceptionUtils.getText(state.exception),
            ),
          );
        });
  }
}
