import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/data/exception_displayer.dart';
import 'package:golf_live_scoring/ui/common/widgets/authorization_screen_template.dart';
import 'package:golf_live_scoring/ui/common/widgets/buttons/primary_button.dart';
import 'package:golf_live_scoring/ui/common/widgets/dropdown_input/golf_dropdown_field.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_cubit.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_state.dart';
import 'package:golf_live_scoring/ui/utils/context_extension.dart';
import 'package:golf_live_scoring/ui/utils/text_utils.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const path = "/sign_up";

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
    final textStyles = context.textStyles;

    return AuthorizationScreenTemplate<SignUpCubit, SignUpState>(
      title: l10n.signUpTitle,
      scrollMaxHeight: 978,
      cubit: _cubit,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GolfTextField(
              cubit: _cubit.lastNameCubit,
              hint: l10n.signUpLastName,
              keyboardType: TextInputType.name,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            GolfTextField(
              cubit: _cubit.firstNameCubit,
              hint: l10n.signUpFirstName,
              keyboardType: TextInputType.name,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),
            GolfDropdownField<String>(
              cubit: _cubit.countryCodeCubit,
              hint: l10n.signUpCountry,
              valueToString: (v) => TextUtils.getCountryName(v, l10n),
            ),
            const SizedBox(height: 20),
            GolfDropdownField<Club>(
              cubit: _cubit.clubCubit,
              hint: l10n.signUpClub,
              valueToString: (v) => v.name,
            ),
            const SizedBox(height: 20),
            GolfTextField(
              cubit: _cubit.phoneNumberCubit,
              hint: l10n.signUpMobile,
              keyboardType: TextInputType.phone,
              formatters: [PhoneInputFormatter()],
            ),
            if (!state.signedIn) ...[
              const SizedBox(height: 20),
              GolfTextField(
                cubit: _cubit.emailCubit,
                hint: l10n.signUpEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              GolfTextField(
                cubit: _cubit.passwordCubit,
                hint: l10n.signUpPassword,
                obscureText: true,
              ),
            ],
            const SizedBox(height: 55),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 300,
              ),
              child: PrimaryButton(
                text: state.signedIn ? l10n.signUpCompleteButton : l10n.signUpCreateButton,
                type: PrimaryButtonType.light,
                onPressed: _cubit.signUpWithEmail,
              ),
            ),
            if (!state.signedIn) ...[
              const SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  onTap: _cubit.haveAccount,
                  child: Text(l10n.signUpHaveAccount, style: textStyles.body2),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
