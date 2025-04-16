import 'package:auto_route/auto_route.dart';
import 'package:golf_live_scoring/core/services/app_service.dart';
import 'package:golf_live_scoring/core/services/auth/auth_service.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:golf_live_scoring/ui/screens/main/main_screen.dart';
import 'package:golf_live_scoring/ui/screens/sign_in/sign_in_screen.dart';
import 'package:golf_live_scoring/ui/screens/sign_up/sign_up_screen.dart';
import 'package:golf_live_scoring/ui/screens/splash/splash_screen.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournament/viewer_tournament_screen.dart';
import 'package:golf_live_scoring/ui/screens/viewer_tournaments_calendar/viewer_tournaments_calendar_screen.dart';
import 'package:injectable/injectable.dart';

@AutoRouterConfig()
@Singleton()
class GolfRouter extends RootStackRouter {
  GolfRouter(this._initializationGuard);

  final CommonGuard _initializationGuard;

  @override
  late final List<AutoRouteGuard> guards = [_initializationGuard];

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true, path: SplashScreen.path),
        AutoRoute(page: SignInRoute.page, path: SignInScreen.path),
        AutoRoute(page: SignUpRoute.page, path: SignUpScreen.path),
        AutoRoute(
          page: MainRoute.page,
          path: MainScreen.path,
          children: [
            RedirectRoute(path: '', redirectTo: ViewerTournamentsScreen.path),
            AutoRoute(
              page: ViewerTournamentsRoute.page,
              path: ViewerTournamentsScreen.path,
            ),
            AutoRoute(
              page: ViewerTournamentsCalendarRoute.page,
              path: ViewerTournamentsCalendarScreen.path,
            ),
          ],
        ),
      ];
}

@Singleton()
class CommonGuard extends AutoRouteGuard {
  CommonGuard(
    this._appService,
    this._authService,
  );

  final AppService _appService;
  final AuthService _authService;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    print("CommonGuard.onNavigation: ${resolver.routeName}|${router.current.name}");

    if (!_appService.readyToWork && resolver.routeName != SplashRoute.name) {
      resolver.next(false);
      router.replaceAll([SplashRoute()]);
    } else if (resolver.routeName != SplashRoute.name &&
        _authService.isSignedIn() &&
        resolver.routeName == SignInRoute.name) {
      resolver.next(false);
    } else {
      resolver.next(true);
    }
  }
}
