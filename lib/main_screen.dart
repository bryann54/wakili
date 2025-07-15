import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/widgets/bottom_nav_widget.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/overview/presentation/bloc/overview_bloc.dart';
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
        BlocProvider(create: (context) => getIt<OverviewBloc>(),),
        BlocProvider<ChatHistoryBloc>(
          create: (context) =>
              getIt<ChatHistoryBloc>()..add(const LoadChatHistory()),
        ),
      ],
      child: AutoTabsScaffold(
        lazyLoad: false,
        homeIndex: 1,
        routes: const [
          WakiliChatRoute(),
          OverviewRoute(),
          ChatHistoryRoute(),
          AccountRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return CustomFlashyBottomNav(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
          );
        },
      ),
    );
  }
}
