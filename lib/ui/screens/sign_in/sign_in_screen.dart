import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/common/widgets/authorization_screen_template.dart';
import 'package:golf_live_scoring/ui/common/widgets/buttons/primary_button.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_sign_in_text_field.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/gen/l10n.dart';
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_cubit.dart';
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const path = "/sign_in";

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
    final theme = context.theme;
    final textStyles = context.textStyles;

    return AuthorizationScreenTemplate<SignInCubit, SignInState>(
      title: l10n.signInTitle,
      scrollMaxHeight: 830,
      cubit: _cubit,
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSocialButtons(l10n),
          const SizedBox(height: 30),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(l10n.signInWithPassword, style: textStyles.body2),
          ),
          const SizedBox(height: 17),
          GolfSignInTextField(
            cubit: _cubit.emailCubit,
            prefixIcon: Assets.icons.login,
          ),
          const SizedBox(height: 15),
          GolfSignInTextField(
            cubit: _cubit.passwordCubit,
            obscureText: true,
            prefixIcon: Assets.icons.password,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
                onTap: _cubit.forgotPassword,
                child: Text(l10n.signInForgotPassword, style: textStyles.body2)),
          ),
          const SizedBox(height: 27),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 300),
            child: PrimaryButton(
              text: l10n.signInButton,
              onPressed: _cubit.signInWithEmail,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: Container(height: 1, color: theme.dividerColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(l10n.signInOr, style: textStyles.body2),
              ),
              Expanded(child: Container(height: 1, color: theme.dividerColor)),
            ],
          ),
          const SizedBox(height: 27),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 300,
            ),
            child: PrimaryButton(
              text: l10n.signInCreateButton,
              type: PrimaryButtonType.dark,
              onPressed: _cubit.signUp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButtons(GolfLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: l10n.signInAppleButton,
            icon: Assets.icons.apple,
            type: PrimaryButtonType.dark,
            onPressed: _cubit.signInWithApple,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: PrimaryButton(
            text: l10n.signInGoogleButton,
            icon: Assets.icons.google,
            type: PrimaryButtonType.dark,
            onPressed: _cubit.signInWithGoogle,
          ),
        ),
      ],
    );
  }
}
