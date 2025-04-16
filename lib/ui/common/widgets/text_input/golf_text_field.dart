import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/exception_utils.dart';

class GolfTextField extends StatelessWidget {
  const GolfTextField({
    super.key,
    required this.cubit,
    this.hint = "",
    this.prefixIcon,
    this.obscureText = false,
    this.autocorrect = true,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.none,
    this.formatters,
  });

  final GolfTextFieldCubit cubit;
  final String hint;
  final String? prefixIcon;
  final bool obscureText;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? formatters;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return SizedBox(
      height: 56,
      child: BlocBuilder<GolfTextFieldCubit, GolfTextFieldState>(
          bloc: cubit,
          builder: (context, state) {
            final border = OutlineInputBorder(
              borderSide: BorderSide(color: colors.line),
              borderRadius: BorderRadius.circular(12),
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
              inputFormatters: formatters,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: colors.background2,
                  labelText: hint,
                  labelStyle: textStyles.label,
                  floatingLabelStyle: textStyles.floatingLabel,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: prefixIcon != null
                      ? const EdgeInsetsDirectional.only(end: 12)
                      : const EdgeInsets.symmetric(horizontal: 12),
                  border: border,
                  focusedBorder: border,
                  enabledBorder: border,
                  prefixIcon: prefixIcon != null
                      ? Container(
                          margin: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 0),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(prefixIcon!, width: 26, height: 26),
                        )
                      : null,
                  prefixIconConstraints: BoxConstraints.tight(Size(54, double.infinity)),
                  errorText: ExceptionUtils.getText(state.exception)),
            );
          }),
    );
  }
}
