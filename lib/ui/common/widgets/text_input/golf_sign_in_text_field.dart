import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/exception_utils.dart';

class GolfSignInTextField extends StatelessWidget {
  const GolfSignInTextField({
    super.key,
    required this.cubit,
    required this.prefixIcon,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.none,
    this.onChanged,
  });

  final GolfTextFieldCubit cubit;
  final String prefixIcon;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final TextInputAction textInputAction;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return SizedBox(
      height: 45,
      child: BlocBuilder<GolfTextFieldCubit, GolfTextFieldState>(
          bloc: cubit,
          builder: (context, state) {
            final border = OutlineInputBorder(
              borderSide: BorderSide(color: colors.line),
              borderRadius: BorderRadius.circular(16),
            );

            return TextFormField(
              controller: cubit.controller,
              cursorColor: textStyles.input.color,
              style: textStyles.input,
              minLines: 1,
              maxLines: 1,
              readOnly: state.readOnly,
              obscureText: obscureText,
              obscuringCharacter: "*",
              enableSuggestions: !obscureText,
              autocorrect: !autocorrect,
              keyboardType: keyboardType,
              scrollPadding: const EdgeInsets.all(20.0),
              textCapitalization: capitalization,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.background2,
                  contentPadding: const EdgeInsetsDirectional.only(end: 14),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  prefixIcon: Container(
                    margin: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 0),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(prefixIcon, width: 26, height: 26),
                  ),
                  prefixIconConstraints: BoxConstraints.tight(Size(54, double.infinity)),
                  errorText: ExceptionUtils.getText(state.exception)),
              onChanged: onChanged,
            );
          }),
    );
  }
}
