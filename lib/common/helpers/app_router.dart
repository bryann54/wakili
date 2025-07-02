import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart'; // Import your AuthBloc

// Define a RouteGuard to protect routes
class AuthGuard extends AutoRouteGuard {
  final AuthBloc authBloc;

  AuthGuard(this.authBloc);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    // You can listen to the AuthBloc state here, or directly query its current state
    authBloc.stream.listen((state) {
      if (state is AuthAuthenticated) {
        resolver.next(true); // Allow navigation
      } else if (state is AuthUnauthenticated) {
        // Redirect to login if not authenticated
        router.replace(const LoginRoute());
      }
    }).cancel(); // Cancel the subscription immediately after checking

    // It's crucial to check the current state as well,
    // in case the stream hasn't emitted a new state yet.
    final currentUserState = authBloc.state;
    if (currentUserState is AuthAuthenticated) {
      resolver.next(true);
    } else if (currentUserState is AuthUnauthenticated) {
      router.replace(const LoginRoute());
    } else {
      // If the state is still loading or initial, you might want to wait
      // or navigate to the splash screen to ensure proper state resolution.
      // For simplicity here, we'll assume the splash screen handles initial check.
      // For protected routes, it's safer to redirect if not authenticated.
      router.replace(const LoginRoute());
    }
  }
}

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  final AuthBloc authBloc; // Inject AuthBloc

  AppRouter({required this.authBloc}); // Constructor to receive AuthBloc

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
            page: SplashRoute.page, initial: true), // Set Splash as initial
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: RegisterRoute.page),
        AutoRoute(
          page: MainRoute.page,
          guards: [AuthGuard(authBloc)], // Protect MainRoute and its children
          children: [
            AutoRoute(page: OverviewRoute.page),
            AutoRoute(page: WakiliChatRoute.page),
            AutoRoute(page: ChatHistoryRoute.page),
            AutoRoute(page: AccountRoute.page),
          ],
        ),
        AutoRoute(page: CategoryChatRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: GeneralChatRoute.page, guards: [AuthGuard(authBloc)]),
        AutoRoute(page: ChatRoute.page, guards: [AuthGuard(authBloc)]),
      ];
}
