import '../../alarms/model/alarms_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  static DatabaseManager? _instace;
  static DatabaseManager get instance {
    if (_instace == null) _instace = DatabaseManager._init();
    return _instace!;
  }

  int _version = 3;
  String _alarmDatabaseName = "alarms_db2";
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

  Database? database;
  DatabaseManager._init();

  Future<void> databaseInit() async {
    database = await openDatabase(_alarmDatabaseName, version: _version,
        onCreate: (db, version) async {
      await _createDatabase(db);
    });
  }

  Future<void> _createDatabase(Database db) async {
    String sql =
        '''CREATE TABLE IF NOT EXISTS $_alarmTable ( id INTEGER PRIMARY KEY AUTOINCREMENT,
         $alarmId INTEGER,
         $placeName VARCHAR(100),
         $isAlarmActive INTEGER,
         $lat DOUBLE,
         $long DOUBLE,
         $radius DOUBLE,
         $distance DOUBLE,
         $address TEXT )''';
    await db.execute(sql);
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
      columns: [alarmId],
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
      return alarmList.last.alarmId! + 1;
    } else {
      return 1;
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

  Future<void> close() async {
    database!.close();
  }
}
