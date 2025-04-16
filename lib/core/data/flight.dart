import 'package:freezed_annotation/freezed_annotation.dart';

part 'flight.freezed.dart';
part 'flight.g.dart';

@freezed
abstract class Flight with _$Flight {
  const factory Flight({
    required String? name,
    required String? teeName,
    @Default(<String>[]) List<String> profileIds,
  }) = _Flight;

  factory Flight.fromJson(Map<String, dynamic> json) =>
      _$FlightFromJson(json);
}