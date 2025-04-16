import 'package:freezed_annotation/freezed_annotation.dart';

part 'hole.freezed.dart';
part 'hole.g.dart';

@freezed
abstract class Hole with _$Hole {
  const factory Hole({
    required int holeNumber,
    required int par,
    required int hcp,
    required int? lengthMeters,
    required String? description,
  }) = _Hole;

  factory Hole.fromJson(Map<String, dynamic> json) => _$HoleFromJson(json);
}