import 'dart:async';
import 'dart:io';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/const.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/models/get_test_ad_model.dart';
import 'package:asset_player/screen/wp_player.dart';
import 'package:asset_player/widgets/native_medium_container.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class CustomWpWidget extends StatefulWidget {
  const CustomWpWidget({super.key});

  @override
  State<CustomWpWidget> createState() => _CustomWpWidgetState();
}

class _CustomWpWidgetState extends State<CustomWpWidget> {
  bool? granted;
  List<String> imageList = [];
  List<String> thumbList = [];

  @override
  void initState() {
    // TODO: implement initState
    //requestStoragePermission();
    getData();
    MyGoogleAdsManager().createInterstitialAd();
    super.initState();
  }

  getData() async{
    final pref = await SharedPreferences.getInstance();
    granted = pref.getBool('per');
    if(granted == true){
      requestStoragePermission();
    }
  }

  create(String path, int index) async{
    VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 150,
      quality: 10,
    ).then((value) {
      if(value!=null){
        setState(() {
          thumbList.add(value!);
        });
      }
    });
  }

  void requestStoragePermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
      final Directory _photoDir =
          androidInfo.version.sdkInt <= 32 ?Directory(
          '/storage/emulated/0/WhatsApp/Media/.Statuses')
              :Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

      imageList = _photoDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".mp4"))
          .toList();
      setState(() {});
    print("------${imageList.length}");

      for(int i=0; i<imageList.length; i++){
        create(imageList[i], i);
      }
      print(imageList.length);
  }

  Future<bool> _promptPermissionSetting() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (Platform.isAndroid) {
      final pref = await SharedPreferences.getInstance();
      if(androidInfo.version.sdkInt <= 32){
        if(await Permission.storage.request().isGranted){
          pref.setBool("per", true);
          setState(() {
            granted = true;
          });
          return true;
        }
      }else{
        // if(await Permission.manageExternalStorage.request().isGranted){
        //   pref.setBool("per", true);
        //   setState(() {
        //     granted = true;
        //   });
        //   return true;
        // }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        setState(() {
          backInter = backInter + 1;
        });
        if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
          context.read<LoadingProvider>().setLoad(true);
          Timer(Duration(seconds: 5), () {
            context.read<LoadingProvider>().setLoad(false);
            MyGoogleAdsManager().backAdShow(context);
          });
        }else{
          MyGoogleAdsManager().backAdShow(context);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColors.backColor,
          iconTheme: IconThemeData(color: AppColors.white),
          title: Text(AppText.wpStatusSaver, style: TextStyle(color: AppColors.white, fontSize: 20)),
        ),
        body: /*granted == false || granted == null ?Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(S.of(context).permissionRequired, textAlign: TextAlign.center, style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            SizedBox(height: 10),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                requestStoragePermission();
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(color: AppColors.selectColor, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(S.of(context).allowPermission, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            )
          ],
        ):imageList.length == 0 ?Center(
          child: Text(AppText.noStatus, style: TextStyle(color: AppColors.white)),
        ):*/Padding(
          padding: const EdgeInsets.all(14.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              childAspectRatio: 0.7,
              crossAxisSpacing: 15
            ),
            itemCount: imageList.length,
            itemBuilder: (context, index){
              return Stack(
                children: [
                  Container(
                    decoration: index > thumbList.length-1
                        ?BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(14),
                    )
                        :BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: FileImage(File(thumbList[index])),
                          fit: BoxFit.cover,
                        )
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.symmetric(horizontal: 6).copyWith(bottom: 6),
                    child: index > thumbList.length ?Center(
                      child: Text("Loading...", style: TextStyle(color: AppColors.white)),
                    ):GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        GallerySaver.saveVideo(imageList[index]).then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).videoDownload),
                              )
                          );
                        });
                      },
                      child: Container(
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.selectColor,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        alignment: Alignment.center,
                        child: Text(S.of(context).download, style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  index > thumbList.length-1 ?Container():Center(
                      child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                      onTap: (){
                      if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                        context.read<LoadingProvider>().setLoad(true);
                        Timer(Duration(seconds: 5), () {
                          context.read<LoadingProvider>().setLoad(false);
                          MyGoogleAdsManager().showInterstitialAd(context, WPPlayer(path: imageList[index]));
                        });
                      }else{
                        MyGoogleAdsManager().showInterstitialAd(context, WPPlayer(path: imageList[index]));
                      }
                      },
                      child: Image.asset(AppImages.imgPlay, height: 44, width: 44)))
                ],
              );
            },
          ),
        ),
        //bottomNavigationBar: NativeMediumContainer(type: getTestAd.screen6!),
      ),
    );
  }
}
