package com.example.flutter_template;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.os.SystemClock;
import android.provider.ContactsContract;
import android.util.Log;

import com.tekartik.sqflite.Constant;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
//import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import static android.app.Notification.EXTRA_NOTIFICATION_ID;
import static androidx.core.app.NotificationCompat.PRIORITY_MAX;
import static com.example.flutter_template.Constants.MIN_DISTANCE_CHANGE_FOR_UPDATES;
import static com.example.flutter_template.Constants.MIN_TIME_BW_UPDATES;
import static com.example.flutter_template.Constants.SERVICE_NOTIFICATION;

public class LocationService extends Service implements LocationListener {

    boolean isGPSEnabled = false;
    boolean canGetLocation = false;
    boolean isNetworkEnabled = false;
    boolean isAlarmsActive = true;
    boolean inRange = false;

    double latitude = 0; // latitude
    double longitude = 0; // longitude

    Location location; // location
    protected LocationManager locationManager;

    NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;
    List<AlarmPlace> placeList = new ArrayList<>();
    AlarmPlace nearestPlace;


    @Override
    public void onCreate() {
        super.onCreate();
        getActiveAlarmsFromDB();
        startLocationServiceWithNotification();
        registerNotificationReciever();
    }

    private void registerNotificationReciever() {
        IntentFilter filter = new IntentFilter(Constants.GOT_IT);
        BroadcastReceiver mReceiver = new NotificationReceiver();
        registerReceiver(mReceiver, filter);
    }

    private void getActiveAlarmsFromDB() {
        placeList = DatabaseController.getInstance(getApplicationContext()).getAllAlarmList();

        if (placeList.size() > 0)
            isAlarmsActive = true;
        else
            isAlarmsActive = false;
    }

    private void removeAlarmFromDB(AlarmPlace _alarmPlace) {
        if (_alarmPlace != null)
            DatabaseController.getInstance(getApplicationContext()).removeAlarm(_alarmPlace);
        else
            Log.i("Database", "removeAlarmFromDB null _alarmplace");
    }

    private void removeAllAlarms() {
        for (AlarmPlace alarmPlace : placeList) {
            removeAlarmFromDB(alarmPlace);
        }
    }

    private void startLocationServiceWithNotification() {
        getServiceNotification();
        getLocation();
        startForeground(SERVICE_NOTIFICATION, builder.build());
    }

    private void createAlarmNotification(AlarmPlace currentAlarm) {
        CustomNotification newNotification = new CustomNotification(this);
        newNotification.showNotification(currentAlarm, "You're in the range of place #" + currentAlarm.alarmId);
        Log.i("NOTIFY", "You're in the range of place #" + currentAlarm.alarmId);
    }

    private void checkInRange() {
        if (nearestPlace.alarmId != -1) {
            if (nearestPlace.distance <= nearestPlace.radius) {
                inRange = true;
                createAlarmNotification(nearestPlace);
            } else {
                inRange = false;
            }
        }
    }

    @SuppressLint("MissingPermission")
    public Location getLocation() {
        try {
            locationManager = (LocationManager) getBaseContext().getSystemService(LOCATION_SERVICE);
            isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
            if (!isGPSEnabled) { // && !isNetworkEnabled
            } else {
                canGetLocation = true;
                /*
                if (!isNetworkEnabled) {
                    locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, MIN_TIME_BW_UPDATES, MIN_DISTANCE_CHANGE_FOR_UPDATES,
                            this);
                    if (locationManager != null) {
                        location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
                        if (location != null) {
                            latitude = location.getLatitude();
                            longitude = location.getLongitude();
                        }
                    }
                }
                **/

                if (isGPSEnabled) {
                    if (location == null) {
                        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MIN_TIME_BW_UPDATES, MIN_DISTANCE_CHANGE_FOR_UPDATES,
                                this);
                        Log.d("GPS", "GPS Enabled");
                        if (locationManager != null) {
                            location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                            if (location != null) {
                                latitude = location.getLatitude();
                                longitude = location.getLongitude();
                            }
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return location;
    }

    @Override
    public void onLocationChanged(Location loc) {
        location = loc;
        getActiveAlarmsFromDB();
        updateLocationNotification();
        // Log.i("locationCHANGED", "Current Loc. " + location);
    }

    public void updateLocationNotification() {
        if (isAlarmsActive) {
            if (location != null) {
                updateAlarmListDistances(location);
                nearestPlace = getNearestLocation();
                if (nearestPlace != null) {
                    if (nearestPlace.alarmId != -1) {
                        checkInRange();
                        double distance = Math.round(nearestPlace.distance * 10.0) / 10.0;
                        String text = "Nearest target: " + distance + " meters at Alarm #" + nearestPlace.alarmId + " radius: " + nearestPlace.radius;
                        notifyService(text);
                        Log.i("nearestPlace", text);
                    }
                } else {

                    Log.i("nearestPlace", "nearestPlace NULL");
                }
            } else {
                location = getLocation();
                Log.i("LOCATION CHANGED", "NULL");
            }
        } else {
            String text = "No Active Alarms";
            notifyService(text);
        }
    }

    public  void notifyService(String text){
        builder.setContentText(text);
        mNotificationManager.notify(SERVICE_NOTIFICATION, builder.build());
    }

    public Notification getServiceNotification() {
        String channel;

        mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            channel = createChannel();
        else {
            channel = "";
        }
        //Uri uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        /*
        Intent snoozeIntent = new Intent(this, MainActivity.class);
        snoozeIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
        PendingIntent snoozePendingIntent =
                PendingIntent.getBroadcast(this, 0, snoozeIntent, 0);
        */
        builder = new NotificationCompat.Builder(this, channel)
                .setSmallIcon(android.R.drawable.ic_menu_mylocation)
                .setContentTitle("Arealarm");

        Notification notification = builder
                .setPriority(PRIORITY_MAX)
                .setNotificationSilent()
                //.setSound(uri)
                .setCategory(Notification.CATEGORY_SERVICE)
                //.addAction(R.drawable.app_icon, "Stop All", snoozePendingIntent)
                .build();
        return notification;
    }


    public void updateAlarmListDistances(Location currentLocation) {
        if (placeList.size() > 0) {
            for (AlarmPlace place : placeList) {
                place.calculateDistance(currentLocation);
            }
        }
    }

    public AlarmPlace getNearestLocation() {
        AlarmPlace nearestAlarmPlace = new AlarmPlace();
        Collections.sort(placeList, (l1, l2) -> Double.compare(l1.distance, l2.distance));
        if (placeList != null) {
            if (placeList.size() > 0) {
                nearestAlarmPlace = placeList.get(0);
            }
        }
        return nearestAlarmPlace;

    }


    @NonNull
    @TargetApi(26)
    private synchronized String createChannel() {


        String name = "LocationService";
        int importance = NotificationManager.IMPORTANCE_HIGH;

        NotificationChannel mChannel = new NotificationChannel("snap map channel", name, importance);
        //Uri uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        // mChannel.enableLights(true);

        //mChannel.setLightColor(Color.BLUE);
        if (mNotificationManager != null) {
            mNotificationManager.createNotificationChannel(mChannel);
        } else {
            stopSelf();
        }
        return "snap map channel";
    }


    @Override
    public void onTaskRemoved(Intent rootIntent) {
        super.onTaskRemoved(rootIntent);
    }

    @Override
    public void onProviderDisabled(String arg0) {
    }

    @Override
    public void onProviderEnabled(String arg0) {
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return START_STICKY;
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }


}