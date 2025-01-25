import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/app/golf_app.dart';

import 'core/di.dart';

void main() {
  initGetIt();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const GolfApp());
}
