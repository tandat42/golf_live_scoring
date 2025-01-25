import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/common/widgets/common_screen_wrapper.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field.dart';
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_cubit.dart';
import 'package:golf_live_scoring/ui/utils/l10n_utils.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with ExceptionDisplayer {
  final SignInCubit _cubit = getIt.get();

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
                Text(l10n.signInTitle),
                const SizedBox(height: 50),
                GolfTextField(
                  cubit: _cubit.emailCubit,
                  hint: l10n.signInEmail,
                ),
                const SizedBox(height: 10),
                GolfTextField(
                  cubit: _cubit.passwordCubit,
                  obscureText: true,
                  hint: l10n.signInPassword,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _cubit.signInWithEmail,
                  child: Text(l10n.signInButton),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: _cubit.signInWithGoogle,
                  child: Text(l10n.signInGoogleButton),
                ),
                const SizedBox(height: 50),
                TextButton(
                  onPressed: _cubit.signUp,
                  child: Text(l10n.signInSignUpButton),
                ),
              ],
            ),
          );
        });
  }
}
