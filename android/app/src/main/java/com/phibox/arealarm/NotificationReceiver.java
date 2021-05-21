package com.phibox.arealarm;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.tekartik.sqflite.Constant;

import androidx.core.content.ContextCompat;

import static android.app.PendingIntent.getActivity;

public class NotificationReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {


        String action = intent.getAction();
        if (Constants.GOT_IT.equals(action)) {
            cancelTheAlarm(context, intent);
        } else if (Constants.STOP_SERVICE.equals(action)) {
            //context.unregisterReceiver(this);
            stopService(context);

           // Log.i("TAG", "onReceive: STOP Intent");
        }else{

          //  Log.i("TAG", "onReceive: Unknown" + intent);
        }
    }



    private void stopService(Context context){

        Intent serviceStopIntent = new Intent(context, LocationService.class);
        serviceStopIntent.setAction(Constants.STOP_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            ContextCompat.startForegroundService(context, serviceStopIntent);
        } else {

            context.startService(serviceStopIntent);

        }
        System.exit(1);
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
           // Log.i("No extras", "cancelTheAlarm: ");
        }

    }
}