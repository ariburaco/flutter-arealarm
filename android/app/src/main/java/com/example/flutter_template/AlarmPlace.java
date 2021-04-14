package com.example.flutter_template;

import android.location.Location;

public class AlarmPlace {
    int alarmId;
    Location location;
    int isActiveAlarm;
    double radius;


    public AlarmPlace()
    {
        this.alarmId = -1;
    }

    public void setAlarmPlaces(int _alarmId, int _isActive, double _lat, double _long, double _radius)
    {
        this.alarmId = _alarmId;
        this.isActiveAlarm = _isActive;
        this.location = new Location(Integer.toString(_alarmId));
        this.location.setLongitude(_long);
        this.location.setLatitude(_lat);
        this.radius = _radius;
    }
}
