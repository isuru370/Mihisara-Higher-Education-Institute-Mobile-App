import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'core/theme/app_theme.dart';
import 'route_observer.dart';
import 'routes/app_route.dart';


class NexoraMobileApp extends StatelessWidget {
  const NexoraMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      title: 'Education Mobile App',
      // GLOBAL THEME
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorObservers: [routeObserver],
    );
  }
}
