import 'package:freezed_annotation/freezed_annotation.dart';
import 'profile.dart';
import 'round_score.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

@freezed
abstract class Participant with _$Participant {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Participant({
    required Profile profile,
    @Default(<RoundScore> []) List<RoundScore> roundScores,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}