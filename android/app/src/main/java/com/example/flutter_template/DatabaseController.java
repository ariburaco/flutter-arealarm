package com.example.flutter_template;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

public class DatabaseController extends SQLiteOpenHelper {

    private static final int _version = 3;
    private static final String _alarmDatabaseName = "alarms_db2";
    private static final String _alarmTable = "alarms_table";

    // Alarm Table Columns
    private static final String id = "id";
    private static final String alarmId = "alarmId";
    private static final String placeName = "placeName";
    private static final String isAlarmActive = "isAlarmActive";
    private static final String lat = "latitude";
    private static final String longu = "longitude";
    private static final String radius = "radius";
    private static final String address = "address";
    private static final String distance = "distance";


    List<AlarmPlace> alarmList;

    public DatabaseController(Context context) {
        super(context, _alarmDatabaseName, null, _version);
        //3rd argument to be passed is CursorFactory instance
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {

    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        // Drop older table if existed
        sqLiteDatabase.execSQL("DROP TABLE IF EXISTS " + _alarmDatabaseName);

        // Create tables again
        onCreate(sqLiteDatabase);
    }

    public int getActiveAlarmsCount() {
        return getAllAlarmList().size();
    }

    public List<AlarmPlace> getAllAlarmList() {
        alarmList = new ArrayList<>();
        // Select All Query
        String selectQuery = "SELECT * FROM " + _alarmTable + " WHERE " + isAlarmActive + " = 1";

        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery(selectQuery, null);

        if (cursor.moveToFirst()) {
            do {


                AlarmPlace alarmplace = new AlarmPlace();
                int alarmId = (cursor.getInt(1));
                String placeName = (cursor.getString(2));
                int isAlarmActive = (cursor.getInt(3));
                double lat = (cursor.getDouble(4));
                double longu = (cursor.getDouble(5));
                double radius = (cursor.getDouble(6));
                double distance = (cursor.getDouble(7));

                alarmplace.setAlarmPlaces(alarmId, isAlarmActive , lat, longu, radius);
                alarmplace.distance = distance;

                Log.i("DATABASE", "alarmId: " + alarmId + " radius: " + alarmplace.radius);
                alarmList.add(alarmplace);
            } while (cursor.moveToNext());
        }

        db.close();
        return alarmList;
    }

    private void updateAlarm(int _alarmId, int _isAlarmActive) {
        SQLiteDatabase db = this.getWritableDatabase();



        ContentValues values = new ContentValues();
        values.put(isAlarmActive, _isAlarmActive);

        // updating row
        db.update(_alarmTable, values, alarmId + " = ?",
                new String[]{Integer.toString(_alarmId)});
        db.close();
    }

    public void removeAlarm(AlarmPlace _alarmPlace) {
        updateAlarm(_alarmPlace.alarmId, 0);
    }

}