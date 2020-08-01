package acr.rt.ringtone_set;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import android.Manifest;
import android.content.Intent;
import android.database.Cursor;
import android.app.Activity;
import android.content.Context;
import android.content.ContentUris;
import android.media.RingtoneManager;
import android.net.Uri;
import android.content.ContentValues;
import android.os.Build;
import android.provider.MediaStore;
import android.provider.Settings;

/**
 * RingtoneSetPlugin
 */
public class RingtoneSetPlugin implements FlutterPlugin, MethodCallHandler {
    private static RingtoneSetPlugin instance;
    private MethodChannel channel;
    private Context mContext;

    public static void registerWith(Registrar registrar) {
        if (instance == null) {
            instance = new RingtoneSetPlugin();
        }
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    public void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
        if (channel != null) {
            return;
        }
        this.mContext = applicationContext;

        channel =
                new MethodChannel(
                        messenger, "ringtone_set");

        channel.setMethodCallHandler(this);
    }

    private boolean checkSystemWritePermission() {
        boolean retVal = true;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            retVal = Settings.System.canWrite(mContext);

            if (retVal) {
                //do your code
            } else {
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                    Intent intent = new Intent(android.provider.Settings.ACTION_MANAGE_WRITE_SETTINGS);
                    String both = "package:" + mContext.getPackageName();
                    intent.setData(Uri.parse(both));
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    mContext.startActivity(intent);
                } else {
                }
            }
        }
        return retVal;
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private void setThings(String path, boolean isNotif){
        File file = new File(path);
        checkSystemWritePermission();
        String s = path;
        File mFile = new File(s);  // set File from path
        if (mFile.exists()) {      // file.exists
            ContentValues values = new ContentValues();
            values.put(MediaStore.MediaColumns.DATA, mFile.getAbsolutePath());
            values.put(MediaStore.MediaColumns.TITLE, "KolpacinoRingtone");
            values.put(MediaStore.MediaColumns.MIME_TYPE, "audio/mp3");
            values.put(MediaStore.MediaColumns.SIZE, mFile.length());
            values.put(MediaStore.Audio.Media.ARTIST, "Kolpaçino Sesleri");
            values.put(MediaStore.Audio.Media.IS_RINGTONE, !isNotif);
            values.put(MediaStore.Audio.Media.IS_NOTIFICATION, isNotif);
            values.put(MediaStore.Audio.Media.IS_ALARM, true);
            values.put(MediaStore.Audio.Media.IS_MUSIC, false);

            Uri newUri = mContext.getContentResolver().insert(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, values);

            try (OutputStream os = mContext.getContentResolver().openOutputStream(newUri)) {
                int size = (int) mFile.length();
                byte[] bytes = new byte[size];
                try {
                    BufferedInputStream buf = new BufferedInputStream(new FileInputStream(mFile));
                    buf.read(bytes, 0, bytes.length);
                    buf.close();

                    os.write(bytes);
                    os.close();
                    os.flush();
                } catch (IOException e) {
                }
            } catch (Exception ignored) {
                ignored.printStackTrace();
            }
            if(isNotif) {
                RingtoneManager.setActualDefaultRingtoneUri(
                        mContext, RingtoneManager.TYPE_NOTIFICATION,
                        newUri);
            }else{
                RingtoneManager.setActualDefaultRingtoneUri(
                        mContext, RingtoneManager.TYPE_RINGTONE,
                        newUri);
            }
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        }
        if (call.method.equals("setRingtone")) {
            String path = call.argument("path");
            setThings(path, false);

            result.success("success");
            return;
        }else  if (call.method.equals("setNotification")) {
            String path = call.argument("path");
            setThings(path, true);

            result.success("success");
            return;
        }

        result.notImplemented();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
