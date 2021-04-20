package com.example.flutter_template;

import android.location.Location;
import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class AlarmPlace implements Parcelable {
    int alarmId;
    Location location;
    int isActiveAlarm;
    double radius;
    double distance;

    protected AlarmPlace(Parcel in) {
        alarmId = in.readInt();
        location = (Location) in.readValue(Location.class.getClassLoader());
        isActiveAlarm = in.readInt();
        radius = in.readDouble();
        distance = in.readDouble();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(alarmId);
        dest.writeValue(location);
        dest.writeInt(isActiveAlarm);
        dest.writeDouble(radius);
        dest.writeDouble(distance);
    }

    @SuppressWarnings("unused")
    public static final Parcelable.Creator<AlarmPlace> CREATOR = new Parcelable.Creator<AlarmPlace>() {
        @Override
        public AlarmPlace createFromParcel(Parcel in) {
            return new AlarmPlace(in);
        }

        @Override
        public AlarmPlace[] newArray(int size) {
            return new AlarmPlace[size];
        }
    };


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


}

