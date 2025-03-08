import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:golf_live_scoring/core/data/club.dart';
import 'package:golf_live_scoring/core/data/profile.dart';
import 'package:golf_live_scoring/core/exceptions/sign_up_exception.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/core/services/data/data_service.dart';
import 'package:golf_live_scoring/core/services/initializable.dart';
import 'package:golf_live_scoring/ui/common/widgets/dropdown_input/golf_dropdown_field_cubit.dart';
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_state.dart';
import 'package:golf_live_scoring/ui/utils/string_utils.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class SignUpCubit extends Cubit<SignUpState> with Initializable {
  SignUpCubit(
    this._router,
    this._authService,
    this._dataService,
  ) : super(SignUpState());

  final GolfRouter _router;
  final AuthService _authService;
  final DataService _dataService;

  late final GolfTextFieldCubit lastNameCubit;
  late final GolfTextFieldCubit firstNameCubit;
  late final GolfDropdownFieldCubit<String> countryCodeCubit;
  late final GolfDropdownFieldCubit<Club> clubCubit;
  late final GolfTextFieldCubit phoneNumberCubit;
  late final GolfTextFieldCubit emailCubit;
  late final GolfTextFieldCubit passwordCubit;

  late final StreamSubscription<bool> _authProgressSubscription;
  late final StreamSubscription<String?> _countryCodeDropdownSubscription;

  List<Club>? _clubs;

  Future<void> init() async {
    if (initialized) return;

    lastNameCubit = GolfTextFieldCubit();
    firstNameCubit = GolfTextFieldCubit();
    countryCodeCubit = GolfDropdownFieldCubit<String>();
    clubCubit = GolfDropdownFieldCubit<Club>();
    phoneNumberCubit = GolfTextFieldCubit();
    emailCubit = GolfTextFieldCubit();
    passwordCubit = GolfTextFieldCubit();

    emit(state.copyWith(inProgress: true));

    emit(state.copyWith(signedIn: _authService.isSignedIn()));

    while (countryCodeCubit.state.values.isEmpty && !isClosed) {
      try {
        _clubs = await _dataService.getClubs();
        final countryCodes = _clubs!.map((c) => c.countryCode ?? '').toSet().toList()
          ..sort(StringUtils.compare);
        countryCodeCubit.update(null, countryCodes);
        emit(state.copyWith(inProgress: false));
      } on Exception catch (e) {
        emit(state.copyWith(exception: e));
        print("SignUpCubit.init: $e");
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    if (isClosed) return;

    _countryCodeDropdownSubscription =
        countryCodeCubit.stream.map((s) => s.value).listen((countryCode) {
      final filteredClubs = _clubs!.where((c) => c.countryCode == countryCode).toList();
      clubCubit.update(null, filteredClubs);
    });
    _authProgressSubscription =
        _authService.authProgressStream.listen((p) => emit(state.copyWith(inProgress: p)));

    initialized = true;
  }

  @override
  Future<void> close() async {
    _authProgressSubscription.cancel();
    _countryCodeDropdownSubscription.cancel();

    lastNameCubit.close();
    firstNameCubit.close();
    countryCodeCubit.close();
    clubCubit.close();
    phoneNumberCubit.close();
    emailCubit.close();
    passwordCubit.close();

    await super.close();
  }

  void haveAccount() {
    _router.pop();
  }

  Future<void> signUpWithEmail() async {
    if (state.inProgress) return;

    try {
      emit(state.copyWith(inProgress: true));
      if (!_authService.isSignedIn()) {
        await _authService.signUpWithEmail(emailCubit.text, passwordCubit.text);
        if (!_authService.isSignedIn()) {
          throw SignUpException();
        }
      }
      emit(state.copyWith(signedIn: true));

      _dataService.editProfile(
        Profile(
          lastName: lastNameCubit.text,
          firstName: firstNameCubit.text,
          countryCode: countryCodeCubit.value,
          clubId: clubCubit.value?.id ?? '',
          phoneNumber: phoneNumberCubit.text,
        ),
      );
      //sign in is processed by AppSignInListener

      emit(state.copyWith(inProgress: false));
    } on Exception catch (e) {
      print(e);
      emit(state.copyWith(exception: e, inProgress: false));
    }
  }
}
