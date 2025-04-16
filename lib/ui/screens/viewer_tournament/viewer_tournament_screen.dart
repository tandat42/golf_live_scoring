import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/common/widgets/golf_tab.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_cubit.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_clubs.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_draw.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/widgets/viewer_tournament_participants.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

@RoutePage()
class ViewerTournamentsScreen extends StatefulWidget {
  const ViewerTournamentsScreen({super.key});

  static const path = "viewer_tournaments";

  @override
  State<ViewerTournamentsScreen> createState() => _ViewerTournamentsScreenState();
}

class _ViewerTournamentsScreenState extends State<ViewerTournamentsScreen> with ExceptionDisplayer {
  final ViewerTournamentCubit _cubit = getIt.get(param1: '2P5jcdEqMeAxOFAoNo2R');

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    listenExceptions(_cubit.stream);
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  void onTabTap(int value) {
    setState(() {
      _selectedTabIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider<ViewerTournamentCubit>.value(
      value: _cubit,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                GolfTab(
                  text: l10n.viewerTournamentsTeams,
                  space: 10,
                  index: 0,
                  selectedIndex: _selectedTabIndex,
                  onTap: onTabTap,
                ),
                const SizedBox(width: 40),
                GolfTab(
                  text: l10n.viewerTournamentsDraw,
                  space: 10,
                  index: 1,
                  selectedIndex: _selectedTabIndex,
                  onTap: onTabTap,
                ),
                const SizedBox(width: 40),
                GolfTab(
                  text: l10n.viewerTournamentsScores,
                  space: 10,
                  index: 2,
                  selectedIndex: _selectedTabIndex,
                  onTap: onTabTap,
                ),
                const Spacer(flex: 1),
              ],
            ),
            Divider(height: 1, thickness: 1),
            Expanded(
                child: switch (_selectedTabIndex) {
              0 => ViewerTournamentClubs(),
              1 => ViewerTournamentDraw(),
              2 => ViewerTournamentParticipants(),
              _ => throw Exception('ViewerTournamentsScreen: no tab for index $_selectedTabIndex'),
            }),
          ],
        ),
      ),
    );
  }
}
