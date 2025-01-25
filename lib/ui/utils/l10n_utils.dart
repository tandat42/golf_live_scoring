import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/l10n/l10n.dart';

extension L10nContextExtension on BuildContext {
  GolfLocalizations get l10n => GolfLocalizations.of(this);
}
