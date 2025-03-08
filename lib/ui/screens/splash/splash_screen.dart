import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_cubit.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const path = "/splash";

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          Assets.images.logo,
          width: 157,
          height: 81,
        ),
      ),
    );
  }
}
