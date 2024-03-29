import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../view/utils/provider/alarm_provider.dart';
import 'theme_notifier.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;
  static ApplicationProvider get instance {
    if (_instance == null) _instance = ApplicationProvider._init();
    return _instance!;
  }

  ApplicationProvider._init();

  List<SingleChildWidget> singleItems = [];
  List<SingleChildWidget> dependItems = [
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => AlarmProvider(),
    ),
    // ChangeNotifierProvider(
    //   create: (context) => BackgroundServiceProdiver(),
    // ),
    // Provider.value(value: NavigationService.instance)
  ];
  List<SingleChildWidget> uiChangesItems = [];
}
