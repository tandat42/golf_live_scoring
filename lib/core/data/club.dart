import 'package:freezed_annotation/freezed_annotation.dart';

part 'club.freezed.dart';
part 'club.g.dart';

@Freezed()
abstract class Club with _$Club {
  const factory Club({
    required String id,
    required String? name,
    required String? countryCode,
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}
