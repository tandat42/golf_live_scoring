import 'package:freezed_annotation/freezed_annotation.dart';

part 'hole_score.freezed.dart';
part 'hole_score.g.dart';

@freezed
abstract class HoleScore with _$HoleScore {
  const factory HoleScore({
    required int? ergebnis,
    required int? brutto,
    required int? netto,
  }) = _HoleScore;

  factory HoleScore.fromJson(Map<String, dynamic> json) =>
      _$HoleScoreFromJson(json);
}