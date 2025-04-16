import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/core/data/setup.dart';
import 'package:golf_live_scoring/core/data/tournament.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_state.dart';
import 'package:golf_live_scoring/ui/utils/score_extensions.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ViewerTournamentCubit extends Cubit<ViewerTournamentState> {
  ViewerTournamentCubit(
    this._router,
    this._dataService,
    @factoryParam this.id,
  ) : super(ViewerTournamentState());

  final GolfRouter _router;
  final DataService _dataService;

  final String id;

  late final Map<String, Club> _clubsById;

  StreamSubscription<Tournament?>? _subscription;

  Future<void> init() async {
    Setup setup;
    try {
      setup = await _dataService.loadSetup();
    } catch (e) {
      print('ViewerTournamentCubit: failed to load setup');
      setup = _dataService.setup;
    }

    _clubsById = setup.clubs.fold(<String, Club>{}, (r, c) {
      r[c.id] = c;
      return r;
    });

    _subscription = _dataService.listenTournament(id).listen(
          _onTournamentChange,
          onError: (e) => emit(state.copyWith(exception: e)),
        );
  }

  void _onTournamentChange(Tournament? tournament) {
    if (tournament == null) return;

    final tournamentInfo = TournamentInfo(
      name: tournament.name,
      startDate: tournament.startDate,
      description: tournament.description,
      endDate: tournament.endDate,
      field: tournament.field,
      round: tournament.round,
    );

    final clubParticipants = tournament.participants.fold(<String, List<Participant>>{}, (r, p) {
      final clubId = p.profile.clubId;
      if (clubId != null) {
        !r.containsKey(clubId) ? r[clubId] = [p] : r[clubId]!.add(p);
      }
      return r;
    });
    final clubsScores = clubParticipants.keys.map((clubId) {
      final participants = clubParticipants[clubId]!;
      return ClubScoreInfo(
        club: _clubsById[clubId]!,
        participants: participants,
        playedHoles: participants.playedHoles(),
        parRelativeTotal: participants.parRelativeTotal(tournament.field),
        total: participants.totalNetto(),
        roundTotals: List.generate(3, (i) => participants.roundTotal(i)),
      );
    }).toList()
      ..sort((s1, s2) => s2.total.compareTo(s1.total));

    final flights = tournament.flights
        .map(
          (f) => FlightInfo(
            flight: f,
            participants:
                tournament.participants.where((p) => f.profileIds.contains(p.profile.id)).toList(),
            clubsById: _clubsById,
          ),
        )
        .toList();

    final participants = tournament.participants
        .map(
          (p) => ParticipantInfo(
            profile: p.profile,
            club: _clubsById[p.profile.clubId]!,
            roundScores: p.roundScores,
            playedHoles: p.playedHoles(),
            parRelativeTotal: p.parRelativeTotal(tournament.field),
            total: p.totalNetto(),
            roundTotals: List.generate(3, (i) => p.roundTotalNetto(i)),
          ),
        )
        .sorted((p1, p2) => p2.total.compareTo(p1.total));

    emit(
      state.copyWith(
        tournamentInfo: tournamentInfo,
        clubsScores: clubsScores,
        flights: flights,
        participants: participants,
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
