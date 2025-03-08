import 'package:freezed_annotation/freezed_annotation.dart';

import 'club.dart';

part 'clubs.freezed.dart';
part 'clubs.g.dart';

@Freezed()
abstract class Clubs with _$Clubs {
  const factory Clubs({
   required List<Club>? clubs,
  }) = _Clubs;

  factory Clubs.fromJson(Map<String, dynamic> json) => _$ClubsFromJson(json);
}
