package com.example.flutter_template;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import java.util.HashMap;

import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import static android.app.PendingIntent.getActivity;
import static androidx.core.content.ContextCompat.startActivity;

public class NotificationReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        //context.unregisterReceiver(this);
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

           try {
               DatabaseController.getInstance(context).removeAlarm(alarmPlace);
               CustomNotification.cancelNotification(alarmPlace);
               Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
           }catch (Exception exception){
               Log.i("exception", exception.toString());
           }
        }else{
            Log.i("No extras", "cancelTheAlarm: ");
        }

    }
}