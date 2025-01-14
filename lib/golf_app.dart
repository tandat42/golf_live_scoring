import 'package:flutter/material.dart';

class GolfApp extends StatefulWidget {
  const GolfApp({super.key});

  @override
  State<GolfApp> createState() => _GolfAppState();
}

class _GolfAppState extends State<GolfApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Live Scoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const Placeholder(),
    );
  }
}
