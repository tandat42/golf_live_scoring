import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/ui/common/golf_theme.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.icon,
    this.enabled = true,
    this.type = PrimaryButtonType.light,
    required this.onPressed,
  });

  final String text;
  final String? icon;
  final bool enabled;
  final PrimaryButtonType type;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;
    final colors = context.colors;

    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
        backgroundColor: WidgetStateProperty.all(_getBackgroundColor(colors)),
        fixedSize: WidgetStateProperty.all(Size(double.infinity, 45)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 17),
          if (icon != null) ...[
            SvgPicture.asset(icon!, width: 20, height: 20),
            const SizedBox(width: 17),
          ],
          Expanded(child: Text(text, textAlign: TextAlign.center, style: textStyles.buttonDefault)),
          const SizedBox(width: 17),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ColorsExtension colors) {
    return switch (type) {
      PrimaryButtonType.light => colors.accent1,
      PrimaryButtonType.dark => colors.accent2,
    };
  }
}

enum PrimaryButtonType {
  light,
  dark,
}
