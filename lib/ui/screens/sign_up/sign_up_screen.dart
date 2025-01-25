import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/common/widgets/common_screen_wrapper.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_cubit.dart';
import 'package:golf_live_scoring/ui/utils/l10n_utils.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with ExceptionDisplayer {
  final SignUpCubit _cubit = getIt.get();

  @override
  void initState() {
    super.initState();

    _cubit.init();

    listenExceptions(_cubit.stream);
  }

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return CommonScreenWrapper(
        cubit: _cubit,
        contentBuilder: (context) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.signUpTitle),
                const SizedBox(height: 50),
                GolfTextField(
                  cubit: _cubit.emailCubit,
                  hint: l10n.signUpEmail,
                ),
                const SizedBox(height: 10),
                GolfTextField(
                  cubit: _cubit.passwordCubit,
                  obscureText: true,
                  hint: l10n.signUpPassword,
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: _cubit.signUpWithEmail,
                  child: Text(l10n.signUpButton),
                ),
              ],
            ),
          );
        });
  }
}
