package com.example.flutter_template;


import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.location.Location;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Debug;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import androidx.core.content.ContextCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


import static io.flutter.view.FlutterMain.startInitialization;

public class MainActivity extends FlutterActivity {


    private Intent serviceStartIntent;

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
        //getBatteryOptimization();
        //getAutoRun();

        startInitialization(this);
        context = getContext();
        serviceStartIntent = new Intent(MainActivity.this, LocationService.class);
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), Constants.CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call != null) {
                        switch (call.method) {
                            case Constants.START_ALARM_SERVICE:
                                startBackgroundAlarmService(call);
                                break;
                            case Constants.STOP_ALARM_SERVICE:
                                removeSelectedAlarmPlace(call);
                                break;
                            case Constants.UPDATE_ALARM_SERVICE:
                                updateSelectedAlarmPlace(call);
                                break;
                            case Constants.STOP_ALL_ALARM_SERVICES:
                                stopBackgroundService();
                                break;
                        }
                    } else {
                        Log.i("call", "configureFlutterEngine: call null");
                    }
                }

        );


    }

    private void removeSelectedAlarmPlace(MethodCall call) {
        AlarmPlace removedAlarm = getCallArguments(call);
        Intent removePlaceIntent = new Intent(MainActivity.this, LocationService.class);
        Log.i("TAG", "removeSelectedAlarmPlace: " + removedAlarm.alarmId);
        Bundle bundle = new Bundle();
        bundle.putParcelable("remove", removedAlarm);
        removePlaceIntent.putExtras(bundle);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, removePlaceIntent);
        } else {
            startService(removePlaceIntent);
        }
    }

    private void updateSelectedAlarmPlace(MethodCall call) {
        AlarmPlace updateAlarmPlace = getCallArguments(call);
        Intent updatePlaceIntent = new Intent(MainActivity.this, LocationService.class);

        Bundle bundle = new Bundle();
        bundle.putParcelable("update", updateAlarmPlace);
        updatePlaceIntent.putExtras(bundle);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, updatePlaceIntent);
        } else {
            startService(updatePlaceIntent);
        }
    }


    private void stopBackgroundService() {
        Intent serviceStopIntent = new Intent(MainActivity.this, LocationService.class);
        serviceStopIntent.setAction(Constants.STOPFOREGROUND_ACTION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, serviceStopIntent);
        } else {
            startService(serviceStopIntent);
        }
    }


    public void startBackgroundAlarmService(MethodCall call) {
        AlarmPlace alarmPlace = getCallArguments(call);
        Log.i("TAG", "ADD alarmPlaceID: " + alarmPlace.alarmId);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //startForegroundService(serviceStartIntent);

            Bundle bundle = new Bundle();
            bundle.putParcelable("add", alarmPlace);
            serviceStartIntent.putExtras(bundle);
            ContextCompat.startForegroundService(context, serviceStartIntent);
        } else {
            startService(serviceStartIntent);
        }
        Log.d("SERVICE", "Started!");

    }

    public AlarmPlace getCallArguments(MethodCall call) {
        AlarmPlace alarmPlace = new AlarmPlace();
        try {
            int alarmId = call.argument("alarmId");
            int isActive = call.argument("isActive");
            double radius = call.argument("radius");
            double latitude = call.argument("latitude");
            double longitude = call.argument("longitude");
            alarmPlace.setAlarmPlaces(alarmId, isActive, latitude, longitude, radius);
        } catch (Exception e) {
            Log.d("CALL_EXCEPTION", e.toString());
        }
        return alarmPlace;
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


    private void getAutoRun() {
        for (Intent intent : POWERMANAGER_INTENTS)
            if (getPackageManager().resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                startActivity(intent);
                break;
            }
    }

    private void openPowerSettings() {
        startActivityForResult(new Intent(android.provider.Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS), 0);
    }

    private void getBatteryOptimization() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Intent intent = new Intent();
            String packageName = getPackageName();
            PowerManager pm = (PowerManager) getSystemService(POWER_SERVICE);
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + packageName));
                startActivity(intent);
            }
        }
    }


    private static final Intent[] POWERMANAGER_INTENTS = {
            new Intent().setComponent(new ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
            new Intent().setComponent(new ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity")),
            new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")),
            new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
            new Intent().setComponent(new ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")),
            new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
            new Intent().setComponent(new ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
            new Intent().setComponent(new ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
            new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
            new Intent().setComponent(new ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
            new Intent().setComponent(new ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")),
            new Intent().setComponent(new ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")),
            new Intent().setComponent(new ComponentName("com.htc.pitroad", "com.htc.pitroad.landingpage.activity.LandingPageActivity")),
            new Intent().setComponent(new ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.MainActivity"))
    };

}
