import 'dart:io';

import 'package:asset_player/generated/l10n.dart';
import 'package:asset_player/main.dart';
import 'package:asset_player/widgets/native_medium_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/constants/const.dart';
import 'package:asset_player/screen/home_screen.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool back = false;
  _promptPermissionSetting() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        print("object");
        Navigator.push(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.imgBack1),
              fit: BoxFit.fill
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(S.of(context).storagePermission, style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(S.of(context).permission, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 8),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  _promptPermissionSetting();
                },
                child: Container(
                  height: 46,
                  width: MediaQuery.of(context).size.width/1.2,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.selectColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(S.of(context).allow, style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
              NativeMediumContainer(type: getTestAd.screen3!)
            ],
          ),
        ),
      ),
    );
  }
}
