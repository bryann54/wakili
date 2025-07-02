// features/account/presentation/screens/account_screen.dart (Example)
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Account Details'),
            // Display user info from AuthBloc if needed
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Column(
                    children: [
                      Text('Logged in as: ${state.user.email ?? 'N/A'}'),
                      Text('UID: ${state.user.uid}'),
                    ],
                  );
                }
                return const Text('Not logged in');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSignOut());
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
