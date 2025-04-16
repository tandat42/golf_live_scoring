import 'package:freezed_annotation/freezed_annotation.dart';

import 'club.dart';

part 'setup.freezed.dart';
part 'setup.g.dart';

@Freezed()
abstract class Setup with _$Setup {
  const factory Setup({
   @Default(<Club>[]) List<Club> clubs,
  }) = _Setup;

  factory Setup.fromJson(Map<String, dynamic> json) => _$SetupFromJson(json);
}
