import 'package:freezed_annotation/freezed_annotation.dart';
import 'hole.dart';

part 'field.freezed.dart';

part 'field.g.dart';

@freezed
abstract class Field with _$Field {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory Field({
    @Default('') String id,
    required String? name,
    required String? location,
    required String? description,
    @Default(<String>[]) List<String> tees,
    @Default(<Hole>[]) List<Hole> holes,
  }) = _Field;

  const Field._();

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  int get holesCount => holes.length;

  int get inHolesCount => (holes.length / 2).toInt();

  int get outHolesCount => holesCount - inHolesCount;
}
