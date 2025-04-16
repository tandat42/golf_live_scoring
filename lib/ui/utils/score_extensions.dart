import 'package:collection/collection.dart';
import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/data/round_score.dart';

extension ParticipantsListExtension on List<Participant> {
  int playedHoles() => map((p) => p.playedHoles()).sum;

  int totalNetto() => map((p) => p.roundScores.totalNetto()).sum;

  int parRelativeTotal(Field field) =>
      map((p) => p.roundScores.parRelativeTotal(field, p.profile)).sum;

  int roundTotal(int round) => map((p) => p.roundScores.roundTotalNetto(round)).sum;
}

extension ParticipantExtension on Participant {
  int playedHoles() =>
      roundScores.map((r) => r.holeScores.where((h) => h.brutto != null).length).sum;

  int parRelativeTotal(Field field) => roundScores.parRelativeTotal(field, profile);

  int totalNetto() => roundScores.totalNetto();

  int roundTotalNetto(int round) => roundScores.roundTotalNetto(round);

  int totalBrutto() => roundScores.totalBrutto();

  int roundTotalBrutto(int round) => roundScores.roundTotalBrutto(round);
}

extension RoundScoreListExtension on List<RoundScore> {
  int parRelativeTotal(Field field, Profile profile) => map(
        (r) => r.holeScores.mapIndexed((i, h) {
          final averageHandicapFix = ((profile.hcp ?? 0) / field.holes.length);
          final handicapFix = (profile.hcp ?? 0) % field.holes.length > i
              ? averageHandicapFix.floor()
              : averageHandicapFix.ceil();
          return h.ergebnis != null ? h.ergebnis! - field.holes[i].par - handicapFix : null;
        }).sum,
      ).sum;

  /// ==== NETTO ====

  int totalNetto() => map((r) => r.holeScores.where((h) => h.netto != null).length).sum;

  int roundTotalNetto(int round) =>
      round < length ? this[round].holeScores.map((h) => h.netto).sum : 0;

  int roundTotalInNetto(int round, Field field) {
    return round < length
        ? this[round].holeScores.take(field.inHolesCount).map((h) => h.netto).sum
        : 0;
  }

  int roundTotalOutNetto(int round, Field field) {
    return round < length
        ? this[round].holeScores.skip(field.inHolesCount).map((h) => h.netto).sum
        : 0;
  }

  /// ==== BRUTTO ====

  int totalBrutto() => map((r) => r.holeScores.where((h) => h.brutto != null).length).sum;

  int roundTotalBrutto(int round) =>
      round < length ? this[round].holeScores.map((h) => h.brutto).sum : 0;

  int roundTotalInBrutto(int round, Field field) {
    return round < length
        ? this[round].holeScores.take(field.inHolesCount).map((h) => h.brutto).sum
        : 0;
  }

  int roundTotalOutBrutto(int round, Field field) {
    return round < length
        ? this[round].holeScores.skip(field.outHolesCount).map((h) => h.brutto).sum
        : 0;
  }
}

extension IntExtension on Iterable<int?> {
  int get sum => fold(0, (r, v) => v != null ? r + v : r);
}
