import 'package:auto_route/auto_route.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
import 'package:injectable/injectable.dart';

@AutoRouterConfig()
@Singleton()
class GolfRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true, path: "/splash"),
        AutoRoute(page: SignInRoute.page, path: "/sign_in"),
        AutoRoute(page: SignUpRoute.page, path: "/sign_up"),
        AutoRoute(page: MainRoute.page, path: "/main"),
      ];
}
