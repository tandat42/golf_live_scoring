import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@Freezed()
abstract class Profile with _$Profile {
  const Profile._();

  const factory Profile({
    @Default('') String id,
    required String? lastName,
    required String? firstName,
    required String? image,
    required String? countryCode,
    required String? clubId,
    required String? phoneNumber,
    required int? hcp,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  bool get isEmpty =>
      lastName == null &&
      firstName == null &&
      image == null &&
      countryCode == null &&
      clubId == null &&
      phoneNumber == null &&
      hcp == null;
}
