package com.example.flutter_template;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


import static io.flutter.view.FlutterMain.startInitialization;

public class MainActivity extends FlutterActivity {

    private Intent servIntent;
    private String CHANNEL = "com.example.flutter_template/location";
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
        //GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));

        servIntent = new Intent(MainActivity.this, LocationService.class);

    }

    public void getLocationAnswer() {
        LocalBroadcastManager.getInstance(getActivity()).registerReceiver(mMessageReceiver, new IntentFilter("GPSLocationUpdates"));

    }


    private BroadcastReceiver mMessageReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {

            String message = intent.getStringExtra("Status");
            Bundle b = intent.getBundleExtra("float");
            float distance = (float) b.getFloat("float");
            if (distance != -1) {
                //double longu = lastKnownLoc.getLongitude();
                //double lati = lastKnownLoc.getLatitude();
                String text = "Distance: " + distance;
                Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
            }
        }
    };


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("startService")) {
                        startService();
                        result.success("Services Started!");
                    } else {

                        result.success("Services Couldn't Started!");
                    }
                }

        );


    }


    public void startService() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(servIntent);

        } else {
            startService(servIntent);
        }
        getLocationAnswer();

    }
}
