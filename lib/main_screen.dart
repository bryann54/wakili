import 'package:auto_route/auto_route.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<WakiliBloc>()),
        BlocProvider(create: (context) => getIt<AccountBloc>()),
        BlocProvider<ChatHistoryBloc>(
          create: (context) =>
              getIt<ChatHistoryBloc>()..add(const LoadChatHistory()),
        ),
      ],
      child: AutoTabsScaffold(
        lazyLoad: false,
        homeIndex: 1,
        routes: const [
          OverviewRoute(),
          WakiliChatRoute(),
          ChatHistoryRoute(),
          AccountRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _BottomNavIcon(
                      icon: FontAwesomeIcons.landmark,
                      isActive: tabsRouter.activeIndex == 0,
                    ),
                    activeIcon: _BottomNavIcon(
                      icon: FontAwesomeIcons.landmark,
                      isActive: true,
                    ),
                    label: AppLocalizations.getString(context, 'Bills'),
                  ),
                  BottomNavigationBarItem(
                    icon: _BottomNavIcon(
                      icon: FontAwesomeIcons.comments,
                      isActive: tabsRouter.activeIndex == 1,
                    ),
                    activeIcon: _BottomNavIcon(
                      icon: FontAwesomeIcons.solidComments,
                      isActive: true,
                    ),
                    label: AppLocalizations.getString(context, 'wakiliChat'),
                  ),
                  BottomNavigationBarItem(
                    icon: _BottomNavIcon(
                      icon: FontAwesomeIcons.clockRotateLeft,
                      isActive: tabsRouter.activeIndex == 2,
                    ),
                    activeIcon: _BottomNavIcon(
                      icon: FontAwesomeIcons.clockRotateLeft,
                      isActive: true,
                    ),
                    label: AppLocalizations.getString(context, 'History'),
                  ),
                  BottomNavigationBarItem(
                    icon: _BottomNavIcon(
                      icon: FontAwesomeIcons.user,
                      isActive: tabsRouter.activeIndex == 3,
                    ),
                    activeIcon: _BottomNavIcon(
                      icon: FontAwesomeIcons.solidUser,
                      isActive: true,
                    ),
                    label: AppLocalizations.getString(context, 'account'),
                  ),
                ],
                currentIndex: tabsRouter.activeIndex,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.grey[600],
                selectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                onTap: tabsRouter.setActiveIndex,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _BottomNavIcon({
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(
          icon,
          size: 20,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
        ),
        const SizedBox(height: 4),
        if (isActive)
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
  }
}
