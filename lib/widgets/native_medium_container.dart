import 'dart:developer';

import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class NativeMediumContainer extends StatefulWidget {
  int type;
  NativeMediumContainer({
    Key? key, required this.type
  }) : super(key: key);

  @override
  State<NativeMediumContainer> createState() => _NativeMediumContainerState();
}

class _NativeMediumContainerState extends State<NativeMediumContainer> {
  bool isLoading = false;
  NativeAd? nativeAd;
  bool failed = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nativeAd = NativeAd(
      adUnitId: getTestAd.native != null ?getTestAd.native! :"ca-app-pub-3940256099942544/2247696110",
      factoryId: 'adFactoryMediumExample',
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
    return getTestAd.adsShow == true  && getTestAd.isNativeAdsShow == true && widget.type != 0 && failed == false
        ?Container(
        height: 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading == true?[
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 20.0,
            ),
          ]:[],
        ),
        child: isLoading == false? Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width/2.4,
                  color: AppColors.grey,
                  margin: EdgeInsets.all(4),
                ),
                SizedBox(width: 3),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width/2.2,
                      color: AppColors.grey,
                      margin: EdgeInsets.only(top: 4),
                    ),
                    Container(
                      height: 42,
                      width: MediaQuery.of(context).size.width/2.2,
                      color: AppColors.grey,
                    ),
                    Container(
                      height: 32,
                      width: MediaQuery.of(context).size.width/2.2,
                      margin: EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.grey
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ) :AdWidget(
            ad: nativeAd!
        )
    ):Container(height: 0);
  }
}


