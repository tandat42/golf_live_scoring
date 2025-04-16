import 'dart:math';
import 'dart:ui';

import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/core/data/flight.dart';
import 'package:golf_live_scoring/core/data/hole_score.dart';
import 'package:golf_live_scoring/core/data/participant.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/data/round_score.dart';
import 'package:golf_live_scoring/core/data/tournament.dart';

abstract final class DemoData {
  List<Tournament> getData(List<Profile> profiles, List<Field> fields) {
    final random = Random();
    final result = <Tournament>[];
    for (var tournamentI = 0; tournamentI < 6; tournamentI++) {
      profiles.shuffle();
      final players = profiles.take((profiles.length / 2).toInt()).toList();
      final field = fields[random.nextInt(fields.length)];
      final date = "2025-0${4 + random.nextInt(5)}-${10 + random.nextInt(20)} 12:00:00";
      print("date=$date");
      final startDate = DateTime.parse(date);
      result.add(
        Tournament(
          name: "Tournament $tournamentI",
          startDate: startDate,
          endDate: startDate.add(Duration(days: random.nextInt(5))),
          description: "Tournament $tournamentI description",
          field: field,
          round: tournamentI % 2,
          participants: List.generate(
            players.length,
            (participantI) => Participant(
              profile: players[participantI],
              roundScores: List.generate(
                3,
                (roundI) => RoundScore(
                  notes: 'round ${roundI + 1} note',
                  holeScores: List.generate(
                    field.holes.length,
                    (holeI) {
                      final ergebnis = clampDouble(
                              field.holes[holeI].par + random.nextInt(7) - 2, 1, double.infinity)
                          .toInt();
                      final brutto = random.nextInt(ergebnis);
                      return HoleScore(
                        ergebnis: ergebnis,
                        brutto: brutto,
                        netto: brutto == 0 ? 0 : random.nextInt(brutto),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          flights: List.generate(
              (players.length / 4).ceil(),
              (i) => Flight(
                    name: 'flight $i',
                    teeName: field.tees[random.nextInt(field.tees.length)],
                    profileIds: players
                        .map((p) => p.id)
                        .toList()
                        .sublist(i * 4, min((i + 1) * 4, players.length)),
                  )),
        ),
      );
    }
    return result;
  }
}
