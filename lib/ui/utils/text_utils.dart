import 'package:golf_live_scoring/ui/gen/l10n.dart';

abstract final class TextUtils {
  static String getCountryName(String countryCode, GolfLocalizations l10n) {
    return switch (countryCode) {
      "ae" => l10n.countryAe,
      "by" => l10n.countryBy,
      "pl" => l10n.countryPl,
      _ => countryCode,
    };
  }
}
