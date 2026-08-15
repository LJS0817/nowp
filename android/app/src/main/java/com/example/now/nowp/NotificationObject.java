package com.example.now.nowp;

import android.app.Notification;
import android.app.PendingIntent;
import android.util.Log;

import java.util.Arrays;

public class NotificationObject {
    private String title;
    private String subTitle;
    private Notification.Action[] actions;
    private boolean isMusic;
    private String pkg;
    private byte[] image;

    private boolean dontUpdate;

    public void setData(String t, String sT, Notification.Action[] a, String n, byte[] img) {
        setTitle(t);
        setSubTitle(sT);
        setActions(a);
        isMusic = n.contains("music");
        pkg = n;
        dontUpdate = Arrays.equals(image, img);
        Log.d("image", dontUpdate + "A");
        image = img;
    }

    public void setTitle(String str) { title = str; }
    public void setSubTitle(String str) { subTitle = str; }
    public void setActions(Notification.Action[] actions) { this.actions = actions; }

    public String getTitle() { return title; }
    public String getSubTitle() { return subTitle; }
    public byte[] getImage() { return isUpdate() ? image : null; }
    public Notification.Action[] getActions() { return actions; }
    public String getPackageName() { return pkg; }
    public boolean isUpdate() { return !dontUpdate; }

    public void doIt(int idx) {
        try {
            actions[isMusic ? idx + 1 : idx].actionIntent.send();
        } catch (PendingIntent.CanceledException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public String toString() {
        return title + "`" + subTitle;
    }

}