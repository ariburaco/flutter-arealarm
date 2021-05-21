package com.phibox.arealarm;

import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
//import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import static androidx.core.app.NotificationCompat.PRIORITY_MAX;
import static com.phibox.arealarm.Constants.MIN_DISTANCE_CHANGE_FOR_UPDATES;
import static com.phibox.arealarm.Constants.MIN_TIME_BW_UPDATES;
import static com.phibox.arealarm.Constants.SERVICE_NOTIFICATION;

public class LocationService extends Service implements LocationListener {

    boolean isGPSEnabled = false;
    boolean canGetLocation = false;
    boolean isNetworkEnabled = false;
    boolean isAlarmsActive = true;
    boolean inRange = false;

    double latitude = 0;
    double longitude = 0;
    boolean isServiceEnabled = false;

    Location location;
    LocationManager locationManager;

    NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;
    List<AlarmPlace> placeList = new ArrayList<>();
    AlarmPlace nearestPlace;
    BroadcastReceiver actionReciever;


    @Override
    public void onCreate() {
        super.onCreate();
        startService();
    }

    private void startService(){
        getActiveAlarmsFromDB();
        startLocationServiceWithNotification();
        registerNotificationReciever();
    }


    private void registerNotificationReciever() {
        IntentFilter gotItIntent = new IntentFilter(Constants.GOT_IT);
        actionReciever = new NotificationReceiver();
        registerReceiver(actionReciever, gotItIntent);
    }

    private void unregisterNotificationReciever(){
        unregisterReceiver(actionReciever);
    }

    private void getActiveAlarmsFromDB() {
        placeList = DatabaseController.getInstance(getApplicationContext()).getAllAlarmList();

        if (placeList.size() > 0)
            isAlarmsActive = true;
        else
            isAlarmsActive = false;
    }

    private void startLocationServiceWithNotification() {
        getLocation();
        getServiceNotification();
        startForeground(SERVICE_NOTIFICATION, builder.build());
        isServiceEnabled = true;
    }

    private void createAlarmNotification() {
        CustomNotification newNotification = new CustomNotification(this);
        newNotification.showNotification(nearestPlace, "You're in the range of place #" + nearestPlace.alarmId);
       // Log.i("NOTIFY", "You're in the range of place #" + nearestPlace.alarmId);
    }

    private void checkInRange() {
        if (nearestPlace.alarmId != -1) {
            if (nearestPlace.distance <= nearestPlace.radius) {
                inRange = true;
                createAlarmNotification();
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
                if (isGPSEnabled) {
                    locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, MIN_TIME_BW_UPDATES, MIN_DISTANCE_CHANGE_FOR_UPDATES,
                            this);
                    //Log.d("GPS", "GPS Enabled");
                    if (locationManager != null) {
                        location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                        if (location != null) {
                            latitude = location.getLatitude();
                            longitude = location.getLongitude();
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
        //Log.i("LOCATION", "onLocationChanged: " + location);
    }

    public void updateLocationNotification() {
        if (isAlarmsActive) {
            if (location != null) {
                updateAlarmListDistances(location);
                nearestPlace = getNearestLocation();
                if (nearestPlace != null) {
                    if (nearestPlace.alarmId != -1) {
                        checkInRange();
                        double distance = Math.round(nearestPlace.distance - nearestPlace.radius);
                        if (distance <= 0) distance = 0;
                        String text = "Nearest Alarm in " + distance + " meters at #" + nearestPlace.alarmId;
                        notifyService(text);
                       // Log.i("nearestPlace", text);
                    }
                } else {

                   // Log.i("nearestPlace", "nearestPlace NULL");
                }
            } else {
                location = getLocation();
               // Log.i("LOCATION CHANGED", "NULL");
            }
        } else {
            String text = "No Active Alarms";
            notifyService(text);
        }
    }

    public void notifyService(String text) {
        if (isServiceEnabled) {
            builder.setContentText(text);
            mNotificationManager.notify(SERVICE_NOTIFICATION, builder.build());

        }
    }

    public Notification getServiceNotification() {
        String channel;

        mNotificationManager = (NotificationManager) this.getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            channel = createChannel();
        else {
            channel = "";
        }
        Intent stopIntent = new Intent(getApplicationContext(), LocationService.class);
        stopIntent.setAction(Constants.STOP_SERVICE);
        //stopIntent.putExtra("stopInt", 10);

        PendingIntent pendingIntentStop = PendingIntent.getService(this, 111, stopIntent, PendingIntent.FLAG_CANCEL_CURRENT);

        NotificationCompat.Action stopAction =
                new NotificationCompat.Action.Builder(0, "STOP", pendingIntentStop)
                        .build();


        builder = new NotificationCompat.Builder(this, channel)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle("Arealarm Service")
                .addAction(stopAction)
                .setContentText("No Active Alarms");

        Notification notification = builder
                .setSmallIcon(R.mipmap.ic_launcher)
                .setPriority(PRIORITY_MAX)
                .setNotificationSilent()

                //.setSound(uri)
                .setCategory(Notification.CATEGORY_SERVICE)
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
        Collections.sort(placeList, (l1, l2) -> Double.compare((l1.distance - l1.radius), (l2.distance - l2.radius)));
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
        String name = "Background Location Service";
        int importance = NotificationManager.IMPORTANCE_HIGH;
        NotificationChannel mChannel = new NotificationChannel("Arealarm Channel", name, importance);
        if (mNotificationManager != null) {
            mNotificationManager.createNotificationChannel(mChannel);
        } else {
            stopSelf();
        }
        return "Arealarm Channel";
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
        if (intent != null) {
            String stopAction = intent.getAction();
            if (stopAction != null) {
                if (intent.getAction().equals(Constants.STOP_SERVICE)) {
                  //  Log.i("LOG_TAG", "Received Stop Foreground Intent");
                    unregisterNotificationReciever();
                    locationManager.removeUpdates(this);
                    stopForeground(true);
                    stopSelf();
                    isServiceEnabled = false;
                    return START_NOT_STICKY;
                } else {
                 //   Log.i("No Match ", "STOP_SERVICE");

                }

            } else {
               // Log.i("Null ", "No stopAction");

            }


        } else {


           // Log.i("Start ", "Start Servieccececece");

        }

        return START_STICKY;
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }


}