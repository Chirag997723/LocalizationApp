import 'dart:async';
import 'dart:io';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class WPPlayer extends StatefulWidget {
  String path;
  WPPlayer({super.key, required this.path});

  @override
  State<WPPlayer> createState() => _WPPlayerState();
}

class _WPPlayerState extends State<WPPlayer> {
  late VideoPlayerController _controller;
  
  @override
  void initState() {
    // TODO: implement initState
    playVideo();
    MyGoogleAdsManager().createInterstitialAd();
    super.initState();
  }

  playVideo() async{
    _controller = VideoPlayerController.file(File(widget.path));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
        backgroundColor: AppColors.black1,
        appBar: AppBar(
          backgroundColor: AppColors.black1,
          iconTheme: IconThemeData(color: AppColors.white),
          title: Text(basename(widget.path), style: TextStyle(color: AppColors.white)),
        ),
        body: Center(
          child: _controller.value.isInitialized ?Stack(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              Center(
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                        setState(() {});
                      },
                      child: Image.asset(_controller.value.isPlaying ?AppImages.imgPause :AppImages.imgPlay2, height: 60, width: 60)))
            ],
          ) :Container(),
        ),
        bottomNavigationBar: Container(
          height: 50,
          color: AppColors.black1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async{
                  await Share.shareXFiles([XFile(widget.path)]);
                },
              child: Image.asset(AppImages.imgShare, height: 44, width: 44)),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  GallerySaver.saveVideo(widget.path).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).videoDownload),
                        )
                    );
                  });
                },
                child: Image.asset(AppImages.imgDownload, height: 44, width: 44))
            ],
          ),
        ),
      ),
    );
  }
}
