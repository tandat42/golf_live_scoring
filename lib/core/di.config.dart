// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:golf_live_scoring/core/services/auth/auth_service.dart' as _i93;
import 'package:golf_live_scoring/core/services/auth/google_sign_in_resolver.dart'
    as _i119;
import 'package:golf_live_scoring/core/services/main_service.dart' as _i880;
import 'package:golf_live_scoring/ui/app/app_sign_in_listener.dart' as _i764;
import 'package:golf_live_scoring/ui/common/widgets/text_input/golf_text_field_cubit.dart'
    as _i68;
import 'package:golf_live_scoring/ui/navigation/golf_router.dart' as _i155;
import 'package:golf_live_scoring/ui/screens/main/main_cubit.dart' as _i414;
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_cubit.dart'
    as _i508;
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_cubit.dart'
    as _i440;
import 'package:golf_live_scoring/ui/screens/splash/splash_cubit.dart' as _i826;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final googleSignInResolverDi = _$GoogleSignInResolverDi();
    gh.factory<_i119.GoogleSignInResolver>(
        () => googleSignInResolverDi.platformService);
    gh.singleton<_i155.GolfRouter>(() => _i155.GolfRouter());
    gh.singleton<_i880.MainService>(() => _i880.MainService());
    gh.singleton<_i93.AuthService>(
        () => _i93.AuthService(gh<_i119.GoogleSignInResolver>()));
    gh.factory<_i414.MainCubit>(() => _i414.MainCubit(gh<_i155.GolfRouter>()));
    gh.factoryParam<_i68.GolfTextFieldCubit, String?, dynamic>((
      initialText,
      _,
    ) =>
        _i68.GolfTextFieldCubit(initialText: initialText));
    gh.singleton<_i764.AppSignInListener>(
      () => _i764.AppSignInListener(
        gh<_i155.GolfRouter>(),
        gh<_i93.AuthService>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i826.SplashCubit>(() => _i826.SplashCubit(
          gh<_i155.GolfRouter>(),
          gh<_i880.MainService>(),
          gh<_i93.AuthService>(),
          gh<_i764.AppSignInListener>(),
        ));
    gh.factory<_i508.SignInCubit>(() => _i508.SignInCubit(
          gh<_i155.GolfRouter>(),
          gh<_i93.AuthService>(),
          gh<_i68.GolfTextFieldCubit>(),
          gh<_i68.GolfTextFieldCubit>(),
        ));
    gh.factory<_i440.SignUpCubit>(() => _i440.SignUpCubit(
          gh<_i93.AuthService>(),
          gh<_i68.GolfTextFieldCubit>(),
          gh<_i68.GolfTextFieldCubit>(),
        ));
    return this;
  }
}

class _$GoogleSignInResolverDi extends _i119.GoogleSignInResolverDi {}
