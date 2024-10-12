
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:asset_player/constants/AppLifecycleReactor.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/screen/video_player.dart';
import 'package:asset_player/widgets/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asset_player/constants/const.dart';
import 'package:asset_player/models/custom_model.dart';
import 'package:path/path.dart' as path;


class CustomVideoWidget extends StatefulWidget {
  CustomVideoWidget({super.key});

  @override
  State<CustomVideoWidget> createState() => _CustomVideoWidgetState();
}

class _CustomVideoWidgetState extends State<CustomVideoWidget> {
  List<Custom> _albums = [];
  List<Medium> _mediumList = [];
  List<Custom1> folderList = [];
  List<int> lengthList = [];
  bool _loading = false;
  bool grid = false;
  String sort = "Date";
  String sortVia = "From new to old";

  @override
  void initState() {
    // TODO: implement initState
    initAsync();
    MyGoogleAdsManager().createInterstitialAd();
    super.initState();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums = await PhotoGallery.listAlbums(
          mediumType: MediumType.video
      );
      for(int i=0; i<albums.length; i++){
          MediaPage mediaPage = await albums[i].listMedia();
          folderList.add(Custom1(albums[i], mediaPage.items.length));
      }
      setState(() {});
      for(int i=0; i<albums.length; i++){
        if(i != 0){
          MediaPage mediaPage = await albums[i].listMedia();
          for(int j=0; j<mediaPage.items.length; j++){
            _mediumList.add(mediaPage.items[j]);
            _albums!.add(Custom(mediaPage.items[j], albums[i].name.toString()));
          }
        }
      }
      setState(() {});
      _albums.sort((a, b) {
        return b.medium!.creationDate.toString().toLowerCase().compareTo(a.medium!.creationDate.toString().toLowerCase());
      });
      _mediumList.sort((a,b) {
        return b.creationDate.toString().toLowerCase().compareTo(a.creationDate.toString().toLowerCase());
      });
    }
    setState(() {
      _loading = false;
    });
  }


  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted || await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Container(
        color: AppColors.backColor,
        padding: EdgeInsets.symmetric(horizontal: 10).copyWith(top: 6),
        child: Column(
          children: [
            Container(
              height: 44,
              color: AppColors.backColor,
              padding: EdgeInsets.only(bottom: 4, right: 4, left: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  customContainer(S.of(context).folder, 1),
                  customContainer(S.of(context).video, 0),
                  Spacer(),
                  selectIndex == 0 ?GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      openSort().then((value) {
                        if(value != null){
                          if(value == S.of(context).ntoo){
                            _albums.sort((a, b) {
                              return b.medium!.creationDate.toString().toLowerCase().compareTo(a.medium!.creationDate.toString().toLowerCase());
                            });
                            _mediumList.sort((a,b){
                              return b.creationDate.toString().toLowerCase().compareTo(a.creationDate.toString().toLowerCase());
                            });
                          }else if(value == S.of(context).oton){
                            _albums.sort((a, b) {
                              return a.medium!.creationDate.toString().toLowerCase().compareTo(b.medium!.creationDate.toString().toLowerCase());
                            });
                            _mediumList.sort((a,b){
                              return a.creationDate.toString().toLowerCase().compareTo(b.creationDate.toString().toLowerCase());
                            });
                          }else if(value == S.of(context).atoz){
                            _albums.sort((a, b) {
                              return a.medium!.filename.toString().toLowerCase().compareTo(b.medium!.filename.toString().toLowerCase());
                            });
                            _mediumList.sort((a,b){
                              return a.filename.toString().toLowerCase().compareTo(b.filename.toString().toLowerCase());
                            });
                          }else{
                            _albums.sort((a, b) {
                              return b.medium!.filename.toString().toLowerCase().compareTo(a.medium!.filename.toString().toLowerCase());
                            });
                            _mediumList.sort((a,b){
                              return b.filename.toString().toLowerCase().compareTo(a.filename.toString().toLowerCase());
                            });
                          }
                          setState(() {});
                        }
                      });
                    },
                    child: Image.asset(AppImages.imgSort, color: AppColors.white, height: 24, width: 24),
                  ) :Container(),
                  SizedBox(width: 14),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (){
                      setState(() {
                          grid = !grid;
                      });
                    },
                    child: Image.asset(AppImages.imgGrid, color: AppColors.white, height: 24, width: 24),
                  ),
                ],
              ),
            ),
            selectIndex == 0 ?Expanded(
              child: _albums.isEmpty
                  ? Center(
                child: CircularProgressIndicator(color: AppColors.white),
              )
                  : LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: GridView.builder(
                      itemCount: _albums.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: grid == true ?0.9:3,
                        crossAxisCount: grid == true ?2:1,
                        mainAxisSpacing: grid == true ?15.0 :17,
                        crossAxisSpacing: grid == true ?15.0:5.0,
                      ),
                      itemBuilder: (context, index){
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if(getTestAd.appInterCount == inter && getTestAd.adsShow == true){
                              context.read<LoadingProvider>().setLoad(true);
                              Timer(Duration(seconds: 5), () {
                                context.read<LoadingProvider>().setLoad(false);
                                MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: _mediumList, index: index));
                              });
                            }else{
                                MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: _mediumList, index: index));
                            }
                          },
                          child: grid == true ?Column(
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
                                          mediumId: _albums[index].medium!.id,
                                          mediumType: _albums[index].medium!.mediumType,
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
                                width: MediaQuery.of(context).size.width/2.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 40,
                                        width: MediaQuery.of(context).size.width/2.8,
                                        child: Text(_albums[index].medium!.filename.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400))),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        bottomSheet(_albums[index].medium!.id, index, _albums[index].medium!);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: Icon(Icons.more_vert, color: AppColors.unselectColor, size: 27),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ):Row(
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
                                          mediumId: _albums[index].medium!.id,
                                          mediumType: _albums[index].medium!.mediumType,
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
                                        child: Text(_albums[index].medium!.filename.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400))),
                                    SizedBox(height: 2),
                                    Text(_albums[index].medium!.creationDate.toString().substring(0,19), style: TextStyle(color: AppColors.unselectColor, fontSize: 14)),
                                    SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Container(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(
                                                    color: AppColors.unselectColor,
                                                    width: 1.5
                                                )
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            child: Row(
                                              children: [
                                                Icon(Icons.folder, color: AppColors.selectColor, size: 20),
                                                SizedBox(width: 4),
                                                Text(_albums[index].name.toString(), maxLines: 1, style: TextStyle(color: AppColors.unselectColor, fontSize: 14))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            bottomSheet(_albums[index].medium!.id, index, _albums[index].medium!);
                                          },
                                          behavior: HitTestBehavior.translucent,
                                          child: Icon(Icons.more_vert, color: AppColors.unselectColor, size: 27,),
                                        )
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
            ) :Expanded(
              child: folderList.isEmpty
                  ? Center(
                child: CircularProgressIndicator(color: AppColors.white),
              )
                  : LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    margin: EdgeInsets.only(top: 4),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: grid == true ?0:8),
                    child: GridView.count(
                      childAspectRatio: grid == true ?0.8:4,
                      crossAxisCount: grid == true ?3:1,
                      mainAxisSpacing: grid == true ?15.0 :0,
                      crossAxisSpacing: grid == true ?15.0:5.0,
                      children: <Widget>[
                        ...?folderList?.map(
                              (album) {
                                return GestureDetector(
                                  onTap: () async{
                                    MediaPage mediaPage = await album.album1!.listMedia();
                                    if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
                                      context.read<LoadingProvider>().setLoad(true);
                                      Timer(Duration(seconds: 5), () {
                                        context.read<LoadingProvider>().setLoad(false);
                                        MyGoogleAdsManager().showInterstitialAd(context, VideoListScreen(
                                          title: album.album1!.name.toString(),
                                          album: mediaPage,
                                        ));
                                      });
                                    }else{
                                      MyGoogleAdsManager().showInterstitialAd(context, VideoListScreen(
                                        title: album.album1!.name.toString(),
                                        album: mediaPage,
                                      ));
                                    }
                                  },
                                  child: grid == true ?Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(AppImages.imgFolder, height: 60, width: 60, color: AppColors.selectColor),
                                        SizedBox(height: 6),
                                        Container(
                                            width: MediaQuery.of(context).size.width/3,
                                            child: Text(album!.album1!.name.toString(), textAlign: TextAlign.center, maxLines: 1, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400))),
                                        Text("${album.length.toString()} Videos", style: TextStyle(color: AppColors.grey, fontSize: 12))
                                      ],
                                    ),
                                  ):Container(
                                    decoration: BoxDecoration(
                                        border: Border.symmetric(horizontal: BorderSide(color: AppColors.unselectColor, width: 0.1))
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(AppImages.imgFolder, height: 60, width: 60, color: AppColors.selectColor),
                                        SizedBox(width: 10),
                                        Container(
                                          width: MediaQuery.of(context).size.width/1.8,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/1.8,
                                                  child: Text(album.album1!.name.toString(), overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w400))),
                                              SizedBox(height: 2),
                                              Text("${album.length.toString()} Videos", style: TextStyle(color: AppColors.unselectColor, fontSize: 14))
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){},
                                          behavior: HitTestBehavior.translucent,
                                          child: Icon(Icons.arrow_forward_ios_outlined, color: AppColors.unselectColor, size: 16,),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
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
                      MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: _mediumList, index: index1));
                    });
                  }else{
                    MyGoogleAdsManager().showInterstitialAd(context, VideoPlayerScreen(mediaPage: _mediumList, index: index1));
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

  Widget customContainer(String title, int subIndex){
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          selectIndex = subIndex;
        });
      },
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: selectIndex == subIndex ?AppColors.selectColor :AppColors.backColor,
          borderRadius: BorderRadius.circular(12)
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: selectIndex ==  subIndex ?AppColors.white:AppColors.unselectColor, fontSize: 16, fontWeight: FontWeight.w400)),
      ),
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
