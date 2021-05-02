import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveStorage {
  static HiveStorage? _instace;
  static HiveStorage get instance {
    if (_instace == null) _instace = HiveStorage._init();
    return _instace!;
  }

  HiveStorage._init();
  bool isFirstLoad = true;

  Future<void> checkFirstUsage() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    var appSettings = await Hive.openBox('arealarmSettings');
    try {
      var firstTimeRun = appSettings.get('firstTimeRun');

      if (firstTimeRun == null) {
        print("null");
        isFirstLoad = true;
        appSettings.put("firstTimeRun", false);
      } else {
        isFirstLoad = false;
        print('firstTimeRun: $isFirstLoad');
      }
      // print('firstTimeRun: $isFirstLoad');
    } catch (e) {
      print(e);
    }
  }
}
