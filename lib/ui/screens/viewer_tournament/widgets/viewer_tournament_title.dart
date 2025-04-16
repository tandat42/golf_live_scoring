import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:intl/intl.dart';

class ViewerTournamentTitle extends StatelessWidget {
  const ViewerTournamentTitle({
    super.key,
    required this.tournamentInfo,
  });

  final TournamentInfo tournamentInfo;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyles = context.textStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text(
          tournamentInfo.name ?? '',
          style: textStyles.title1,
        ),
        const SizedBox(height: 10),
        Text(
          [
            if (tournamentInfo.round != null)
              l10n.viewerTournamentsTitleRound(tournamentInfo.round!),
            if (tournamentInfo.startDate != null)
              DateFormat(l10n.commonDateLongFormat).format(tournamentInfo.startDate!),
            l10n.viewerTournamentsTitleHoles(tournamentInfo.field.holes.length),
          ].join(' | ').toUpperCase(),
          style: textStyles.title2.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
