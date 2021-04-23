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

class NotificationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        //context.unregisterReceiver(this);
        String action = intent.getAction();
        if (Constants.GOT_IT.equals(action)) {
            cancelTheAlarm(context, intent);
        }
    }

    private void sendMessageToFlutter(Context context){
        Intent dialogIntent = new Intent();
        dialogIntent.setClassName("com.example.flutter_template", "com.example.flutter_template.MainActivity");
        dialogIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(dialogIntent);

        MethodChannel methodChannel = MainActivity.methodChannel;
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put("alice", "aliceeee");
        arguments.put("bob", "boeeeb");
        methodChannel.invokeMethod("charlie", arguments);

    }

    private void cancelTheAlarm(Context context, Intent intent){
        if (intent.hasExtra("remove")) {
            Bundle comingBundle = intent.getExtras();
            Intent removePlaceIntent = new Intent(context, LocationService.class);
            removePlaceIntent.putExtras(comingBundle);
            AlarmPlace alarmPlace = (AlarmPlace) comingBundle.getParcelable("remove");
            String text = "Removed Alarm "  + alarmPlace.alarmId;
            Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
           try {
               if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                   ContextCompat.startForegroundService(context, removePlaceIntent);
                   //sendMessageToFlutter(context);
               } else {
                   context.startService(removePlaceIntent);
               }
           }catch (Exception exception){
               Log.i("exception", exception.toString());
           }
        }else{
            Log.i("No extras", "cancelTheAlarm: ");
        }

    }
}