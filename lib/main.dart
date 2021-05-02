import 'package:Arealarm/view/welcome/view/welcome_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/init/cache/HiveStorage.dart';
import 'view/utils/database/database_manager.dart';
import 'package:provider/provider.dart';
import 'core/constants/application/app_constants.dart';
import 'core/init/lang/language_manager.dart';
import 'core/init/navigation/navigation_route/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'core/init/notifier/provider_list.dart';
import 'core/init/notifier/theme_notifier.dart';
import 'view/home/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await DatabaseManager.instance.databaseInit();
  await HiveStorage.instance.checkFirstUsage();

  //LocalNotifications.instance.initNotifications();

  runApp(MultiProvider(
    providers: [...ApplicationProvider.instance.dependItems],
    child: EasyLocalization(
        child: MyApp(),
        supportedLocales: LanguageManager.instance.supportedLocales,
        path: ApplicationConstants.LANG_ASSET_PATH),
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          HiveStorage.instance.isFirstLoad == true ? WelcomeView() : HomeView(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeNotifier>(context, listen: false).currentTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: NavigationRoute.instance.generateRoute,
      navigatorKey: NavigationService.instance.navigatorKey,
    );

    // return FutureBuilder(
    //   // Replace the 3 second delay with your initialization code:
    //   future: Future.delayed(Duration(seconds: 4)),
    //   builder: (context, AsyncSnapshot snapshot) {
    //     // Show splash screen while waiting for app resources to load:
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return MaterialApp(
    //         home: WelcomeView(),
    //         debugShowCheckedModeBanner: false,
    //         theme:
    //             Provider.of<ThemeNotifier>(context, listen: false).currentTheme,
    //         localizationsDelegates: context.localizationDelegates,
    //         supportedLocales: context.supportedLocales,
    //         locale: context.locale,
    //         onGenerateRoute: NavigationRoute.instance.generateRoute,
    //         navigatorKey: NavigationService.instance.navigatorKey,
    //       );
    //     } else {
    //       // Loading is done, return the app:
    //       return MaterialApp(
    //         debugShowCheckedModeBanner: false,
    //         theme:
    //             Provider.of<ThemeNotifier>(context, listen: false).currentTheme,
    //         localizationsDelegates: context.localizationDelegates,
    //         supportedLocales: context.supportedLocales,
    //         locale: context.locale,
    //         onGenerateRoute: NavigationRoute.instance.generateRoute,
    //         navigatorKey: NavigationService.instance.navigatorKey,
    //         home: HomeView(),
    //         // localizationsDelegates: context.localizationDelegates,
    //         // supportedLocales: context.supportedLocales,
    //         // locale: context.locale,
    //         // onGenerateRoute: NavigationRoute.instance.generateRoute,
    //         // navigatorKey: NavigationService.instance.navigatorKey,
    //       );
    //     }
    //   },
    // );
  }
}
