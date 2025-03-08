import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/screens/main/main_cubit.dart';
import 'package:golf_live_scoring/ui/screens/main/main_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const path = "/main";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainCubit _cubit = getIt.get();

  @override
  void initState() {
    super.initState();

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

    return BlocBuilder<MainCubit, MainState>(
        bloc: _cubit,
        builder: (context, state) {
          return Scaffold(
            body: Container(
              color: Colors.green,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.counter.toString()),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _cubit.scanData, child: Text('up counter')),
                ],
              ),
            ),
          );
        });
  }
}
