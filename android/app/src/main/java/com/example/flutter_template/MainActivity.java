package com.example.flutter_template;


import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.os.Debug;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


import static io.flutter.view.FlutterMain.startInitialization;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.flutter_template/location";
    private static final String START_ALARM_SERVICE = "startAlarmService";
    private static final String STOP_ALARM_SERVICE = "stopAlarmService";
    private static final String STOP_ALL_ALARM_SERVICES = "stopAllAlarmServices";

    private Intent serviceStartIntent;
    private Intent serviceStopIntent;
    public static Context context;

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //LocalBroadcastManager.getInstance(getActivity()).unregisterReceiver(mMessageReceiver);
        //stopService(servIntent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        startInitialization(this);
        context = getContext();
        serviceStartIntent = new Intent(MainActivity.this, LocationService.class);
        //serviceStartIntent.setAction(Constants.STARTFOREGROUND_ACTION);


    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {

                    switch (call.method) {
                        case START_ALARM_SERVICE:
                            AlarmPlace alarmPlace = getCallArguments(call);
                            if (alarmPlace.alarmId != -1) {


                                if (!isMyServiceRunning(LocationService.class)) {
                                    startBackgroundAlarmService();
                                }
                                LocationService.addAlarmPTolaceList(alarmPlace);


                            }
                            break;
                        case STOP_ALARM_SERVICE:
                            stopBackgroundService();
                            break;
                        case STOP_ALL_ALARM_SERVICES:
                            stopBackgroundService();
                            break;

                    }
                }

        );


    }

    private void stopBackgroundService() {

        LocationService.clearAllAlarmPlaces();
        /*
       *  serviceStopIntent = new Intent(MainActivity.this, LocationService.class);
        serviceStopIntent.setAction(Constants.STOPFOREGROUND_ACTION);
        startService(serviceStopIntent);
       * */
    }

    public void getLocationAnswer() {
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(mMessageReceiver, new IntentFilter("GPSLocationUpdates"));
    }

    private BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            String message = intent.getStringExtra("Status");
            Bundle b = intent.getBundleExtra("double");
            double distance = b.getDouble("double");
            if (distance != -1) {
                //double longu = lastKnownLoc.getLongitude();
                //double lati = lastKnownLoc.getLatitude();
                String text = "Distance: " + distance;
                // Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
            }
        }
    };


    public AlarmPlace getCallArguments(MethodCall call) {
        AlarmPlace alarmPlace = new AlarmPlace();
        try {
            if (call != null) {
                int alarmId = call.argument("alarmId");
                int isActive = call.argument("isActive");
                double radius = call.argument("radius");
                double latitude = call.argument("latitude");
                double longitude = call.argument("longitude");
                alarmPlace.setAlarmPlaces(alarmId, isActive, latitude, longitude, radius);

            }
        } catch (Exception e) {
            Log.d("CALL_EX", e.toString());
        }
        return alarmPlace;
    }

    public void startBackgroundAlarmService() {
        if (!isMyServiceRunning(LocationService.class)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceStartIntent);

            } else {
                startService(serviceStartIntent);
            }
            Log.d("SERVICE", "Started!");
        } else {
            Log.d("SERVICE", "Already Running!");
        }
        getLocationAnswer();
    }


    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

}
