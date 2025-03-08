import 'package:golf_live_scoring/ui/gen/l10n.dart';

abstract final class StringUtils {
  static int compare(String? s1, String? s2) {
    return switch ((s1, s2)) {
      (null, null) => 0,
      (null, _) => 1,
      (_, null) => -1,
      (var s1!, var s2!) => s1.compareTo(s2),
    };
  }
}
