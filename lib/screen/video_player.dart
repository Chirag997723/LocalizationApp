import 'dart:async';
import 'dart:io';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  List<Medium> mediaPage;
  int index;
  VideoPlayerScreen({super.key, required this.mediaPage, required this.index});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool volume = false;
  bool lock = true;
  bool fit = false;
  bool speed = false;
  bool allScreen = false;
  double selected = 1.0;
  List<double> speedList = [
    0.25, 0.50, 1.0, 1.25, 1.50, 1.75, 2.0
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      playVideo(widget.index);
      MyGoogleAdsManager().createInterstitialAd();
    });
    super.initState();
  }

  Future<void> playVideo(int index) async {
    try {
      File file = await PhotoGallery.getFile(mediumId: widget.mediaPage[index].id);
      _controller = VideoPlayerController.file(file);
      _controller?.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
      _controller!.play();
    } catch (e) {
      print("Failed : $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        body: _controller != null ?Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async{
                setState(() {
                  allScreen = !allScreen;
                });
              },
              child: Center(
                child: _controller!.value.isInitialized
                    ? fit == false ?AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ) :VideoPlayer(_controller!)
                    : Container(),
              ),
            ),
            allScreen == true ?ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                lock == true ?Container(height: 40, color: Colors.black54) :Container(),
                lock == true ?Container(
                  height: 50,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                        },
                        child: Icon(Icons.arrow_back, color: AppColors.white, size: 27),
                      ),
                      SizedBox(width: 14),
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                          child: Text(widget.mediaPage[widget.index].filename.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w400))),
                      Spacer(),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          bottomSheet();
                        },
                        child: Image.asset(AppImages.imgPlaylist, height: 32, width: 32),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async{
                            File file = await PhotoGallery.getFile(mediumId: widget.mediaPage[widget.index].id);
                            await Share.shareXFiles([XFile(file.path)]);
                          },
                          child: Image.asset(AppImages.imgShare, height: 32, width: 32),
                        ),
                    ],
                  ),
                ) :Container(),
                lock == true ?Container(height: 3, color: Colors.black54) :Container(),
                lock == true ?Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      setState(() {
                                        volume = !volume;
                                      });
                                      if(volume == true){
                                        _controller!.setVolume(0);
                                      }else{
                                        _controller!.setVolume(1);
                                      }
                                    },
                                    child: Container(
                                      height: 50, width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        alignment: Alignment.center,
                                        child: Image.asset(volume == false ?AppImages.imgVolume :AppImages.imgVolumeOff, height: 45, width: 45)),
                                  ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          if(MediaQuery.of(context).orientation == Orientation.portrait)
                                            {
                                              SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                                            }else {
                                              SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                            }
                        },
                        child: Container(
                            height: 50, width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.center,
                            child: Image.asset(AppImages.imgRotation, height: 45, width: 45)),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          setState(() {
                            speed = !speed;
                          });
                        },
                        child: Container(
                            height: 50, width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4)
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(AppImages.imgSpeed, height: 45, width: 45)),
                      ),
                    ],
                  ),
                ) :Container(),
                lock == true && speed == true ?Container(
                  height: 38,
                  child: ListView.builder(
                    itemCount: speedList.length,
                    padding: EdgeInsets.symmetric(horizontal: 14).copyWith(top: 6),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          setState(() {
                            selected = speedList[index];
                            speed = false;
                          });
                          _controller!.setPlaybackSpeed(speedList[index]);
                        },
                        child: Container(
                          height: 20,
                          width: 40,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: selected == speedList[index] ?AppColors.selectColor:AppColors.white,
                            )
                          ),
                          alignment: Alignment.center,
                          child: Text(speedList[index].toString(), style: TextStyle(color: selected == speedList[index] ?AppColors.selectColor:AppColors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                ) :Container()
              ],
            ) :Container(height: 0),
            allScreen == true ?Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  lock == true ?Container(
                    height: 32,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                        valueListenable: _controller!,
                        builder: (context, VideoPlayerValue value, child) {
                      //Do Something with the value.
                          return Text(value.position.toString().substring(0,7), style: TextStyle(color: AppColors.white));
                        },
                      ),
                        Container(
                            height: 8,
                            width: MediaQuery.of(context).size.width/1.7,
                            child: VideoProgressIndicator(_controller!, allowScrubbing: true, colors: VideoProgressColors(playedColor: AppColors.selectColor))),
                        Text(_controller!.value.duration.toString().substring(0,7), style: TextStyle(color: AppColors.white)),
                      ],
                    ),
                  ) :Container(),
                  lock == true ?Container(height: 14, color: Colors.black54) :Container(),
                  Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black54,
                    padding: EdgeInsets.only(bottom: 14, left: 14, right: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(() {
                              lock = !lock;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(lock == false ?AppImages.imgonlyLock :AppImages.imgUnlock, height: 27, width: 27)),
                        ),
                        Spacer(),
                        lock == true ?GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            if(widget.index != 0){
                              setState(() {
                                widget.index = widget.index - 1;
                                volume = false;
                              });
                              playVideo(widget.index);
                            }
                          },
                          child: Image.asset(AppImages.imgPrevious, height: 32, width: 32),
                        ) :Container(),
                        SizedBox(width: 14),
                        lock == true ?GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                            setState(() {});
                          },
                          child: Image.asset(_controller!.value.isPlaying ?AppImages.imgPause :AppImages.imgPlay2, height: 43, width: 44, fit: BoxFit.cover),
                        ) :Container(),
                        SizedBox(width: 14),
                        lock == true ?GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            if(widget.index < widget.mediaPage.length-1){
                              setState(() {
                                widget.index = widget.index + 1;
                                volume = false;
                              });
                              playVideo(widget.index);
                            }
                          },
                          child: Image.asset(AppImages.imgNext, height: 32, width: 32),
                        ) :Container(),
                        Spacer(),
                        lock == true ?GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(() {
                              fit = !fit;
                            });
                          },
                          child: Icon(Icons.fit_screen_outlined, size: 27, color: AppColors.white),
                        ) :Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ) :Container(height: 0),
          ],
        ) :Container(),
      ),
    );
  }

  bottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      // color is applied to main screen when modal bottom screen is displayed
      barrierColor: Colors.transparent,
      //background color for modal bottom screen
      backgroundColor: AppColors.backColor2,
      //elevates modal bottom screen
      // gives rounded corner to modal bottom screen

      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return Container(
          height: MediaQuery.of(context).size.height/1.9,
          padding: EdgeInsets.symmetric(horizontal: 14).copyWith(top: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Playlist", style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w600)),
              Divider(color: AppColors.grey2, height: 0.1),
              Expanded(
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.9,
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.0 ,
                    crossAxisSpacing: 15.0,
                  ),
                  itemCount: widget.mediaPage.length,
                  padding: EdgeInsets.only(top: 8),
                  itemBuilder: (context, index){
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        setState(() {
                          widget.index = index;
                        });
                        playVideo(index);
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.grey[300],
                              height: 120,
                              //width: MediaQuery.of(context).size.width/2.1,
                              child: Stack(
                                children: [
                                  FadeInImage(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width/2.1,
                                    fit: BoxFit.cover,
                                    placeholder: MemoryImage(kTransparentImage),
                                    image: ThumbnailProvider(
                                      mediumId: widget.mediaPage[index].id,
                                      mediumType: widget.mediaPage[index].mediumType,
                                      highQuality: true,
                                    ),
                                  ),
                                  Center(
                                    child: Image.asset(AppImages.imgPlay, height: 44, width: 44),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width/2.1,
                              child: Text(widget.mediaPage[index].filename.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400)))
                        ],
                      )
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
