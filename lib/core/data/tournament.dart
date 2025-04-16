import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golf_live_scoring/core/data/field.dart';
import 'package:golf_live_scoring/core/data/flight.dart';
import 'package:golf_live_scoring/core/data/participant.dart';

part 'tournament.freezed.dart';
part 'tournament.g.dart';

@freezed
abstract class Tournament with _$Tournament {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Tournament({
    required String? name,
    required DateTime? startDate,
    required String? description,
    required DateTime? endDate,
    required Field field,
    required int? round,
    @Default(<Participant>[]) List<Participant> participants,
    @Default(<Flight>[]) List<Flight> flights,
  }) = _Tournament;

  factory Tournament.fromJson(Map<String, dynamic> json) =>
      _$TournamentFromJson(json);
}