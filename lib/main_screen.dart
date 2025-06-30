// main_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:wakili/features/favourites/presentation/bloc/favourites_bloc.dart';
import 'package:wakili/features/hotels/presentation/bloc/hotels_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HotelsBloc>()),
        BlocProvider(create: (context) => getIt<FavouritesBloc>()),
        BlocProvider(create: (context) => getIt<AccountBloc>()),
      ],
      child: AutoTabsScaffold(
        lazyLoad: false,
        routes: const [
          OverviewRoute(),
          HotelsRoute(),
          FavouritesRoute(),
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
                label: AppLocalizations.getString(context, 'Wakili'),
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
