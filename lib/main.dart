// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:wakili/common/helpers/app_router.dart';
// import 'package:wakili/common/res/l10n.dart'; // REMOVED: No longer needed for AppLocalizations
import 'package:wakili/common/notifiers/locale_provider.dart'; // Keep if LocaleProvider is used for other locale-related things, even if not for translations
import 'package:wakili/common/widgets/global_bloc_observer.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode) {
    await dotenv.load(fileName: "env/.env");
  } else {
    Bloc.observer = AppGlobalBlocObserver();
    await dotenv.load(fileName: "env/.dev.env");
  }

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatConversationAdapter());
  Hive.registerAdapter(ChatMessageAdapter());

  // Configure dependency injection
  await configureDependencies();

  // Initialize locale provider (Keep this if LocaleProvider manages other non-translation locale settings)
  final localeProvider = LocaleProvider();
  localeProvider.loadLocale();

  final AuthBloc authBloc = getIt<AuthBloc>();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => localeProvider),
        BlocProvider<AuthBloc>(
          create: (context) => authBloc,
          lazy: false,
        ),
      ],
      child: MyApp(authBloc: authBloc),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthBloc authBloc;
  late final AppRouter _appRouter;

  MyApp({super.key, required this.authBloc}) {
    _appRouter = AppRouter(authBloc: authBloc);
  }

  @override
  Widget build(BuildContext context) {
    final systemUiOverlayStyle =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: !kReleaseMode,
        routerConfig: _appRouter.config(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedIconTheme: IconThemeData(size: 28),
            unselectedIconTheme: IconThemeData(size: 24),
            type: BottomNavigationBarType.fixed,
          ),
        ),
        darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.grey[900],
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey[500],
              selectedIconTheme: const IconThemeData(size: 28),
              unselectedIconTheme: const IconThemeData(size: 24),
              type: BottomNavigationBarType.fixed,
            )),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
