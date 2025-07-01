// main_screen.dart
import 'package:auto_route/auto_route.dart';
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
        // Ensure ChatHistoryBloc is provided here and loads its history
        BlocProvider<ChatHistoryBloc>(
          create: (context) => getIt<ChatHistoryBloc>()
            ..add(const LoadChatHistory()), // Dispatch LoadChatHistory event
        ),
      ],
      child: AutoTabsScaffold(
        lazyLoad: false,
        routes: const [
          OverviewRoute(),
          WakiliChatRoute(),
          ChatHistoryRoute(), 
          AccountRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long),
                label: AppLocalizations.getString(context, 'Bills'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.balance),
                label: AppLocalizations.getString(context, 'wakiliChat'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.restore),
                label: AppLocalizations.getString(context, 'History'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_circle),
                label: AppLocalizations.getString(context, 'account'),
              ),
            ],
            currentIndex: tabsRouter.activeIndex,
            selectedItemColor: Colors.blue,
            onTap: tabsRouter.setActiveIndex,
          );
        },
      ),
    );
  }
}
