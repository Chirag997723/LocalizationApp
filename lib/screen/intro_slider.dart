import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/screen/home_screen.dart';
import 'package:asset_player/screen/language_screen.dart';
import 'package:asset_player/widgets/native_medium_container.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {


  late Function goToTab;
  late AppLifecycleReactor _appLifecycleReactor;

  Widget renderNextBtn() {
    return Text(AppText.next, style: TextStyle(color: AppColors.selectColor, fontSize: 16));
  }

  Widget renderDoneBtn() {
    return Text(AppText.done, style: TextStyle(color: AppColors.selectColor, fontSize: 16));
  }

  Widget renderSkipBtn() {
    return Text(AppText.previous, style: TextStyle(color: AppColors.white, fontSize: 16));
  }


  List<Widget> generateListCustomTabs() {
    return List.generate(
      3,
          (index) => Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              index == 0 ?AppImages.imgIntro1:index == 1 ?AppImages.imgIntro2:AppImages.imgIntro3,
              width: MediaQuery.of(context).size.width/1.2,
              height: getTestAd.adsShow == true ?MediaQuery.of(context).size.height/1.8 :MediaQuery.of(context).size.height/1.5,
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
              child: Text(
                AppText.welcome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppText.popularVideo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    MyGoogleAdsManager().createInterstitialAd();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(
        appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    setLanguage();
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
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: IntroSlider(
        key: UniqueKey(),
        // Skip button
        renderSkipBtn: renderSkipBtn(),

        // Next button
        renderNextBtn: renderNextBtn(),

        // Done button
        renderDoneBtn: renderDoneBtn(),
        onDonePress: () async{
          goToTab(2);
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if(androidInfo.version.sdkInt <= 32){
            if(await Permission.storage.isGranted){
              MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
            }else{
              MyGoogleAdsManager().showInterstitialAd(context, LanguageScreen());
            }
          }else{
            if(await Permission.videos.isGranted && await Permission.photos.isGranted){
              MyGoogleAdsManager().showInterstitialAd(context, HomeScreen());
            }else{
              MyGoogleAdsManager().showInterstitialAd(context, LanguageScreen());
            }
          }
        },

        // Indicator
        indicatorConfig: IndicatorConfig(
          colorIndicator: AppColors.unselectColor,
          colorActiveIndicator: AppColors.selectColor,
          sizeIndicator: 13.0,
          typeIndicatorAnimation: TypeIndicatorAnimation.sizeTransition,
        ),

        // Custom tabs
        listCustomTabs: generateListCustomTabs(),
        backgroundColorAllTabs: AppColors.backColor,
        refFuncGoToTab: (refFunc) {
          goToTab = refFunc;
        },

        // Behavior
        scrollPhysics: const BouncingScrollPhysics(),
      ),
      bottomNavigationBar: NativeMediumContainer(type: getTestAd.screen1!),
    );
  }
}
