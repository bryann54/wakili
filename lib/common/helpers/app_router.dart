import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthBloc authBloc;

  AuthGuard(this.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final currentUserState = authBloc.state;
    if (currentUserState is AuthAuthenticated) {
      resolver.next(true); // Allow navigation
    } else if (currentUserState is AuthUnauthenticated) {
      // Redirect to login if not authenticated
      router.replace(const LoginRoute());
    } else {
      router.replace(const LoginRoute());
    }
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: GetStartedRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(
          page: MainRoute.page,
          guards: [AuthGuard(authBloc)],
          children: [
            AutoRoute(page: OverviewRoute.page),
            AutoRoute(page: WakiliChatRoute.page),
            AutoRoute(page: ChatHistoryRoute.page),
            AutoRoute(page: AccountRoute.page),
          ],
        ),
        AutoRoute(page: CategoryChatRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: GeneralChatRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(
          page: ChatRoute.page,
          guards: [AuthGuard(authBloc)],
        ),
        AutoRoute(
            page: DocumentDetailRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: PaymentRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: EditProfileRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: HelpSupportRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: TipsTricksRoute.page, guards: [AuthGuard(authBloc)]),
      ];
}
