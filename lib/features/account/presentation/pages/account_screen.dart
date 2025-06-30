import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/notifiers/locale_provider.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountBloc accountBloc = context.read<AccountBloc>();
    final provider = Provider.of<LocaleProvider>(context);
    final currentLocale = provider.locale;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.getString(context, 'account')),
      ),
      body: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is ChangeLanguageSuccess) {
            provider.setLocale(Locale(state.langCode));
          }
        },
        child: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountLoadingState) {
              return CircularProgressIndicator.adaptive();
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.getString(context, 'language')),
                  SizedBox(height: 20),
                  state is ChangeLanguageError
                      ? Column(
                          children: [
                            Text(state.error),
                            const SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () {
                                accountBloc.add(
                                  ChangeLanguageEvent(langCode: state.lang),
                                );
                              },
                              child: Text(
                                AppLocalizations.getString(context, 'retry'),
                              ),
                            ),
                          ],
                        )
                      : DropdownButton<Locale>(
                          value: currentLocale,
                          items: [
                            DropdownMenuItem(
                              value: Locale('en'),
                              child: Text(
                                AppLocalizations.getString(context, 'english'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: Locale('fr'),
                              child: Text(
                                AppLocalizations.getString(context, 'french'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: Locale('es'),
                              child: Text(
                                AppLocalizations.getString(context, 'spanish'),
                              ),
                            ),
                          ],
                          onChanged: (locale) {
                            if (locale != null) {
                              accountBloc.add(
                                ChangeLanguageEvent(
                                  langCode: locale.languageCode,
                                ),
                              );
                            }
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
