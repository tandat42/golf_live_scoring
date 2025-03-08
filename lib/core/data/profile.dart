import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@Freezed()
abstract class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    String? lastName,
    String? firstName,
    String? countryCode,
    String? clubId,
    String? phoneNumber,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  bool get isEmpty =>
      lastName == null &&
      firstName == null &&
      countryCode == null &&
      clubId == null &&
      phoneNumber == null;
}
