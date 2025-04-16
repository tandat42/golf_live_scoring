import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/common/widgets/universal_image.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class ViewerTournamentTableRow extends StatelessWidget {
  const ViewerTournamentTableRow({
    super.key,
    required this.specificBackground,
    required this.onTap,
    required this.items,
  });

  final bool specificBackground;
  final VoidCallback onTap;
  final List<ViewerTournamentTableRowItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final borderSide = BorderSide(color: colors.line);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.background2,
          border: Border(left: borderSide, right: borderSide),
        ),
        child: Container(
          color: specificBackground ? colors.background3 : colors.background2,
          padding: const EdgeInsets.symmetric(vertical: 3.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 26,
            children: items.map(
              (i) {
                final textStyle =
                    i.bold ? textStyles.title1.copyWith(fontSize: 16) : textStyles.input;
                final text = i.text;
                final icon = i.icon;
                return Expanded(
                  flex: i.flex,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null)
                        UniversalImage(icon, width: 25, height: 25, fit: BoxFit.contain),
                      if (text != null && icon != null) const SizedBox(width: 32),
                      if (text != null)
                        Expanded(
                          child: Text(text, style: textStyle, textAlign: i.textAlign),
                        )
                    ],
                  ),
                );
              },
            ).toList(),
          ),
        ),
      ),
    );
  }
}

class ViewerTournamentTableRowItem {
  ViewerTournamentTableRowItem(
    this.flex, {
    this.text,
    this.bold = false,
    this.icon,
    this.textAlign = TextAlign.center,
  });

  final String? text;
  final int flex;
  final bool bold;
  final String? icon;
  final TextAlign? textAlign;
}
