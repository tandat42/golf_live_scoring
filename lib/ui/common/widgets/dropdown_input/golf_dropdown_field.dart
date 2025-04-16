import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/ui/common/widgets/dropdown_input/golf_dropdown_field_cubit.dart';
import 'package:golf_live_scoring/ui/common/widgets/dropdown_input/golf_dropdown_field_state.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/exception_utils.dart';

class GolfDropdownField<V> extends StatelessWidget {
  const GolfDropdownField({
    super.key,
    required this.cubit,
    this.hint = "",
    required this.valueToString,
  });

  final GolfDropdownFieldCubit<V> cubit;
  final String hint;

  final String? Function(V) valueToString;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return SizedBox(
      height: 56,
      child: BlocBuilder<GolfDropdownFieldCubit<V>, GolfDropdownFieldState<V>>(
          bloc: cubit,
          builder: (context, state) {
            final border = OutlineInputBorder(
              borderSide: BorderSide(color: colors.line),
              borderRadius: BorderRadius.circular(12),
            );

            return DropdownButtonFormField<V>(
              style: textStyles.input,
              decoration: InputDecoration(
                filled: true,
                fillColor: colors.background2,
                labelText: hint,
                labelStyle: textStyles.label,
                floatingLabelStyle: textStyles.floatingLabel,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: border,
                focusedBorder: border,
                enabledBorder: border,
                prefixIconConstraints: BoxConstraints.tight(Size(54, double.infinity)),
                errorText: ExceptionUtils.getText(state.exception),
              ),
              icon: Container(
                margin: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 0),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                    Assets.icons.arrowTriangleDown,
                    width: 16,
                    height: 11
                ),
              ),
              items: state.values
                  .map(
                    (v) => DropdownMenuItem(
                      value: v,
                      child: Text(valueToString.call(v) ?? '', style: textStyles.input),
                    ),
                  )
                  .toList(),
              onChanged: cubit.setValue,
            );
          }),
    );
  }
}
