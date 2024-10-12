// To parse this JSON data, do
//
//     final getTestAd = getTestAdFromJson(jsonString);

import 'dart:convert';

GetTestAd getTestAdFromJson(String str) => GetTestAd.fromJson(json.decode(str));

String getTestAdToJson(GetTestAd data) => json.encode(data.toJson());

class GetTestAd {
  String? interstitial;
  String? native;
  String? native1;
  String? appOpenAd;
  int? appVersion;
  bool? isAppIdFromApi;
  String? appId;
  String? toponAppId;
  bool? isToponAppIdFromApi;
  bool? isIntroEverytimeShow;
  bool? isNativeAdsShow;
  bool? splashAdShow;
  bool? adsShow;
  bool? backAdsShow;
  bool? splashOpenAdShow;
  int? appInterCount;
  int? backInterCount;
  bool? isCustomAdsDialogShow;
  int? isHandlerTime;
  int? type;
  int? screen1;
  int? screen2;
  int? screen3;
  int? screen4;
  int? screen5;
  int? screen6;


  GetTestAd({
    this.interstitial,
    this.native,
    this.native1,
    this.appOpenAd,
    this.appVersion,
    this.isAppIdFromApi,
    this.appId,
    this.toponAppId,
    this.isToponAppIdFromApi,
    this.isIntroEverytimeShow,
    this.isNativeAdsShow,
    this.splashAdShow,
    this.adsShow,
    this.backAdsShow,
    this.splashOpenAdShow,
    this.appInterCount,
    this.backInterCount,
    this.isCustomAdsDialogShow,
    this.isHandlerTime,
    this.type,
    this.screen1,
    this.screen2,
    this.screen3,
    this.screen4,
    this.screen5,
    this.screen6,
  });

  factory GetTestAd.fromJson(Map<String, dynamic> json) => GetTestAd(
    interstitial: json["interstitial"],
    native: json["native"],
    native1: json["native_1"],
    appOpenAd: json["appOpenAd"],
    appVersion: json["app_version"],
    isAppIdFromApi: json["is_app_id_from_api"],
    appId: json["app_id"],
    toponAppId: json["topon_app_id"],
    isToponAppIdFromApi: json["is_topon_app_id_from_api"],
    isIntroEverytimeShow: json["is_intro_everytime_show"],
    isNativeAdsShow: json["is_native_ads_show"],
    splashAdShow: json["splash_ad_show"],
    adsShow: json["ads_show"],
    backAdsShow: json["back_ads_show"],
    splashOpenAdShow: json["splash_open_ad_show"],
    appInterCount: json["app_inter_Count"],
    backInterCount: json["back_inter_Count"],
    isCustomAdsDialogShow: json["is_custom_ads_dialog_show"],
    isHandlerTime: json["is_handler_time"],
    type: json["type"],
    screen1: json["screen_1"],
    screen2: json["screen_2"],
    screen3: json["screen_3"],
    screen4: json["screen_4"],
    screen5: json["screen_5"],
    screen6: json["screen_6"],
  );

  Map<String, dynamic> toJson() => {
    "interstitial": interstitial,
    "native": native,
    "native_1": native1,
    "appOpenAd": appOpenAd,
    "app_version": appVersion,
    "is_app_id_from_api": isAppIdFromApi,
    "app_id": appId,
    "topon_app_id": toponAppId,
    "is_topon_app_id_from_api": isToponAppIdFromApi,
    "is_intro_everytime_show": isIntroEverytimeShow,
    "is_native_ads_show": isNativeAdsShow,
    "splash_ad_show": splashAdShow,
    "ads_show": adsShow,
    "back_ads_show": backAdsShow,
    "splash_open_ad_show": splashOpenAdShow,
    "app_inter_Count": appInterCount,
    "back_inter_Count": backInterCount,
    "is_custom_ads_dialog_show": isCustomAdsDialogShow,
    "is_handler_time": isHandlerTime,
    "type": type,
    "screen_1": screen1,
    "screen_2": screen2,
    "screen_3": screen3,
    "screen_4": screen4,
    "screen_5": screen5,
    "screen_6": screen6,
  };
}
