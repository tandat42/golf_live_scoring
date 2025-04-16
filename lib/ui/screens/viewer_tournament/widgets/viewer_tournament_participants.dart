import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/ui/common/data/hole_result_type.dart';
import 'package:golf_live_scoring/ui/common/golf_theme.dart';
import 'package:golf_live_scoring/ui/common/widgets/universal_image.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/gen/l10n.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_cubit.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_state.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_bottom_ads.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_footer.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_header.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_table_row.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_title.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/score_extensions.dart';
import 'package:widgets_easier/widgets_easier.dart';

class ViewerTournamentParticipants extends StatefulWidget {
  const ViewerTournamentParticipants({
    super.key,
  });

  @override
  State<ViewerTournamentParticipants> createState() => _ViewerTournamentParticipantsState();
}

class _ViewerTournamentParticipantsState extends State<ViewerTournamentParticipants> {
  String? _selectedProfileId;
  int _selectedRound = 0;

  void _onParticipantTap(String profileId) {
    setState(() {
      _selectedProfileId = profileId != _selectedProfileId ? profileId : null;
    });
  }

  void _onRoundTap(int round) {
    setState(() {
      _selectedRound = round;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournamentInfo = context.select((ViewerTournamentCubit c) => c.state.tournamentInfo);
    final participants = context.select((ViewerTournamentCubit c) => c.state.participants);

    if (participants == null || tournamentInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    final l10n = context.l10n;

    return ListView.builder(
      itemCount: participants.length + 4,
      itemBuilder: (context, i) {
        if (i == 0) {
          return ViewerTournamentTitle(tournamentInfo: tournamentInfo);
        } else if (i == 1) {
          return ViewerTournamentTableHeader(items: _getTitleItems(l10n));
        } else if (i == participants.length + 2) {
          return ViewerTournamentTableFooter();
        } else if (i == participants.length + 3) {
          return ViewerTournamentBottomAds();
        } else {
          final index = i - 2;
          final participant = participants[index];
          return Column(
            children: [
              ViewerTournamentTableRow(
                specificBackground: index.isOdd,
                onTap: () => _onParticipantTap(participant.profile.id),
                items: getRowItems(index, participant),
              ),
              if (participant.profile.id == _selectedProfileId)
                _ViewerTournamentParticipantsDetailsRow(
                  participant,
                  tournamentInfo.field,
                  _selectedRound,
                  _onRoundTap,
                ),
            ],
          );
        }
      },
    );
  }

  List<ViewerTournamentTableTopItem> _getTitleItems(GolfLocalizations l10n) {
    return [
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTablePos, 52),
      ViewerTournamentTableTopItem('', 40),
      ViewerTournamentTableTopItem(
          l10n.viewerTournamentsTableName, 225, AlignmentDirectional.centerStart),
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTableHcp, 115),
      // todo check if rounds only can be 3
      for (int r = 0; r < 3; r++)
        ViewerTournamentTableTopItem(l10n.viewerTournamentsTableRound(r + 1), 132),
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTableTotal, 176),
      ViewerTournamentTableTopItem(l10n.viewerTournamentsTableHoles, 100),
    ];
  }

  List<ViewerTournamentTableRowItem> getRowItems(int index, ParticipantInfo participant) {
    final club = participant.club;
    final profile = participant.profile;
    return [
      ViewerTournamentTableRowItem(52, text: (index + 1).toString().padLeft(2)),
      ViewerTournamentTableRowItem(40, icon: club.icon),
      ViewerTournamentTableRowItem(
        225,
        text: '${profile.lastName} ${profile.firstName}',
        textAlign: TextAlign.start,
      ),
      ViewerTournamentTableRowItem(115, text: profile.hcp.toString()),
      // todo check if rounds only can be 3
      for (int r = 0; r < 3; r++)
        ViewerTournamentTableRowItem(132, text: participant.roundTotals[r].toString()),
      ViewerTournamentTableRowItem(176,
          text: '${participant.parRelativeTotal > 0 ? '+' : ''}${participant.parRelativeTotal} '
              '(${participant.total})',
          bold: true),
      ViewerTournamentTableRowItem(100, text: participant.playedHoles.toString()),
    ];
  }
}

class _ViewerTournamentParticipantsDetailsRow extends StatelessWidget {
  const _ViewerTournamentParticipantsDetailsRow(
      this.participant, this.field, this.selectedRound, this.onRoundTap);

  final ParticipantInfo participant;
  final Field field;
  final int selectedRound;

