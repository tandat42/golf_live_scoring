import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_live_scoring/core/di.dart';
import 'package:golf_live_scoring/ui/common/widgets/golf_tab.dart';
import 'package:golf_live_scoring/ui/gen/assets.gen.dart';
import 'package:golf_live_scoring/ui/navigation/golf_router.gr.dart';
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

  void _onTabTap(TabsRouter tabsRouter, int tabIndex) {
    tabsRouter.setActiveIndex(tabIndex);
  }

  void _onSearchTap() {
    //todo
  }

  void _onSignOutTap() {
    _cubit.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MainCubit, MainState>(
        bloc: _cubit,
        builder: (context, state) {
          return AutoTabsRouter(
              routes: [
                ViewerTournamentsRoute(),
                ViewerTournamentsCalendarRoute(),
              ],
              builder: (context, child) {
                final tabsRouter = context.tabsRouter;
                return Scaffold(
                  body: state.authInProgress
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(top: _MainTopBar.height, child: child),
                        _MainTopBar(
                          selectedTabIndex: tabsRouter.activeIndex,
                          onTabTap: (t) => _onTabTap(tabsRouter, t),
                          onSearchTap: _onSearchTap,
                                onSignOutTap: _onSignOutTap,
                              ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

class _MainTopBar extends StatelessWidget {
  const _MainTopBar({
    required this.selectedTabIndex,
    required this.onTabTap,
    required this.onSearchTap,
    required this.onSignOutTap,
  });

  static const barHeight = 60.0;
  static const bannerHeight = 200.0;
  static const height = barHeight + bannerHeight;

  final int selectedTabIndex;
  final ValueChanged<int> onTabTap;
  final VoidCallback onSearchTap;
  final VoidCallback onSignOutTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: bannerHeight,
            child: Container(
              width: double.infinity,
              height: barHeight,
              decoration: BoxDecoration(
                color: colors.background2,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(0x40), offset: Offset(0, 4), blurRadius: 4),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  SvgPicture.asset(Assets.images.logo, width: 258, height: 32, fit: BoxFit.contain),
                  const SizedBox(width: 70),
                  GolfTab(
                    text: l10n.mainTournaments,
                    space: 14,
                    index: 0,
                    selectedIndex: selectedTabIndex,
                    onTap: onTabTap,
                  ),
                  const SizedBox(width: 50),
                  GolfTab(
                    text: l10n.mainTournamentCalendar,
                    space: 14,
                    index: 1,
                    selectedIndex: selectedTabIndex,
                    onTap: onTabTap,
                  ),
                  const Spacer(flex: 570),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: SvgPicture.asset(Assets.icons.search, width: 20, height: 20),
                      padding: const EdgeInsets.all(10),
                      onPressed: onSearchTap,
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: SvgPicture.asset(Assets.icons.logout, width: 23, height: 20),
                      padding: const EdgeInsets.all(10),
                      onPressed: onSignOutTap,
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: barHeight,
            child: Image.asset(
              Assets.images.banner,
              width: double.infinity,
              height: bannerHeight,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
