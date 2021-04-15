package com.example.flutter_template;

import android.location.Location;
import android.os.Build;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class AlarmPlace {
    int alarmId;
    Location location;
    int isActiveAlarm;
    double radius;
    double distance;

    public static List<AlarmPlace> AlarmPlaces = new ArrayList<AlarmPlace>();

    public AlarmPlace() {
        this.alarmId = -1;
        this.distance = -1;
    }

    public void setAlarmPlaces(int _alarmId, int _isActive, double _lat, double _long, double _radius) {
        this.alarmId = _alarmId;
        this.isActiveAlarm = _isActive;
        this.location = new Location(Integer.toString(_alarmId));
        this.location.setLongitude(_long);
        this.location.setLatitude(_lat);
        this.radius = _radius;
    }


    public static void updateAlarmListDistances(Location currentLocation) {

        if (currentLocation != null)
            for (AlarmPlace alarmplace : AlarmPlaces) {
                alarmplace.distance = currentLocation.distanceTo(alarmplace.location);
            }

    }

    public static AlarmPlace getNearestLocation() {
        AlarmPlace nearestAlarmPlace = new AlarmPlace();
        Collections.sort(AlarmPlaces, new Comparator<AlarmPlace>() {
            @Override
            public int compare(AlarmPlace l1, AlarmPlace l2) {
                return Double.compare(l1.distance, l2.distance);
            }
        });

        if (AlarmPlaces != null) {

            if (AlarmPlaces.size() > 0) {
                nearestAlarmPlace = AlarmPlaces.get(0);
            }

        }

        return nearestAlarmPlace;

    }


}

/*
abstract class SortByDistance implements Comparator<AlarmPlace>
{

    @Override
    public int compare(double a, double b)
    {
        return Double.compare(a, b);
    }
}

 */