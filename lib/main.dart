import 'package:wakili/common/helpers/app_router.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/common/notifiers/locale_provider.dart';
import 'package:wakili/common/widgets/global_bloc_observer.dart';
import 'package:wakili/core/di/injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    await dotenv.load(fileName: "env/.env");
  } else {
    Bloc.observer = AppGlobalBlocObserver();
    await dotenv.load(fileName: "env/.dev.env");
  }
  await configureDependencies();
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
        supportedLocales: [
          Locale('en'),
          Locale('es'),
          Locale('fr'),
        ],
        locale: localeProvider.locale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
              selectedIconTheme: IconThemeData(size: 28),
              unselectedIconTheme: IconThemeData(size: 24),
              type: BottomNavigationBarType.fixed,
            )),
        themeMode: ThemeMode.system,
      ),
    );
  }
}
