package com.example.now.nowp;

import android.app.Notification;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.Icon;
import android.os.Binder;
import android.os.Build;
import android.os.Bundle;
import android.os.IBinder;
import android.service.notification.NotificationListenerService;
import android.service.notification.StatusBarNotification;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;

public class notificationdata extends NotificationListenerService {

    public class ServiceBinder extends Binder {
        notificationdata getService() {
            Log.d("notification", "getService");
            return notificationdata.this;
        }
    }
    private final IBinder binder = new ServiceBinder();

    private Notification no;
    private Bundle extra;

    public NotificationObject result = new NotificationObject();

    @Override
    public String toString() {
        return result.getTitle() + "`" + result.getSubTitle();
    }

    @Override
    public void onListenerConnected() {
        Log.d("MainActivity", Arrays.toString(getActiveNotifications()));
    }

    @Override
    public void onNotificationPosted(StatusBarNotification sbn) {
        super.onNotificationPosted(sbn);  // getProperties() 및 setProperties()
        final String name = sbn.getPackageName();
        Log.d("notificationdata", name);
        if(!TextUtils.isEmpty(name) && name.contains("music")) {
            no = sbn.getNotification();
            extra = no.extras;
            byte[] byteArray = new byte[0];
            for (String key: sbn.getNotification().extras.keySet())
            {
                Log.d("Bundle Debug", key + " = \"" + sbn.getNotification().extras.get(key) + "\"");
            }
            if (extra.get(Notification.EXTRA_LARGE_ICON) != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    Icon icon = (Icon) extra.get(Notification.EXTRA_LARGE_ICON);

                    Drawable map = icon.loadDrawable(getApplicationContext());
                    Bitmap bitmap = ((BitmapDrawable)map).getBitmap();
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
                    byteArray = stream.toByteArray();
                    bitmap.recycle();
                }
            } else {
                byteArray = null;
            }


            result.setData(
                    extra.getString(Notification.EXTRA_TITLE),
                    extra.getString(Notification.EXTRA_TEXT),
                    sbn.getNotification().actions,
                    name,
                    byteArray
            );
            Intent sendLevel = new Intent();
            sendLevel.setAction("GET_SIGNAL_STRENGTH");
            sendLevel.putExtra( "LEVEL_DATA", result.toString());
            sendBroadcast(sendLevel);

//            MainActivity.a = toString();

//            Log.d("notificationdata", extra.toString());
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        String action = intent.getAction();
        Log.d("MainActivity", "onBind: " + action);

        if (SERVICE_INTERFACE.equals(action)) {
            Log.d("MainActivity", "Bound by system");
            return super.onBind(intent);
        } else {
            Log.d("MainActivity", "Bound by application");
            return binder;
        }
    }

    @Override
    public void onNotificationRemoved(StatusBarNotification sbn) {
        super.onNotificationRemoved(sbn);
        final String name = sbn.getPackageName();
        Log.d("notificationdata", name + "Closed");
    }
}
