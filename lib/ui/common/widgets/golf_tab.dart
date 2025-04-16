import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class GolfTab extends StatelessWidget {
  const GolfTab({
    super.key,
    required this.text,
    required this.space,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  final String text;
  final double space;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final selected = index == selectedIndex;
    final textStyle = selected
                  ? textStyles.title2
                  : textStyles.title2.copyWith(color: colors.textPrimary);
    final color = selected ? colors.accent1 : null;

    return GestureDetector(
      onTap: () => onTap(index),
      child: ColoredBox(
        color: Colors.transparent,
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                text,
                style: textStyle,
              ),
              SizedBox(height: space),
              Container(height: 5, color: color)
            ],
          ),
        ),
      ),
    );
  }
}
