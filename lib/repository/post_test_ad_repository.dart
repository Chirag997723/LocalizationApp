import 'package:dio/dio.dart';
import 'package:asset_player/constants/app_text.dart';
import 'package:asset_player/models/get_test_ad_model.dart';
import 'package:asset_player/models/post_test_ad_model.dart';

Dio dio = Dio();


Future<PostTestAd?> postTestAdRepository() async{
  try{
    Response response;
    response = await dio.post(
        AppText.postUrl,
        options: Options(
            headers: {
              "accept": "application/json",
              "Content-Type": "application/json"
            }),
        data: {
          "payload": {
            "data": {
              "ads_info": [
                {
                  "interstitial": "/6499/example/interstitial",
                  "interstitial_1": "/6499/example/interstitial",
                  "native": "ca-app-pub-3940256099942544/1044960115",
                  "native_1": "ca-app-pub-3940256099942544/1044960115",
                  "native_2": "ca-app-pub-3940256099942544/1044960115",
                  "appOpenAd": "ca-app-pub-3940256099942544/9257395921",
                  "appOpenAd_1": "ca-app-pub-3940256099942544/9257395921",
                  "bannerAd": "ca-app-pub-3940256099942544/6300978111",
                  "appOpenCount": 2,
                  "app_version": 1,
                  "blank_screen_show": false,
                  "is_app_id_from_api": true,
                  "app_id": "ca-app-pub-3940256099942544~33475117",
                  "is_redirect_in_splash": false,
                  "is_redirect_url": "https://play.google.com/store/apps/details?id=com.instagram.android",
                  "topon_app_id": "1234567899",
                  "is_topon_app_id_from_api": true,
                  "is_intro_everytime_show": true,
                  "is_native_ads_show": true,
                  "splash_ad_show": true,
                  "ads_show": true,
                  "back_ads_show" : true,
                  "splash_open_ad_show": true,
                  "app_inter_Count": 2,
                  "back_inter_Count": 2,
                  "is_custom_ads_dialog_show": false,
                  "is_handler_time": 2000,
                  "type": 4,
                  "screen_1": 3,
                  "screen_2": 3,
                  "screen_3": 3,
                  "screen_4": 3,
                  "screen_5": 3,
                  "screen_6": 3,
                }
              ]
            }
          }
        }
    );
    print("statusCode---> ${response.statusCode}");
    if(response.statusCode == 200){
      PostTestAd postTestAd = PostTestAd.fromJson(response.data);
      return postTestAd;
    }else{
      throw Exception(response.data);
    }
  }on DioError catch(e){
    print("error---> $e");
  }
}

Future<List<dynamic>?> getTestAdRepository() async{
  try{
    Response response;
    response = await dio.get(
        AppText.getUrl,
        options: Options(
            headers: {
              "accept": "application/json",
              "Content-Type": "application/json"
            }),
    );
    print("statusCode---> ${response.statusCode}");
    if(response.statusCode == 200){
      List<dynamic> getTestAd = response.data;
    return getTestAd;
    }else{
      throw Exception(response.data);
    }
  }on DioError catch(e){
    print("error---> $e");
  }
}