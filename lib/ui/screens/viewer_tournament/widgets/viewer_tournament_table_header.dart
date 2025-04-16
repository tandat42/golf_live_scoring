import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class ViewerTournamentTableHeader extends StatelessWidget {
  const ViewerTournamentTableHeader({
    super.key,
    required this.items,
  });

  final List<ViewerTournamentTableTopItem>? items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    final items = this.items;

    final borderSide = BorderSide(color: colors.line);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.background2,
        border: Border(left: borderSide, top: borderSide, right: borderSide),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (items != null && items.isNotEmpty) ...[
            const SizedBox(height: 7),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 26,
              children: items
                  .map(
                    (i) => Expanded(
                      flex: i.flex,
                      child: Align(
                        alignment: i.alignment,
                        child: Text(i.text,
                            style: textStyles.body1.copyWith(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 10),
            Divider(height: 1, thickness: 1, indent: 9, endIndent: 9),
            const SizedBox(height: 8),
          ] else
            const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ViewerTournamentTableTopItem {
  ViewerTournamentTableTopItem(
    this.text,
    this.flex, [
    this.alignment = AlignmentDirectional.center,
  ]);

  final String text;
  final int flex;
  final AlignmentDirectional alignment;
}
