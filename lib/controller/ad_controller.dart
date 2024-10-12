import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/models/post_test_ad_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/repository/post_test_ad_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiController extends ControllerMVC{
  PostTestAd? postTestAd = PostTestAd();
  List<dynamic>? getTestAd1 = [];
  late AppLifecycleReactor _appLifecycleReactor;
  static const platform = MethodChannel('facebook');
  static const platform1 = MethodChannel('googlead');



  Future<void> postAdApi() async{
    postTestAdRepository().then((value) {
      if(value!=null){
        setState(() {
          postTestAd = value;
        });
        print(postTestAd!.toJson());
      }
    }).catchError((e){
      print(e.toString());
    });
  }

  Future<void> getAdApi(BuildContext context) async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    getTestAdRepository().then((value) async{
      if(value!=null){
        setState(() {
          getTestAd1 = value;
          getTestAd.interstitial = value![0]['interstitial'];
          getTestAd.native = value![0]['native'];
          getTestAd.native1 = value![0]['native_1'];
          getTestAd.appOpenAd = value![0]['appOpenAd'];

          getTestAd.appVersion = value![0]['app_version'];
          getTestAd.isAppIdFromApi = value![0]['is_app_id_from_api'];
          getTestAd.appId = value![0]['app_id'];
          getTestAd.toponAppId = value![0]['topon_app_id'];
          getTestAd.isToponAppIdFromApi = value![0]['is_topon_app_id_from_api'];

          getTestAd.isIntroEverytimeShow = value![0]['is_intro_everytime_show'];
          getTestAd.isNativeAdsShow = value![0]['is_native_ads_show'];
          getTestAd.splashAdShow = value![0]['splash_ad_show'];
          getTestAd.adsShow = value![0]['ads_show'];
          getTestAd.backAdsShow = value![0]['back_ads_show'];
          getTestAd.splashOpenAdShow = value![0]['splash_open_ad_show'];

          getTestAd.appInterCount = value![0]['app_inter_Count'];
          getTestAd.backInterCount = value![0]['back_inter_Count'];
          getTestAd.isCustomAdsDialogShow = value![0]['is_custom_ads_dialog_show'];
          getTestAd.isHandlerTime = value![0]['is_handler_time'];

          getTestAd.type = value![0]['type'];

          getTestAd.screen1 = value![0]['screen_1'];
          getTestAd.screen2 = value![0]['screen_2'];
          getTestAd.screen3 = value![0]['screen_3'];
          getTestAd.screen4 = value![0]['screen_4'];
          getTestAd.screen5 = value![0]['screen_5'];
          getTestAd.screen6 = value![0]['screen_6'];
        });

        if(getTestAd.isToponAppIdFromApi == true){
          print("Facebook");
          try {
            final result = await platform.invokeMethod('setfacebookId', <String, dynamic>{'AppId': getTestAd.toponAppId!});
            print("Result: $result");
          } on PlatformException catch (e) {
            print("error ${e}");
          }
        }
        if(getTestAd.isAppIdFromApi == true){
          print("appId");
          try {
            final result = await platform1.invokeMethod('googleadId', <String, dynamic>{'AppId': getTestAd.appId!});
            print("Result: $result");
          } on PlatformException catch (e) {
            print("error ${e}");
          }
        }

        print("------> ${packageInfo.buildNumber}");
        if(getTestAd.appVersion.toString() != packageInfo.buildNumber){
          versionUpdateDialog(context).then((value) {
            if(value == "back"){
              if(getTestAd.splashOpenAdShow == false){
                MyGoogleAdsManager().createInterstitialAd1(context);
              }else {
                AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd1(context);
                _appLifecycleReactor = AppLifecycleReactor(
                    appOpenAdManager: appOpenAdManager);
              }
            }
          });
        }else{
          if(getTestAd.splashOpenAdShow == false){
            MyGoogleAdsManager().createInterstitialAd1(context);
          }else {
            AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd1(context);
            _appLifecycleReactor = AppLifecycleReactor(
                appOpenAdManager: appOpenAdManager);
          }
        }
      }
    }).catchError((e){
      print(e.toString());
    });
  }

  Future versionUpdateDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    Navigator.pop(context, "back");
                  },
                  child: Icon(Icons.highlight_off_rounded, size: 27, color: AppColors.selectColor),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.imgLogo, height: 70, width: 70),
                  SizedBox(height: 10),
                  Text(S.of(context).newVersion, textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 20, fontWeight: FontWeight.w400)),
                  SizedBox(height: 10),
                  Text(S.of(context).versionToGo, textAlign: TextAlign.center, style: TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w200)),
                  SizedBox(height: 30),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      final appId = 'com.videoplayer.allformatplayer.hd.video.player';
                      final url = Uri.parse("market://details?id=$appId");
                      final url2 = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
                      try{
                        launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }catch (e){
                        launchUrl(url2, mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.selectColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(S.of(context).updateNow, style: TextStyle(color: AppColors.white, fontSize: 16)),
                    ),
                  )
                ],
              ),
            );
          });
        }
    );
  }
}
