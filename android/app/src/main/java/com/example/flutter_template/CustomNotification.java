package com.example.flutter_template;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import com.tekartik.sqflite.Constant;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import static android.app.Notification.EXTRA_NOTIFICATION_ID;
import static android.provider.Settings.System.getString;
import static androidx.core.content.ContextCompat.getSystemService;


public class CustomNotification {
    private String CHANNEL_ID = "10";
    private String title = "Arealarm";
    private String contentText = "You have reached the place!";

    public Context context;
    public static int notificationId = 1001;

    private static NotificationManager notificationManager;
    private NotificationCompat.Builder builder;
    public  NotificationManagerCompat notificationManagerCompat;

    public CustomNotification(Context _context) {
        context = _context;
        createNotificationChannel();
    }

    private void createNotificationChannel() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "alarmServices";
            String description = "alarmServiceDescs";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            channel.enableLights(true);
            channel.setLightColor(Color.RED);
            channel.enableVibration(true);
            channel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
            notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(channel);
        }
    }


    public void showNotification(AlarmPlace removedAlarm, String text) {
        Intent gotItIntent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putParcelable("remove", removedAlarm);
        gotItIntent.putExtras(bundle);
        gotItIntent.setAction(Constants.GOT_IT);
        PendingIntent pendingIntentYes = PendingIntent.getBroadcast(context, 12345, gotItIntent, PendingIntent.FLAG_ONE_SHOT);

        NotificationCompat.Action action =
                new NotificationCompat.Action.Builder(0, "Got it!", pendingIntentYes)
                        .build();

        builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.app_icon)
                .setContentTitle(title)
                .setContentText(contentText)
                .addAction(action)

                .setStyle(new NotificationCompat.BigTextStyle()
                        .bigText(text))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        notificationId = removedAlarm.alarmId;
        notificationManagerCompat = NotificationManagerCompat.from(context);
        notificationManager.notify(notificationId, builder.build());

    }

    public static void cancelNotification(AlarmPlace alarmPlace) {
        if(alarmPlace != null)
            if(alarmPlace.alarmId > 0 )
                notificationManager.cancel(alarmPlace.alarmId);
    }

}

