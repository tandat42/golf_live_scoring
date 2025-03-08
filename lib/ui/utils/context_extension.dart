import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/common/golf_theme.dart';
import 'package:golf_live_scoring/ui/gen/l10n.dart';

extension ContextExtension on BuildContext {
  GolfLocalizations get l10n => GolfLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  TextStylesExtension get textStyles => theme.extension<TextStylesExtension>()!;

  ColorsExtension get colors => theme.extension<ColorsExtension>()!;
}
