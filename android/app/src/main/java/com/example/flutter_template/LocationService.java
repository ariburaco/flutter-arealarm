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
import android.util.Log;

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

public class LocationService extends Service implements LocationListener {

    boolean isGPSEnabled = false;
    boolean canGetLocation = false;
    boolean isNetworkEnabled = false;

    static Location location; // location
    double latitude = 0; // latitude
    double longitude = 0; // longitude

    private static final long MIN_DISTANCE_CHANGE_FOR_UPDATES = 0;
    private static final long MIN_TIME_BW_UPDATES = 5 * 1000;

    protected LocationManager locationManager;
    NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;

    public List<AlarmPlace> placeList = new ArrayList<>();


    @Override
    public void onCreate() {
        super.onCreate();
        startLocationServiceWithNotification();

    }

    private void startLocationServiceWithNotification() {

        getLocation();
        getNotification();
        startForeground(101, builder.build());
    }


    public void addAlarmPTolaceList(AlarmPlace alarmPlace) {
        if (alarmPlace != null) {
            if (!placeList.contains(alarmPlace)) {
                placeList.add(alarmPlace);
                updateLocationNotification();
            } else {
                Log.i("ALARM", "Alarm Already ADDED BEFORE");
            }

            Log.i("AlarmPlaces Count", "" + placeList.size());
        }
    }

    public void clearAllAlarmPlaces() {
        placeList.clear();
    }

    private int getAlarmPlaceFromActivity(Intent intent) {
        if (intent.hasExtra("key")) {

            Bundle bundle = intent.getExtras();
            AlarmPlace alarmPlace = (AlarmPlace) bundle.getParcelable("key");
            if (alarmPlace != null) {
                addAlarmPTolaceList(alarmPlace);

            }
            return START_STICKY;
        } else if (intent.getAction() != null) {
            if (intent.getAction().equals(Constants.STOPFOREGROUND_ACTION)) {
                //locationManager.removeUpdates(this);
                clearAllAlarmPlaces();
                stopForeground(true);
                stopSelf();
                return START_NOT_STICKY;
            } else {
                return START_STICKY;
            }
        } else {
            return START_STICKY;
        }

    }


    @SuppressLint("MissingPermission")
    public Location getLocation() {
        try {
            locationManager = (LocationManager) getBaseContext().getSystemService(LOCATION_SERVICE);

            // getting GPS status
            isGPSEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);

            // getting network status
            isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

            if (!isGPSEnabled) { // && !isNetworkEnabled
                // no network provider is enabled. DEFAULT COORDINATES


            } else {


                canGetLocation = true;
                if (!isNetworkEnabled) {
                    locationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, MIN_TIME_BW_UPDATES, MIN_DISTANCE_CHANGE_FOR_UPDATES,
                            this);
                    // Log.d("Network", "Network Enabled");
                    if (locationManager != null) {
                        location = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
                        if (location != null) {
                            latitude = location.getLatitude();
                            longitude = location.getLongitude();
                        }
                    }
                }


                // if GPS Enabled get lat/long using GPS Services
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
        //  Log.i("LOCATION", "Latitude: " + latitude + "- Longitude: " + longitude);
        return location;
    }


    @Override
    public void onLocationChanged(Location loc) {
        //Location loc = getLocation();
        location = loc;
        updateLocationNotification();
        Log.i("locationCHANGED", "Current Loc. " + location);

    }

    public void updateLocationNotification() {

        if (location != null) {
            updateAlarmListDistances(location);
            AlarmPlace nearestPlace = getNearestLocation();
            if (nearestPlace != null) {

                double distance = Math.round(nearestPlace.distance * 100.0) / 100.0;
                String text = "Nearest target: " + distance + " meters at Alarm #" + nearestPlace.alarmId;
                builder.setContentText(text);
                mNotificationManager.notify(101, builder.build());

            }
            // sendMessageToActivity(nearestPlace.distance, "fromService");
            //Log.i("LOCATION CHANGED", "Distance to nearest target: " + nearestPlace.distance + " at " + nearestPlace.alarmId);
        } else {
            Log.i("LOCATION CHANGED", "NULL");
        }
    }


    public Notification getNotification() {
        String channel;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            channel = createChannel();
        else {
            channel = "";
        }
        //Uri uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);

        Intent snoozeIntent = new Intent(this, MainActivity.class);
        snoozeIntent.putExtra(EXTRA_NOTIFICATION_ID, 0);
        PendingIntent snoozePendingIntent =
                PendingIntent.getBroadcast(this, 0, snoozeIntent, 0);

        builder = new NotificationCompat.Builder(this, channel)
                .setSmallIcon(android.R.drawable.ic_menu_mylocation)
                .setContentTitle("Arealarm");

        Notification notification = builder
                .setPriority(PRIORITY_MAX)
                .setNotificationSilent()
                //.setSound(uri)
                .setCategory(Notification.CATEGORY_SERVICE)
                .addAction(R.drawable.app_icon, "Stop", snoozePendingIntent)
                .build();


        return notification;
    }


    public void updateAlarmListDistances(Location currentLocation) {

        if (currentLocation != null) {
            for (AlarmPlace place : placeList) {
                place.distance = currentLocation.distanceTo(place.location);
            }

        } else
            Log.i("NULL LOCATION", "null");

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
        mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);

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
        /*Intent restartServiceIntent = new Intent(getApplicationContext(), LocationService.class);
        restartServiceIntent.setPackage(getPackageName());

        PendingIntent restartServicePendingIntent = PendingIntent.getService(getApplicationContext(), 1, restartServiceIntent, PendingIntent.FLAG_ONE_SHOT);
        AlarmManager alarmService = (AlarmManager) getApplicationContext().getSystemService(Context.ALARM_SERVICE);
        alarmService.set(
                AlarmManager.ELAPSED_REALTIME,
                SystemClock.elapsedRealtime() + 1000,
                restartServicePendingIntent);
        */
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
        return getAlarmPlaceFromActivity(intent);
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }


}