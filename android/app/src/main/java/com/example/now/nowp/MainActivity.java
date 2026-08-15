package com.example.now.nowp;

import io.flutter.embedding.android.FlutterActivity;

import android.app.Notification;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.Icon;
import android.os.Build;
import android.os.IBinder;
import android.service.notification.StatusBarNotification;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.IconCompat;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private String CHANNEL = "example.com/test";
    private String EVENTCHANNEL = "example.com/event";
    private notificationdata noti;
    private ServiceConnection con;

    public static NotificationObject obj = new NotificationObject();

    @Override
    public void onDestroy() {
        super.onDestroy();
        unbindService(con);
        con = null;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        if(ContextCompat.checkSelfPermission(this, "android.permission.BIND_NOTIFICATION_LISTENER_SERVICE") == PackageManager.PERMISSION_DENIED) {
            startActivity(new Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"));
        }

        MethodChannel m = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        m.setMethodCallHandler((call, result) -> {
            Log.d("MainActivity", call.method + "ASDASASAD");
            if(call.method.contains("getData")) {
                Log.d("MainActivity", noti.getActiveNotifications().length + "ASDASD");
                Log.d("MainActivity", "__________________+=============");
                noti.result.doIt(Integer.parseInt(call.method.replace("getData", "")));
                Log.d("MainActivity", "__________________+=============");
            } else {
                Log.d("MainActivity", "ASJDHJAKSDHJKADJKHASDKLH");
                result.notImplemented();
            }
        });

        BroadcastReceiver b = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.d("MainReceiver", intent.getAction());
                if(intent.getAction().equals("GET_SIGNAL_STRENGTH"))
                {
                    String level = intent.getStringExtra("LEVEL_DATA");
                    m.invokeMethod("init", level);
                    if(noti.result.getImage() != null) m.invokeMethod("img", noti.result.getImage());
                    // Show it in GraphView
                }
            }
        };
        registerReceiver(b, new IntentFilter("GET_SIGNAL_STRENGTH"));


        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENTCHANNEL).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                Log.d("MainActivity", "Start Listen");
                con = new ServiceConnection() {
                    @RequiresApi(api = Build.VERSION_CODES.P)
                    @Override
                    public void onServiceConnected(ComponentName name, IBinder service) {
                        Log.d("MainActivity", "NLS Started");
                        notificationdata.ServiceBinder binder = (notificationdata.ServiceBinder)service;
                        noti = binder.getService();
                        Log.d("MainActivity", Arrays.toString(noti.getActiveNotifications()));
                        StatusBarNotification[] n = noti.getActiveNotifications();
                        for (StatusBarNotification statusBarNotification : n) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                                Log.d("MainActivity", statusBarNotification.getPackageName() + "  :  " + statusBarNotification.getNotification().category);
                                byte[] byteArray = new byte[0];
                                if (statusBarNotification.getNotification().category != null && statusBarNotification.getNotification().category.contains("transport")) {
                                    Log.d("MainActivity", statusBarNotification.getPackageName());
                                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                        Icon icon = (Icon) statusBarNotification.getNotification().extras.get(Notification.EXTRA_LARGE_ICON);

                                        Drawable map = icon.loadDrawable(getApplicationContext());
                                        Bitmap bitmap = ((BitmapDrawable)map).getBitmap();
                                        ByteArrayOutputStream stream = new ByteArrayOutputStream();
                                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
                                        byteArray = stream.toByteArray();
                                        bitmap.recycle();
                                    }

                                    noti.result.setData(
                                            statusBarNotification.getNotification().extras.getString(Notification.EXTRA_TITLE),
                                            statusBarNotification.getNotification().extras.getString(Notification.EXTRA_TEXT),
                                            statusBarNotification.getNotification().actions,
                                            statusBarNotification.getPackageName(),
                                            byteArray
                                    );
                                    m.invokeMethod("init", noti.result.toString());
                                    m.invokeMethod("img", noti.result.getImage());
                                    break;
                                }
                            }
                        }
                    }

                    @Override
                    public void onServiceDisconnected(ComponentName name) {
                        Log.d("MainActivity", "NLS Stopped");
                    }
                };
                Intent in = new Intent(getApplicationContext(), notificationdata.class);
                getApplicationContext().bindService(in, con, Context.BIND_AUTO_CREATE);
            }

            @Override
            public void onCancel(Object arguments) {
                Log.d("MainActivity", "Closed");
            }
        });
    }
}
