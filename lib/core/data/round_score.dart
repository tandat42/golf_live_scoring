import 'package:freezed_annotation/freezed_annotation.dart';
import 'hole_score.dart';

part 'round_score.freezed.dart';
part 'round_score.g.dart';

@freezed
abstract class RoundScore with _$RoundScore {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory RoundScore({
    required String? notes,
    @Default(<HoleScore>[]) List<HoleScore> holeScores,
  }) = _RoundScore;

  factory RoundScore.fromJson(Map<String, dynamic> json) => _$RoundScoreFromJson(json);
}