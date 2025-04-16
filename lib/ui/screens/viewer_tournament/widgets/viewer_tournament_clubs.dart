import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/ui/common/widgets/universal_image.dart';
import 'package:golf_live_scoring/ui/gen/l10n.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_cubit.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_state.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_bottom_ads.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_footer.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_header.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_row.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_title.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/image_utils.dart';
import 'package:golf_live_scoring/ui/utils/score_extensions.dart';

class ViewerTournamentClubs extends StatefulWidget {
  const ViewerTournamentClubs({
    super.key,
  });

  @override
  State<ViewerTournamentClubs> createState() => _ViewerTournamentClubsState();
}

class _ViewerTournamentClubsState extends State<ViewerTournamentClubs> {
  String? _selectedClubId;

  void _onClubTap(String club) {
    setState(() {
      _selectedClubId = club != _selectedClubId ? club : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournamentInfo = context.select((ViewerTournamentCubit c) => c.state.tournamentInfo);
    final clubsScoresInfo = context.select((ViewerTournamentCubit c) => c.state.clubsScores);

    if (clubsScoresInfo == null || tournamentInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    final l10n = context.l10n;

    return ListView.builder(
      itemCount: clubsScoresInfo.length + 4,
      itemBuilder: (context, i) {
        if (i == 0) {
          return ViewerTournamentTitle(tournamentInfo: tournamentInfo);
        } else if (i == 1) {
          return ViewerTournamentTableHeader(items: _getTitleItems(l10n));
        } else if (i == clubsScoresInfo.length + 2) {
          return ViewerTournamentTableFooter();
        } else if (i == clubsScoresInfo.length + 3) {
          return ViewerTournamentBottomAds();
        } else {
          final index = i - 2;
          final clubScore = clubsScoresInfo[index];
          return Column(
            children: [
              ViewerTournamentTableRow(
                specificBackground: index.isOdd,
                onTap: () => _onClubTap(clubScore.club.id),
                items: getRowItems(index, clubScore),
              ),
              if (clubScore.club.id == _selectedClubId)
                _ViewerTournamentClubDetailsRow(clubScore),
            ],
          );
        }
      },
    );
  }

  List<ViewerTournamentTableTopItem> _getTitleItems(GolfLocalizations l10n) {
    return [
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTablePos, 52),
      ViewerTournamentTableTopItem(
          l10n.viewerTournamentsTableTeamCountry, 308, AlignmentDirectional.centerStart),
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTablePlayedHoles, 156),
      // todo check if rounds only can be 3
      for (int r = 0; r < 3; r++)
        ViewerTournamentTableTopItem(l10n.viewerTournamentsTableRound(r + 1), 108),
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTableTotal, 176),
    ];
  }

  List<ViewerTournamentTableRowItem> getRowItems(int index, ClubScoreInfo clubScore) {
    final club = clubScore.club;
    return [
      ViewerTournamentTableRowItem(52, text: (index + 1).toString().padLeft(2)),
      ViewerTournamentTableRowItem(
        308,
        text: club.name ?? '',
        icon: ImageUtils.getFlagUrl(club.countryCode),
      ),
      ViewerTournamentTableRowItem(156, text: clubScore.playedHoles.toString()),
      // todo check if rounds only can be 3
      for (int r = 0; r < 3; r++)
        ViewerTournamentTableRowItem(108, text: clubScore.roundTotals[r].toString()),
      ViewerTournamentTableRowItem(
        176,
        text: '${clubScore.parRelativeTotal > 0 ? '+' : ''}${clubScore.parRelativeTotal} '
            '(${clubScore.total})',
        bold: true,
      ),
    ];
  }
}

class _ViewerTournamentClubDetailsRow extends StatelessWidget {
  const _ViewerTournamentClubDetailsRow(this.clubScore);

  final ClubScoreInfo clubScore;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final participants = clubScore.participants;

    final borderSide = BorderSide(color: colors.line);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background2,
        border: Border(left: borderSide, right: borderSide),
      ),
      child: Container(
        height: 162,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.background2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.accent1, width: 2),
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: participants.length + 1,
          separatorBuilder: (context, _) => VerticalDivider(
            thickness: 1,
            color: colors.line,
            indent: 22,
            endIndent: 22,
          ),
          itemBuilder: (context, i) => switch (i) {
            0 => _ViewerTournamentClubDetailsSection(clubScore),
            _ => _ViewerTournamentClubDetailsParticipantSection(participants[i - 1]),
          },
        ),
      ),
    );
  }
}

class _ViewerTournamentClubDetailsSection extends StatelessWidget {
  const _ViewerTournamentClubDetailsSection(this.clubScore);

  final ClubScoreInfo clubScore;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    final icon = clubScore.club.icon;

    return SizedBox(
      width: 248,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 3),
          if (icon != null)
            UniversalImage(icon, width: 40, height: 40, fit: BoxFit.contain)
          else
            const SizedBox(width: 40, height: 40),
          const SizedBox(height: 10),
          Text(
            clubScore.club.name ?? '',
            style: textStyles.title2.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5.5),
          Text(
            '${clubScore.parRelativeTotal > 0 ? '+' : ''}${clubScore.parRelativeTotal} '
            '(${clubScore.total})',
            style: textStyles.body1.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ViewerTournamentClubDetailsParticipantSection extends StatelessWidget {
  const _ViewerTournamentClubDetailsParticipantSection(this.participant);

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyles = context.textStyles;

    final profile = participant.profile;
    final image = profile.image;
    final hcp = profile.hcp;

    return SizedBox(
      width: 270,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: UniversalImage(image, width: 106, height: 106, fit: BoxFit.contain),
            )
          else
            const SizedBox(width: 106, height: 106),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                Text(
                  '${l10n.viewerTournamentsTablePoints(participant.totalNetto())}:'
                  '\n${List.generate(3, (i) => participant.roundTotalNetto(i).toString()).join('+')}',
                  style: textStyles.title2.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  '${profile.firstName} ${profile.lastName}'
                  '\n${hcp != null ? l10n.viewerTournamentsTableHcpValue(hcp > 0 ? '+$hcp' : hcp.toString()) : ''}',
                  style: textStyles.input,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
