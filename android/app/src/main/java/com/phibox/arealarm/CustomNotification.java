package com.phibox.arealarm;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.NotificationCompat;

import static android.app.Notification.PRIORITY_MAX;


public class CustomNotification {
    private String CHANNEL_ID = "10";
    private String title = "Arealarm";
    private String contentText = "You have reached the place!";

    public Context context;
    public static int notificationId = 1001;

    private static NotificationManager notificationManager;
    private NotificationCompat.Builder builder;

    long[] vibrationPattern = new long[]{500, 500, 500, 500, 500, 500, 500, 500, 100};

    public CustomNotification(Context _context) {
        context = _context;
        createNotificationChannel();
    }

    private void createNotificationChannel() {
        notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Arealarm Place Alarm";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            Uri alarmSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);

            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setSound(alarmSoundUri, null);

            channel.enableLights(true);
            channel.setLightColor(Color.RED);
            channel.enableVibration(true);
            channel.setVibrationPattern(vibrationPattern);
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

        Uri alarmSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);

        builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setOngoing(true)
                .setSound(alarmSoundUri)
                .setVibrate(vibrationPattern)
                .setPriority(PRIORITY_MAX)
                .setContentTitle(title)
                .setContentText(contentText)
                .addAction(action)
                .setStyle(new NotificationCompat.BigTextStyle()
                        .bigText(text));

        Notification notification = builder.build();

        notification.flags |= Notification.FLAG_INSISTENT;
        notification.sound = alarmSoundUri;
        notification.vibrate = vibrationPattern;

        notificationId = removedAlarm.alarmId;
        notificationManager.notify(notificationId, notification);

    }

    public static void cancelNotification(AlarmPlace alarmPlace) {
        if(alarmPlace != null)
            if(alarmPlace.alarmId > 0 )
                notificationManager.cancel(alarmPlace.alarmId);
    }

}

