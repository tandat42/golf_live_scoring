import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/ui/utils/l10n_utils.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: Text(l10n.mainTitle),
      ),
    );
  }
}
