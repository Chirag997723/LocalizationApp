import 'dart:async';
import 'dart:io';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/const.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/models/custom_model.dart';
import 'package:asset_player/screen/home_screen.dart';
import 'package:asset_player/screen/permission_screen.dart';
import 'package:asset_player/widgets/native_large_container.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  List<lan> lanList = [

    lan("English", "English", "en", false),
    lan("German", "Deutsch", "de", false),
    lan("", "", "", false),
    lan("China", "中国", "zh", false),
    lan("Hindi", "हिंदी", "hi", false),
    lan("Russian", "русский", "ru", false),
    lan("Spanish", "española", "es", false),
    lan("Arabic", "عربي", "ar", false),
    lan("Japanese", "日本語", "ja", false),
    lan("Bengali", "বাংলা", "bn", false),
    lan("French", "Français", "fr", false),
    lan("Portuguese", "Português", "pt", false),
    lan("Urdu", "اردو", "ur", false),
  ];

  bool back = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyGoogleAdsManager().createInterstitialAd();
    getData();
  }

  getData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("code");
    if(code != null){
      for(int i=0; i<lanList.length; i++){
        if(lanList[i].code == code!){
          setState(() {
            lanList[i].select = true;
          });
        }
      }
    }else{
      setState(() {
        lanList[0].select = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(back){
          SystemNavigator.pop();
        }
        setState(() {
          back = !back;
        });
        message(S.of(context).back);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.backColor,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          title: Text(S.of(context).language, style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 14),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: ()async{
                  final androidInfo = await DeviceInfoPlugin().androidInfo;
                  if(androidInfo.version.sdkInt <= 32){
                    if(await Permission.storage.isGranted){
                      if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                        context.read<LoadingProvider>().setLoad(true);
                        Timer(Duration(seconds: 5), () {
                          context.read<LoadingProvider>().setLoad(false);
                          MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
                        });
                      }else{
                        MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
                      }
                    }else{
                      MyGoogleAdsManager().showInterstitialAd(context, PermissionScreen());
                    }
                  }else{
                    if(await Permission.videos.isGranted && await Permission.photos.isGranted){
                      if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                        context.read<LoadingProvider>().setLoad(true);
                        Timer(Duration(seconds: 5), () {
                          context.read<LoadingProvider>().setLoad(false);
                          MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
                        });
                      }else{
                        MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
                      }
                    }else{
                      MyGoogleAdsManager().showInterstitialAd(context, PermissionScreen());
                    }
                  }
                },
                child: Icon(Icons.done, color: AppColors.white, size: 28),
              ),
            )
          ],
        ),
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: lanList.length,
          itemBuilder: (context, index){
            if(index == 2){
              return NativeLargeContainer(type: getTestAd.screen2!);
            }
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${lanList[index].title.toString()} (${lanList[index].sub.toString()})", style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Checkbox(
                        value: lanList[index].select,
                        activeColor: AppColors.selectColor,
                        onChanged: (bool? val) async{
                          if(val! == true) {
                            for(int i=0; i<lanList.length; i++){
                              if(index == i){
                                setState(() {
                                  lanList[index].select = val!;
                                });
                              }else{
                                setState(() {
                                  lanList[i].select = false;
                                });
                              }
                            }
                            context.read<LanguageChangeProvider>().changeLocale(lanList[index].code);
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("code", lanList[index].code);
                          }
                        },
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }
}
