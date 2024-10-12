import 'dart:developer';

import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class NativeLargeContainer extends StatefulWidget {
  int type;
  NativeLargeContainer({
    Key? key, required this.type
  }) : super(key: key);

  @override
  State<NativeLargeContainer> createState() => _NativeLargeContainerState();
}

class _NativeLargeContainerState extends State<NativeLargeContainer> {
  bool isLoading = false;
  bool failed = false;
  NativeAd? nativeAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nativeAd = NativeAd(
      adUnitId: getTestAd.native != null ?getTestAd.native! :"ca-app-pub-3940256099942544/1044960115",
      factoryId: 'adFactoryExample',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log ('Native Ad is Loaded ---->$ad');
          isLoading = true;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            failed = true;
          });
          log('Native Ad is Failed to Load ---->$error');
        },
      ),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

  @override
  void dispose() {
    nativeAd!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //return Container(height: 0);
    return getTestAd.adsShow == true && getTestAd.isNativeAdsShow == true && widget.type != 0 && failed == false
        ?Container(
      height: 284,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isLoading == true? [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 20.0,
          ),
        ]:[],
      ),
      padding: EdgeInsets.all(2),
      child: isLoading == true && nativeAd!= null ?AdWidget(
          ad: nativeAd!
      ) : Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                color: AppColors.grey,
                margin: EdgeInsets.symmetric(horizontal: 8).copyWith(top: 5),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      color: AppColors.grey,
                      margin: EdgeInsets.all(4),
                    ),
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width/2.4,
                      color: AppColors.grey,
                      margin: EdgeInsets.all(4),
                    ),
                    Container(
                      height: 45,
                      width: 100,
                      color: AppColors.grey,
                      margin: EdgeInsets.all(4),
                    )
                  ],
                ),
              ),
              Container(height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 4)),
            ],
          ),
        ),
      ),
    ):Container(height: 0);
  }
}


