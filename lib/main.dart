// main.dart
import 'package:wakili/common/helpers/app_router.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/common/notifiers/locale_provider.dart';
import 'package:wakili/common/widgets/global_bloc_observer.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Keep this import for Bloc.observer
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import hive_flutter
import 'package:path_provider/path_provider.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart'; // Import chat message model

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dotenv for environment variables
  if (kReleaseMode) {
    await dotenv.load(fileName: "env/.env");
  } else {
    Bloc.observer = AppGlobalBlocObserver(); // For debug mode Bloc observation
    await dotenv.load(fileName: "env/.dev.env");
  }

  // Configure dependency injection
  await configureDependencies();

  // Initialize Hive for local storage
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(ChatConversationAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  configureDependencies();

  // Initialize locale provider
  final localeProvider = LocaleProvider();
  localeProvider.loadLocale(); 

  runApp(ChangeNotifierProvider(
    create: (_) => localeProvider,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final systemUiOverlayStyle =
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? SystemUiOverlayStyle.light // Light icons for dark theme
            : SystemUiOverlayStyle.dark; // Dark icons for light theme

    final localeProvider = Provider.of<LocaleProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: !kReleaseMode,
        title: AppLocalizations.getString(context, 'appName'),
        routerConfig: _appRouter.config(),
        localizationsDelegates: [
          AppLocalizations.delegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [
          // Use const for supportedLocales
          Locale('en'),
          Locale('es'),
          Locale('fr'),
        ],
        locale: localeProvider.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            // Add const
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
