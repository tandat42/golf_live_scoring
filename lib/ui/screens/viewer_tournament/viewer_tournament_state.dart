import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/core/data/flight.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/data/round_score.dart';
import 'package:golf_live_scoring/ui/common/data/exception_state.dart';
import 'package:golf_live_scoring/ui/common/data/hole_result_type.dart';

part 'viewer_tournament_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class ViewerTournamentState with _$ViewerTournamentState implements ExceptionState {
  const factory ViewerTournamentState({
    Exception? exception,
    TournamentInfo? tournamentInfo,
    List<ClubScoreInfo>? clubsScores,
    List<FlightInfo>? flights,
    List<ParticipantInfo>? participants,
  }) = _ViewerTournamentState;
}

@Freezed(toJson: false, fromJson: false)
abstract class TournamentInfo with _$TournamentInfo {
  const factory TournamentInfo({
    required String? name,
    required DateTime? startDate,
    required String? description,
    required DateTime? endDate,
    required Field field,
    required int? round,
  }) = _TournamentInfo;
}

@Freezed(toJson: false, fromJson: false)
abstract class ClubScoreInfo with _$ClubScoreInfo {
  const factory ClubScoreInfo({
    required Club club,
    required List<Participant> participants,
    required int playedHoles,
    required int parRelativeTotal,
    required int total,
    required List<int> roundTotals,
  }) = _ClubScoreInfo;
}

@Freezed(toJson: false, fromJson: false)
abstract class FlightInfo with _$FlightInfo {
  const factory FlightInfo({
    required Flight flight,
    required List<Participant> participants,
    required Map<String, Club> clubsById,
  }) = _FlightInfo;
}

@Freezed(toJson: false, fromJson: false)
abstract class ParticipantInfo with _$ParticipantInfo {
  const factory ParticipantInfo({
    required Profile profile,
    required Club club,
    @Default(<RoundScore>[]) List<RoundScore> roundScores,
    required int playedHoles,
    required int parRelativeTotal,
    required int total,
    required List<int> roundTotals,
  }) = _ParticipantInfo;

  const ParticipantInfo._();

  int? getHoleErgebnis(int round, int hole) {
    if (roundScores.length > round && roundScores[round].holeScores.length > hole) {
      return roundScores[round].holeScores[hole].ergebnis;
    }
    return null;
  }

  int? getHoleBrutto(int round, int hole) {
    if (roundScores.length > round && roundScores[round].holeScores.length > hole) {
      return roundScores[round].holeScores[hole].brutto;
    }
    return null;
  }

  int? getHoleNetto(int round, int hole) {
    if (roundScores.length > round && roundScores[round].holeScores.length > hole) {
      return roundScores[round].holeScores[hole].netto;
    }
    return null;
  }

  HoleResultType? getHoleResult(Field field, int round, int hole) {
    if (roundScores.length > round &&
        roundScores[round].holeScores.length > hole &&
        roundScores[round].holeScores[hole].ergebnis != null) {
      return switch (roundScores[round].holeScores[hole].ergebnis! - field.holes[hole].par) {
        < -1 => HoleResultType.eagle,
        -1 => HoleResultType.birdie,
        0 => HoleResultType.par,
        1 => HoleResultType.bogey,
        > 1 => HoleResultType.doubleBogey,
        _ => null,
      };
    }
    return null;
  }
}
