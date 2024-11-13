import 'package:dio/dio.dart';
import 'package:entain_test/networking/provider/api_provider.dart';
import 'package:entain_test/router/page_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'generated/l10n.dart';
import 'networking/api_client.dart';

void main() {
  runApp(EntainTestApp(router: PageRouter().pageRouter));
  setupDI();
}

void setupDI() {
  GetIt.I.registerSingleton<ApiClient>(ApiClient(Dio()));
  GetIt.I.registerSingleton<ApiProvider>(ApiProvider(GetIt.I<ApiClient>()));
}

class EntainTestApp extends StatelessWidget {
  final GoRouter router;

  const EntainTestApp({super.key, required this.router});

  final primaryColor =  const Color(0xff0094CE);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      title: 'Flutter Demo',
      localizationsDelegates:  const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        // don't put const, xcode complains
        appBarTheme:  AppBarTheme(
          color: primaryColor,
          //other options
        ),
        useMaterial3: true,
      ),

    );
  }
}

