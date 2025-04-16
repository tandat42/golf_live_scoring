import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

class ViewerTournamentTableFooter extends StatelessWidget {
  const ViewerTournamentTableFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final borderSide = BorderSide(color: colors.line);
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: colors.background2,
        border: Border(left: borderSide, right: borderSide, bottom: borderSide),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
    );
  }
}