import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/models/custom_model.dart';
import 'package:asset_player/screen/video_player.dart';
import 'package:asset_player/widgets/native_large_container.dart';
import 'package:asset_player/widgets/native_medium_container.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

class VideoListScreen extends StatefulWidget {
  String title;
  MediaPage album;
  VideoListScreen({super.key, required this.title, required this.album});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  String sort = "Date";
  String sortVia = "From new to old";
  bool search = false;
  TextEditingController controller = TextEditingController();
  MediaPage? mediaPage;

  @override
  void initState() {
    // TODO: implement initState
    MyGoogleAdsManager().createInterstitialAd();
    setState(() {
      mediaPage = widget.album;
    });
    widget.album.items.sort((a, b) {
      return b.creationDate.toString().toLowerCase().compareTo(a.creationDate.toString().toLowerCase());
    });
    super.initState();
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
          backgroundColor: AppColors.backColor,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: AppColors.white),
          title: Text(widget.title, style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w400)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  openSort().then((value) {
                    if(value != null){
                      if(value == S.of(context).ntoo){
                        widget.album.items.sort((a, b) {
                          return b.creationDate.toString().toLowerCase().compareTo(a.creationDate.toString().toLowerCase());
                        });
                      }else if(value == S.of(context).oton){
                        widget.album.items.sort((a, b) {
                          return a.creationDate.toString().toLowerCase().compareTo(b.creationDate.toString().toLowerCase());
                        });
                      }else if(value == S.of(context).atoz){
                        widget.album.items.sort((a, b) {
                          return a.filename.toString().toLowerCase().compareTo(b.filename.toString().toLowerCase());
                        });
                      }else{
                        widget.album.items.sort((a, b) {
                          return b.filename.toString().toLowerCase().compareTo(a.filename.toString().toLowerCase());
                        });
                      }
                      setState(() {});
                    }
                  });
                },
                child: Image.asset(AppImages.imgSort, height: 24, width: 24),
              ),
            )
          ],
        ),
        body: widget.album.items.isEmpty
            ? Center(
          child: Text(S.of(context).noVideo, style: TextStyle(color: AppColors.grey, fontSize: 16)),
        )
            : LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 17,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 3,
                ),
                itemCount: widget.album.items.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                        context.read<LoadingProvider>().setLoad(true);
                        Timer(Duration(seconds: 5), () {
                          context.read<LoadingProvider>().setLoad(false);
                          MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: widget.album.items, index: index));
                        });
                      }else{
                        MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: widget.album.items, index: index));
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            color: Colors.grey[300],
                            width: MediaQuery.of(context).size.width/3,
                            child: Stack(
                              children: [
                                FadeInImage(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width/2.4,
                                  fit: BoxFit.cover,
                                  placeholder: MemoryImage(kTransparentImage),
                                  image: ThumbnailProvider(
                                    mediumId: widget.album.items[index].id,
                                    mediumType: widget.album.items[index].mediumType,
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
                        SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width/1.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width/1.8,
                                  child: Text(widget.album.items[index].filename.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400))),
                              SizedBox(height: 2),
                              Text(widget.album.items[index].creationDate.toString().substring(0,19), style: TextStyle(color: AppColors.unselectColor, fontSize: 14)),
                              SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      bottomSheet(widget.album.items[index].id, index, widget.album.items[index]);
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Icon(Icons.more_vert, color: AppColors.unselectColor, size: 27,),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: NativeMediumContainer(type: getTestAd.screen5!),
      ),
    );
  }

  Future openSort() {
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState){
              return AlertDialog(
                title: Align(
                  alignment: Alignment.topLeft,
                  child: Text(S.of(context).sortBy, style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          sort = S.of(context).date;
                        });
                      },
                      child: Container(
                        height: 42,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: sort == S.of(context).date ?AppColors.selectColor:Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).date, style: TextStyle(color: sort == S.of(context).date ?AppColors.white:AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                            sort == S.of(context).date ?Icon(Icons.check_circle, color: AppColors.white, size: 27):Container(),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          sort = S.of(context).name;
                        });
                      },
                      child: Container(
                        height: 42,
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: sort == S.of(context).name ?AppColors.selectColor:Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).name, style: TextStyle(color: sort == S.of(context).name ?AppColors.white:AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                            sort == S.of(context).name ?Icon(Icons.check_circle, color: AppColors.white, size: 27):Container(),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColors.grey, height: 0.1,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          sortVia = sort == S.of(context).date ?S.of(context).ntoo:S.of(context).ztoa;
                        });
                      },
                      child: Container(
                        height: 42,
                        margin: EdgeInsets.only(bottom: 8, top: 8),
                        decoration: BoxDecoration(
                          color: sortVia == S.of(context).ztoa || sortVia ==  S.of(context).ntoo  ?AppColors.selectColor:Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sort == S.of(context).date ?S.of(context).ntoo:S.of(context).ztoa, style: TextStyle(color: sortVia == S.of(context).ztoa || sortVia ==  S.of(context).ntoo  ?AppColors.white:AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                            sortVia == S.of(context).ztoa || sortVia ==  S.of(context).ntoo ?Icon(Icons.check_circle, color: AppColors.white, size: 27):Container(),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          sortVia = sort == S.of(context).date ?S.of(context).oton:S.of(context).atoz;
                        });
                      },
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: sortVia == S.of(context).oton || sortVia == S.of(context).atoz ?AppColors.selectColor:Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sort == S.of(context).date ?S.of(context).oton:S.of(context).atoz, style: TextStyle(color: sortVia == S.of(context).oton || sortVia == S.of(context).atoz?AppColors.white:AppColors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                            sortVia == S.of(context).oton || sortVia == S.of(context).atoz ?Icon(Icons.check_circle, color: AppColors.white, size: 27):Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 100,
                          height: 38,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.selectColor
                              ),
                              borderRadius: BorderRadius.circular(8)
                          ),
                          alignment: Alignment.center,
                          child: Text(S.of(context).cancel, style: TextStyle(color: AppColors.selectColor, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          Navigator.pop(context, sort == S.of(context).date
                              ?sortVia == S.of(context).oton ?S.of(context).oton:S.of(context).ntoo
                              :sortVia == S.of(context).ztoa ?S.of(context).ztoa:S.of(context).atoz);
                        },
                        child: Container(
                          width: 100,
                          height: 38,
                          decoration: BoxDecoration(
                              color: AppColors.selectColor,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          alignment: Alignment.center,
                          child: Text(S.of(context).ok, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        }
    );
  }

  bottomSheet(String id, int index1, Medium medium) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      // color is applied to main screen when modal bottom screen is displayed
      barrierColor: Colors.transparent,
      //background color for modal bottom screen
      backgroundColor: AppColors.backColor1,
      //elevates modal bottom screen
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        List<Custom2> bottomList = [
          Custom2(AppImages.imgTransPlay, S.of(context).play),
          Custom2(AppImages.imgShare, S.of(context).share),
          Custom2(AppImages.imgInfo, S.of(context).fileInfo),
          Custom2(AppImages.imgRename, S.of(context).rename),
          Custom2(AppImages.imgDelete, S.of(context).delete),
        ];
        // UDE : SizedBox instead of Container for whitespaces
        return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: bottomList.length,
          padding: EdgeInsets.only(top: 8),
          itemBuilder: (context, index){
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async{
                if(index == 0) {
                  if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                    context.read<LoadingProvider>().setLoad(true);
                    Timer(Duration(seconds: 5), () {
                      context.read<LoadingProvider>().setLoad(false);
                      MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: widget.album.items, index: index1));
                    });
                  }else{
                    MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: widget.album.items, index: index1));
                  }
                }else if(index == 4){
                  PhotoGallery.deleteMedium(mediumId: id);
                }else if(index == 1) {
                  File file = await PhotoGallery.getFile(mediumId: id);
                  await Share.shareXFiles([XFile(file.path)]);
                }else if(index == 2){
                  File file = await PhotoGallery.getFile(mediumId: id);
                  int bytes = await file.length();
                  var i = (log(bytes) / log(1024)).floor();
                  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
                  print(((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i]);
                  infoDialog(medium, file.path, ((bytes / pow(1024, i)).toStringAsFixed(1)) + ' ' + suffixes[i]);
                }else{
                  TextEditingController controller = TextEditingController();
                  renameDialog(id, controller);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 12),
                height: 48,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border(bottom: BorderSide(color: AppColors.grey, width: 0.1))
                ),
                margin: EdgeInsets.symmetric(vertical: 6),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(bottomList[index].image, height: 44, width: 44),
                    SizedBox(width: 18),
                    Text(bottomList[index].title, style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w400))
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget customRow(String title, String subtitle) {
    return Text.rich(
      maxLines: 3,
      TextSpan(
        children: [
          TextSpan(text: title, style: TextStyle(color: AppColors.black1, fontSize: 16, fontWeight: FontWeight.w600)),
          TextSpan(text: subtitle, style: TextStyle(color: AppColors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
        ]
      )
    );
  }

  infoDialog(Medium medium, String path, String size){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Center(child: Text(S.of(context).fileInfo, style: TextStyle(color: AppColors.black1, fontSize: 20, fontWeight: FontWeight.w600))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customRow("${S.of(context).file}:   ", medium.filename.toString()),
              customRow("${S.of(context).location}:   ", path),
              customRow("${S.of(context).size}:   ", size),
              customRow("${S.of(context).date}:   ", medium.creationDate.toString().substring(0,19)),
            ],
          ),
        );
      }
    );
  }

  renameDialog(String id, TextEditingController controller){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              content: TextField(
                controller: controller,
                style: TextStyle(color: AppColors.black1),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: S.of(context).enterName,
                    hintStyle: TextStyle(
                        color: AppColors.grey, fontSize: 16
                    )
                ),
                onChanged: (String? val){
                  setState((){
                    controller.text = val!;
                  });
                },
              ),
              actions: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async{
                    File file = await PhotoGallery.getFile(mediumId: id);
                    String dir = path.dirname(file.path);
                    String newPath = path.join(dir, '${controller.text}${path.extension(file.path)}');
                    print('NewPath: ${newPath}');
                    file.renameSync(newPath);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 34,
                    width: 150,
                    decoration: BoxDecoration(
                        color: AppColors.selectColor,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    alignment: Alignment.center,
                    child: Text(S.of(context).rename, style: TextStyle(color: AppColors.white, fontSize: 16)),
                  ),
                )
              ],
            );
          },
        );
      }
    );
  }
}