  final ValueSetter<int> onRoundTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final borderSide = BorderSide(color: colors.line);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background2,
        border: Border(left: borderSide, right: borderSide),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.background2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.accent1, width: 2),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 30),
              _buildLeftSection(context),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTopSection(context),
                    const SizedBox(height: 10),
                    _buildTable(context),
                  ],
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSection(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final profile = participant.profile;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      width: 186,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: UniversalImage(
              profile.image,
              width: 176,
              height: 176,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              l10n.viewerTournamentsSelectRound,
              style: textStyles.body2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (i) => GestureDetector(
                      onTap: () => onRoundTap(i),
                      child: SizedOverflowBox(
                        size: Size(58, 43),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.images.roundBackground,
                              width: 68.5,
                              height: 43,
                              colorFilter: ColorFilter.mode(
                                selectedRound == i ? colors.accent1 : colors.textSecondary,
                                BlendMode.srcATop,
                              ),
                            ),
                            Text(
                              (i + 1).toString(),
                              style: textStyles.buttonDefault,
                            ),
                          ],
                        ),
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    final profile = participant.profile;

    final resultInfoTextStyle = textStyles.body2.copyWith(fontSize: 10);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profile.lastName} ${profile.firstName}',
                style: textStyles.title1.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.accent1,
                ),
              ),
              Text(
                '${l10n.viewerTournamentsTableRound(selectedRound + 1)} - '
                '${l10n.viewerTournamentsTitleHoles(field.holes.length)} | '
                '${l10n.viewerTournamentsTableHcpValue(profile.hcp.toString())}',
                style: textStyles.title1.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  UniversalImage(participant.club.icon, width: 20, height: 20, fit: BoxFit.contain),
                  const SizedBox(width: 6),
                  Text(
                    '${participant.club.name}',
                    style: textStyles.input,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: _getDecoration(HoleResultType.eagle, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.viewerTournamentsEagle, style: resultInfoTextStyle),
                  const SizedBox(width: 16),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: _getDecoration(HoleResultType.birdie, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.viewerTournamentsBirdie, style: resultInfoTextStyle),
                  const SizedBox(width: 16),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: _getDecoration(HoleResultType.par, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.viewerTournamentsPar, style: resultInfoTextStyle),
                  const SizedBox(width: 16),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: _getDecoration(HoleResultType.bogey, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.viewerTournamentsBogey, style: resultInfoTextStyle),
                  const SizedBox(width: 16),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: _getDecoration(HoleResultType.doubleBogey, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(l10n.viewerTournamentsDoubleBogey, style: resultInfoTextStyle),
                  const SizedBox(width: 16),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    final colors = context.colors;

    final table = Table(
      columnWidths: Map.fromEntries(
        List.generate(4 + field.holesCount, (i) {
          final FlexColumnWidth width;
          if (i case 0) {
            width = FlexColumnWidth(112);
          } else if (i > 0 && i < field.inHolesCount + 1) {
            width = FlexColumnWidth(34);
          } else if (i == field.inHolesCount + 1) {
            width = FlexColumnWidth(52);
          } else if (i > field.inHolesCount + 1 && i < field.holesCount + 2) {
            width = FlexColumnWidth(34);
          } else if (i == field.holesCount + 2) {
            width = FlexColumnWidth(48);
          } else if (i == field.holesCount + 3) {
            width = FlexColumnWidth(76);
          } else {
            throw Exception();
          }
          return MapEntry<int, TableColumnWidth>(i, width);
        }),
      ),
      border: TableBorder(verticalInside: BorderSide(color: colors.line)),
      children: [
        _buildTableTitleRow(context),
        _buildTableParRow(context),
        _buildTableHcpRow(context),
        _buildTableErgebnisRow(context),
        _buildTableBruttoRow(context),
        _buildTableNettoRow(context),
      ],
    );

    return table;
  }

  TableRow _buildTableTitleRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      decoration: BoxDecoration(color: colors.background3),
      children: [
        l10n.viewerTournamentsTableLoch,
        for (int i = 0; i < field.inHolesCount; i++) (i + 1).toString(),
        l10n.viewerTournamentsTableOut,
        for (int i = field.inHolesCount; i < field.holesCount; i++) (i + 1).toString(),
        l10n.viewerTournamentsTableIn,
        l10n.viewerTournamentsTableTotal,
      ]
          .mapIndexed((i, s) => Container(
                height: 34,
                alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
                child: Text(
                  s,
                  style: textStyles.body1.copyWith(fontSize: 16, color: colors.textPrimary),
                ),
              ))
          .toList(),
    );
  }

  TableRow _buildTableParRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      children: [
        l10n.viewerTournamentsPar,
        for (int i = 0; i < field.inHolesCount; i++) field.holes[i].par.toString(),
        '',
        for (int i = field.inHolesCount; i < field.holesCount; i++) field.holes[i].par.toString(),
        '',
        '',
      ]
          .mapIndexed((i, s) => Container(
                height: 34,
                alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
                child: Text(s, style: _getValueColumnTextStyle(i, colors, textStyles)),
              ))
          .toList(),
    );
  }

  TableRow _buildTableHcpRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      decoration: BoxDecoration(color: colors.background4),
      children: [
        l10n.viewerTournamentsTableHcp,
        for (int i = 0; i < field.inHolesCount; i++) field.holes[i].hcp.toString(),
        '',
        for (int i = field.inHolesCount; i < field.holesCount; i++) field.holes[i].hcp.toString(),
        '',
        '',
      ]
          .mapIndexed((i, s) => Container(
                height: 34,
                alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
                child: Text(s, style: _getValueColumnTextStyle(i, colors, textStyles)),
              ))
          .toList(),
    );
  }

  TableRow _buildTableErgebnisRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      children: [
        l10n.viewerTournamentsErgebnis,
        for (int i = 0; i < field.inHolesCount; i++)
          (
            participant.getHoleErgebnis(selectedRound, i),
            participant.getHoleResult(field, selectedRound, i),
          ),
        '',
        for (int i = field.inHolesCount; i < field.holesCount; i++)
          (
            participant.getHoleErgebnis(selectedRound, i),
            participant.getHoleResult(field, selectedRound, i),
          ),
        '',
        '',
      ].mapIndexed((i, s) {
        final result = s is (int?, HoleResultType?) ? s : null;
        return Container(
          height: 34,
          alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
          padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
          child: result != null
              ? DecoratedBox(
                  decoration: _getDecoration(result.$2, colors) ?? BoxDecoration(),
                  child: SizedOverflowBox(
                    size: Size(26, 26),
                    child: Text(result.$1.toString(), style: textStyles.input),
                  ),
                )
              : Text(s.toString(), style: _getValueColumnTextStyle(i, colors, textStyles)),
        );
      }).toList(),
    );
  }

  TableRow _buildTableBruttoRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      decoration: BoxDecoration(color: colors.background4),
      children: [
        l10n.viewerTournamentsBrutto,
        for (int i = 0; i < field.inHolesCount; i++)
          participant.roundScores[selectedRound].holeScores[i].brutto.toString(),
        participant.roundScores.roundTotalOutBrutto(selectedRound, field).toString(),
        for (int i = field.inHolesCount; i < field.holesCount; i++)
          participant.roundScores[selectedRound].holeScores[i].brutto.toString(),
        participant.roundScores.roundTotalInBrutto(selectedRound, field).toString(),
        participant.roundScores.roundTotalBrutto(selectedRound).toString(),
      ]
          .mapIndexed((i, s) => Container(
                height: 34,
                alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
                child: Text(s, style: _getValueColumnTextStyle(i, colors, textStyles)),
              ))
          .toList(),
    );
  }

  TableRow _buildTableNettoRow(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;

    return TableRow(
      children: [
        l10n.viewerTournamentsNetto,
        for (int i = 0; i < field.inHolesCount; i++)
          participant.roundScores[selectedRound].holeScores[i].netto.toString(),
        participant.roundScores.roundTotalOutNetto(selectedRound, field).toString(),
        for (int i = field.inHolesCount; i < field.holesCount; i++)
          participant.roundScores[selectedRound].holeScores[i].netto.toString(),
        participant.roundScores.roundTotalInNetto(selectedRound, field).toString(),
        participant.roundScores.roundTotalNetto(selectedRound).toString(),
      ]
          .mapIndexed((i, s) => Container(
                height: 34,
                alignment: i == 0 ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                padding: i == 0 ? const EdgeInsets.only(left: 5) : null,
                child: Text(s, style: _getValueColumnTextStyle(i, colors, textStyles)),
              ))
          .toList(),
    );
  }

  TextStyle _getValueColumnTextStyle(
      int i, ColorsExtension colors, TextStylesExtension textStyles) {
    if (i == 0) {
      return textStyles.body2.copyWith(fontSize: 16);
    } else if (i == field.inHolesCount + 1 || i > field.holesCount + 1) {
      return textStyles.body1.copyWith(fontSize: 16, color: colors.textPrimary);
    } else {
      return textStyles.input;
    }
  }

  Decoration? _getDecoration(HoleResultType? holeResult, ColorsExtension colors) {
    return switch (holeResult) {
      HoleResultType.eagle => ShapeDecoration(
          shape: DoubleBorder(
            spacing: 0.435,
            innerWidth: 1.59,
            innerColor: colors.accent1,
            outerWidth: 1.59,
            outerColor: colors.textSecondary,
            borderRadius: BorderRadius.circular(48),
          ),
        ),
      HoleResultType.birdie => ShapeDecoration(
          shape: DoubleBorder(
            spacing: 0.435,
            innerWidth: 1.59,
            innerColor: colors.accent1,
            outerWidth: 1.59,
            outerColor: Colors.transparent,
            borderRadius: BorderRadius.circular(48),
          ),
        ),
      HoleResultType.par || null => null,
      HoleResultType.bogey => ShapeDecoration(
          shape: DoubleBorder(
            spacing: 0.435,
            innerWidth: 1.59,
            innerColor: colors.accent1,
            outerWidth: 1.59,
            outerColor: Colors.transparent,
          ),
        ),
      HoleResultType.doubleBogey => ShapeDecoration(
          shape: DoubleBorder(
            spacing: 0.435,
            innerWidth: 1.59,
            innerColor: colors.accent1,
            outerWidth: 1.59,
            outerColor: colors.textSecondary,
          ),
        ),
    };
  }
}
