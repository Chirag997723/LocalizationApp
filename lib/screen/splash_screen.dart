import 'dart:async';

import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/app_images.dart';
import 'package:asset_player/controller/ad_controller.dart';
import 'package:asset_player/screen/home_screen.dart';
import 'package:asset_player/screen/intro_slider.dart';
import 'package:asset_player/screen/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends StateMVC<SplashScreen> {
  ApiController? _apiController;
  _SplashScreenState() : super (ApiController()){
    _apiController = controller as ApiController;
  }

  @override
  void initState() {
    // TODO: implement initState
    _apiController!.getAdApi(context).then((value) {
     setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.imgSplash),
            fit: BoxFit.fill
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 50),
            Column(
              children: [
                Image.asset(AppImages.imgLogo, height: 170, width: 170),
                SizedBox(height: 10),
                Image.asset(AppImages.imgTitle, height: 56, width: MediaQuery.of(context).size.width/2),
              ],
            ),
            Column(
              children: [
                CircularProgressIndicator(color: AppColors.white),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
