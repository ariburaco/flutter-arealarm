package com.example.flutter_template;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.core.content.ContextCompat;

class NotificationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {

        String action = intent.getAction();
        if (Constants.GOT_IT.equals(action)) {
            cancelTheAlarm(context, intent);
        }

    }


    private void cancelTheAlarm(Context context, Intent intent){
        if (intent.hasExtra("remove")) {
            Bundle comingBundle = intent.getExtras();
            Intent removePlaceIntent = new Intent(context, LocationService.class);
            removePlaceIntent.putExtras(comingBundle);

            AlarmPlace alarmPlace = (AlarmPlace) comingBundle.getParcelable("remove");
            String text = "Removed Alarm "  + alarmPlace.alarmId;
            Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                ContextCompat.startForegroundService(MainActivity.context, removePlaceIntent);
            } else {
                context.startService(removePlaceIntent);
            }
        }else{
            Log.i("No extras", "cancelTheAlarm: ");
        }

    }
}