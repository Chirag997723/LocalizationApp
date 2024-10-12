package com.videoplayer.allformatplayer.hd.video.player;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import android.content.pm.PackageManager;
import android.content.pm.ApplicationInfo;
import android.os.Build;
import android.webkit.WebView;
import android.util.Log;
import com.facebook.LoggingBehavior;
import android.app.Application;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL= "facebook";
    private static final String CHANNEL1= "googlead";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    String appId = call.argument("AppId");
                    Log.e("hjhj",""+appId);
                    // This method is invoked on the main thread.
                    // TODO
                    if (call.method.equals("setfacebookId")) {
                        try {
                            FacebookSdk.setAdvertiserIDCollectionEnabled(true);
                            FacebookSdk.setApplicationId(appId);
                            FacebookSdk.sdkInitialize(MainActivity.this);
                            FacebookSdk.setAutoInitEnabled(true);
                            FacebookSdk.fullyInitialize();
                            FacebookSdk.setAutoLogAppEventsEnabled(true);
                            if (BuildConfig.DEBUG) {
                                FacebookSdk.setIsDebugEnabled(true);
                            }
                            FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
                            AppEventsLogger logger = AppEventsLogger.newLogger(MainActivity.this);
                            logger.getApplicationId();
                            result.success("Success");
                        } catch (Exception e) {
                            Log.e("TAG", "Failed to load meta-data, NameNotFound: " + e.getMessage());
                            e.printStackTrace();
                        }
                    } else {
                        result.notImplemented();
                    }

                });

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL1).setMethodCallHandler(
                (call, result) -> {
                    String appId = call.argument("AppId");
                    Log.e("dhruvin",""+appId);
                    // This method is invoked on the main thread.
                    // TODO
                    if (call.method.equals("googleadId")) {
                        try {
                            ApplicationInfo ai = getPackageManager().getApplicationInfo("com.videoplayer.allformatplayer.hd.video.player", PackageManager.GET_META_DATA);
                            ai.metaData.putString("com.google.android.gms.ads.APPLICATION_ID", appId);
                        } catch (PackageManager.NameNotFoundException e) {
                            Log.e("TAG", "Failed to load meta-data, NameNotFound: " + e.getMessage());
                        } catch (NullPointerException e) {
                            Log.e("TAG", "Failed to load meta-data, NullPointer: " + e.getMessage());
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                            String processName = Application.getProcessName();

                            Log.e("dhruvin", ""+processName);
                            if (!"com.videoplayer.allformatplayer.hd.video.player".equals(processName)) {
                                WebView.setDataDirectorySuffix(processName);
                            }
                        }
                        result.success("Success");
                    } else {
                        result.notImplemented();
                    }

                });

        final NativeAdFactory factory = new NativeAdFactoryExample(getLayoutInflater());
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryExample", factory);

        final NativeAdFactory mediumFactory = new NativeAdFactoryMediumExample(getLayoutInflater());
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryMediumExample", mediumFactory);
    }

    @Override
    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryExample");
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryMediumExample");
    }
}
