import 'package:Arealarm/core/constants/application/app_constants.dart';
import 'package:Arealarm/view/settings/model/settings_model.dart';
import '../../alarms/model/alarms_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static DatabaseManager? _instace;
  static DatabaseManager get instance {
    if (_instace == null) _instace = DatabaseManager._init();
    return _instace!;
  }

  int _version = 1;
  String _alarmDatabaseName = "alarms_db";
  String _alarmTable = "alarms_table";

  // Alarm Table Columns
  String alarmId = "alarmId";
  String placeName = "placeName";
  String isAlarmActive = "isAlarmActive";
  String lat = "latitude";
  String long = "longitude";
  String radius = "radius";
  String address = "address";
  String distance = "distance";

  String _settingsTable = "settings_table";
// Settings Table Columns
  String appName = "appName";
  String appVersion = "appVersion";
  String appLanguage = "appLanguage ";
  String theme = "theme";
  String focusMode = "focusMode";
  String description = "description";

  Database? database;
  DatabaseManager._init();

  Future<void> databaseInit() async {
    database = await openDatabase(_alarmDatabaseName, version: _version,
        onCreate: (db, version) async {
      await _createTableSettings(db);
      await _createTableAlarms(db);
      // await initSettings();
    });
  }

  Future<void> _createTableAlarms(Database db) async {
    String sql1 =
        '''CREATE TABLE IF NOT EXISTS $_alarmTable ( id INTEGER PRIMARY KEY AUTOINCREMENT,
         $alarmId INTEGER,
         $placeName TEXT,
         $isAlarmActive INTEGER,
         $lat DOUBLE,
         $long DOUBLE,
         $radius DOUBLE,
         $distance DOUBLE,
         $address TEXT )''';
    await db.execute(sql1);
  }

  Future<void> _createTableSettings(Database db) async {
    String sql2 = '''CREATE TABLE IF NOT EXISTS $_settingsTable (
         $appName TEXT,
         $appVersion TEXT,
         $appLanguage  TEXT,
         $theme TEXT,
         $focusMode INTEGER,
         $description TEXT )''';

    await db.execute(sql2);
  }

  Future<bool> addAlarm(Alarm _alarm) async {
    if (database == null) databaseInit();
    final isAdded = await database!.insert(_alarmTable, _alarm.toJson());
    getAlarmList();

    return isAdded >= 0 ? true : false;
  }

  Future<List<Alarm>> getAlarmList() async {
    if (database == null) databaseInit();
    List<Map<String, dynamic>> alarmList = await database!.query(_alarmTable);

    return alarmList.map((e) => Alarm.fromJson(e)).toList();
  }

  Future<Alarm?> getAlarm(int id) async {
    if (database == null) databaseInit();
    final alarms = await database!.query(
      _alarmTable,
      where: '$alarmId = ?',
      columns: [
        alarmId,
        placeName,
        isAlarmActive,
        lat,
        long,
        radius,
        lat,
        long,
        radius,
        distance,
        address
      ],
      whereArgs: [id],
    );

    if (alarms.isNotEmpty)
      return Alarm.fromJson(alarms.first);
    else
      return null;
  }

  Future<bool> deleteAlarm(int id) async {
    if (database == null) databaseInit();
    final alarms = await database!.delete(
      _alarmTable,
      where: '$alarmId = ?',
      whereArgs: [id],
    );

    return alarms > 0 ? true : false;
  }

  Future<int> getAlarmCount() async {
    if (database == null) databaseInit();
    final alarms = await database!.query(
      _alarmTable,
    );

    var alarmList = alarms.map((e) => Alarm.fromJson(e)).toList();
    if (alarmList.length > 0) {
      alarmList.sort((a, b) => a.alarmId!.compareTo(b.alarmId!));
      return alarmList.last.alarmId!;
    } else {
      return 0;
    }
  }

  Future<bool> deleteAllAlarm() async {
    if (database == null) databaseInit();
    final alarms = await database!.delete(_alarmTable);

    return alarms > 0 ? true : false;
  }

  Future<bool> updateAlarm(int id, Alarm model) async {
    if (database == null) databaseInit();
    final alarms = await database!.update(
      _alarmTable,
      model.toJson(),
      where: '$alarmId = ?',
      whereArgs: [id],
    );

    return alarms > 0 ? true : false;
  }

  ///////////////////////// Settings DB /////////////////////////

  Future<void> initSettings() async {
    if (database == null) databaseInit();

    final isSettingsEnable = await getSettingsCount();
    if (isSettingsEnable == 0) {
      Settings initSettings = new Settings();
      initSettings.appName = ApplicationConstants.APP_NAME;
      initSettings.appVersion = ApplicationConstants.APP_VERSION;
      initSettings.appLanguage = "en";
      initSettings.focusMode = 0;
      await database!.insert(_settingsTable, initSettings.toJson());
    }
  }

  Future<void> updateSettigs(Settings _settings) async {
    if (database == null) databaseInit();

    final isSettingsEnable = await getSettingsCount();
    if (isSettingsEnable > 0) {
      await database!.update(_settingsTable, _settings.toJson());
    } else {
      initSettings();
    }
  }

  Future<Settings?> getSettings() async {
    if (database == null) databaseInit();
    final settings = await database!.query(_settingsTable,
        columns: [appName, appVersion, focusMode, appLanguage]);

    if (settings.isNotEmpty)
      return Settings.fromJson(settings.first);
    else
      return null;
  }

  Future<int> getSettingsCount() async {
    if (database == null) databaseInit();
    final settings = await database!.query(
      _settingsTable,
    );
    return settings.length;
  }

  Future<void> close() async {
    database!.close();
  }
}
