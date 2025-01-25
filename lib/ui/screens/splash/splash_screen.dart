import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_cubit.dart';
import 'package:golf_live_scoring/ui/utils/l10n_utils.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ExceptionDisplayer {
  final SplashCubit _cubit = getIt.get();

  @override
  void initState() {
    super.initState();

    listenExceptions(_cubit.stream);

    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Container(
        color: Colors.green,
        alignment: Alignment.center,
        child: Text(l10n.commonAppTitle),
      ),
    );
  }
}
