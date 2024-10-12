import 'dart:async';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/models/custom_model.dart';
import 'package:asset_player/screen/language_screen.dart';
import 'package:asset_player/widgets/custom_wp_widget.dart';
import 'package:asset_player/widgets/native_medium_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/constants/const.dart';
import 'package:asset_player/widgets/custom_video_widget.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool back = false;

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    MyGoogleAdsManager().createInterstitialAd();
    setLanguage();
    super.initState();
  }

  setLanguage() async{
    final prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString("code");
    if(code != null){
      context.read<LanguageChangeProvider>().changeLocale(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Custom2> meList = [
      Custom2(AppImages.imgTransPlay, S.of(context).allVideo),
      Custom2(AppImages.imgTransFolder, S.of(context).directory),
      Custom2(AppImages.imgLanguage, S.of(context).language),
      Custom2(AppImages.imgRate, S.of(context).rateUs),
      Custom2(AppImages.imgShareApp, S.of(context).shareApp),
      Custom2(AppImages.imgPrivacy, S.of(context).privacyPolicy),
    ];

    return WillPopScope(
      onWillPop: ()async {
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
          backgroundColor: AppColors.backColor,
          //automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: AppColors.white),
          title: Text("VIDEO PLAYER", style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w600)),
        ),
        body: CustomVideoWidget(),
        drawer: Container(
          width: MediaQuery.of(context).size.width/1.2,
          padding: EdgeInsets.only(top: 60),
          color: AppColors.backColor1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.imgLogo, height: 100, width: 100),
              SizedBox(height: 10),
              Text(S.of(context).hdVideoPlayback, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 30),
              Divider(color: AppColors.unselectColor),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: meList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if(index == 0){
                          setState(() {
                            selectIndex = 0;
                          });
                          Navigator.pop(context);
                        }else if(index == 1){
                          setState(() {
                            selectIndex = 1;
                          });
                          Navigator.pop(context);
                        }else if(index == 2){
                          if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                            context.read<LoadingProvider>().setLoad(true);
                            Timer(Duration(seconds: 5), () {
                              context.read<LoadingProvider>().setLoad(false);
                              MyGoogleAdsManager().showInterstitialAd(context, LanguageScreen());
                            });
                          }else{
                            MyGoogleAdsManager().showInterstitialAd(context, LanguageScreen());
                          }
                        }else if(index == 3){
                          Navigator.pop(context);
                          _launchUrl("https://play.google.com/store/apps/details?id=${AppText.appId}");
                        }else if(index == 4){
                          Navigator.pop(context);
                          Share.share("https://play.google.com/store/apps/details?id=${AppText.appId}");
                        }else if(index == 5){
                          Navigator.pop(context);
                          _launchUrl("https://deepaknitriteapptech.blogspot.com/2024/02/privacy-policy.html");
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 12),
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.unselectColor, width: 0.1))
                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(meList[index].image, height: 44, width: 44, color: AppColors.white),
                            SizedBox(width: 18),
                            Text(meList[index].title, style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w400))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: NativeMediumContainer(type: getTestAd.screen4!),
      ),
    );
  }


}
