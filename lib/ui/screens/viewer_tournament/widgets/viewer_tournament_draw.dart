import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/ui/common/widgets/universal_image.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_cubit.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_state.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_bottom_ads.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_footer.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_header.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_title.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/score_extensions.dart';

class ViewerTournamentDraw extends StatelessWidget {
  const ViewerTournamentDraw({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final tournamentInfo = context.select((ViewerTournamentCubit c) => c.state.tournamentInfo);
    final flights = context.select((ViewerTournamentCubit c) => c.state.flights);

    if (flights == null || tournamentInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      itemCount: flights.length + 4,
      separatorBuilder: (context, i) {
        return i > 1 && i < flights.length + 1
            ? Divider(color: colors.line, height: 1, thickness: 1, indent: 10, endIndent: 10)
            : SizedBox.shrink();
      },
      itemBuilder: (context, i) {
        if (i == 0) {
          return ViewerTournamentTitle(tournamentInfo: tournamentInfo);
        } else if (i == 1) {
          return ViewerTournamentTableHeader(items: null);
        } else if (i == flights.length + 2) {
          return ViewerTournamentTableFooter();
        } else if (i == flights.length + 3) {
          return ViewerTournamentBottomAds();
        } else {
          final index = i - 2;
          final flightInfo = flights[index];
          return Column(
            children: [
              _ViewerTournamentDrawFlightRow(
                flightInfo,
                specificBackground: index.isOdd,
              ),
            ],
          );
        }
      },
    );
  }
}

class _ViewerTournamentDrawFlightRow extends StatelessWidget {
  const _ViewerTournamentDrawFlightRow(
    this.flightInfo, {
    required this.specificBackground,
  });

  final FlightInfo flightInfo;
  final bool specificBackground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final participants = flightInfo.participants;

    final borderSide = BorderSide(color: colors.line);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background2,
        border: Border(left: borderSide, right: borderSide),
      ),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: specificBackground ? colors.background3 : colors.background2,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _ViewerTournamentDrawTeeSection(flightInfo),
                for (final participant in participants) ...[
                  VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: colors.line,
                    indent: 0,
                    endIndent: 0,
                  ),
                  _ViewerTournamentDrawParticipantSection(
                    participant,
                    flightInfo.clubsById[participant.profile.clubId]!,
                  )
                ]
              ],
            ),
          )),
    );
  }
}

class _ViewerTournamentDrawTeeSection extends StatelessWidget {
  const _ViewerTournamentDrawTeeSection(this.flightInfo);

  final FlightInfo flightInfo;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return Expanded(
      flex: 180,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              flightInfo.flight.name ?? '',
              style: textStyles.title2.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              flightInfo.flight.teeName ?? '',
              style: textStyles.title2.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewerTournamentDrawParticipantSection extends StatelessWidget {
  const _ViewerTournamentDrawParticipantSection(this.participant, this.club);

  final Participant participant;
  final Club? club;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final profile = participant.profile;
    final image = profile.image;
    final hcp = profile.hcp;

    return Expanded(
      flex: 250,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: UniversalImage(image, width: 90, height: 90, fit: BoxFit.contain),
              )
            else
              const SizedBox(width: 90, height: 90),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.firstName}\n${profile.lastName}',
                    style: textStyles.body2.copyWith(color: colors.accent1),
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${hcp != null ? l10n.viewerTournamentsTableHcpValue(hcp > 0 ? '+$hcp' : hcp.toString()) : ''} | '
                    '${l10n.viewerTournamentsTablePoints(participant.totalNetto())}',
                    style: textStyles.input.copyWith(fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UniversalImage(club?.icon, width: 20, height: 20, fit: BoxFit.contain),
                      const SizedBox(width: 6),
                      Text(
                        club?.name ?? '',
                        style: textStyles.input.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
