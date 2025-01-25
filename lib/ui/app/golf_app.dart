import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/l10n/l10n.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';

class GolfApp extends StatefulWidget {
  const GolfApp({super.key});

  @override
  State<GolfApp> createState() => _GolfAppState();
}

class _GolfAppState extends State<GolfApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: [
        GolfLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: GolfLocalizations.delegate.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
      ),
      routerConfig: getIt.get<GolfRouter>().config(),
    );
  }
}
