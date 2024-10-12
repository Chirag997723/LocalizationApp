//
// import 'package:loan_calculator_2/screen/home/home_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:loan_calculator_2/screen/introduction/introduction1.dart';
//
// import '../main.dart';
//
// class AppLifecycleReactor {
//   final AppOpenAdManager appOpenAdManager;
//
//   AppLifecycleReactor({required this.appOpenAdManager});
//
//   void listenToAppStateChanges(BuildContext context) {
//     AppStateEventNotifier.startListening();
//     AppStateEventNotifier.appStateStream
//         .forEach((state) => _onAppStateChanged(state, context));
//   }
//
//   void _onAppStateChanged(AppState appState, BuildContext context) {
//     // Try to show an app open ad if the app is being resumed and
//     // we're not already showing an app open ad.
//     if (appState == AppState.foreground) {
//       appOpenAdManager.showAdIfAvailable(context);
//     }
//   }
// }
//
// class AppOpenAdManager {
//    String adUnitId = getTestAd.appOpenAd != null ?getTestAd.appOpenAd! :'ca-app-pub-3940256099942544/9257395921';
//
//    AppOpenAd? _appOpenAd;
//    bool _isShowingAd = false;
//
//    /// Whether an ad is available to be shown.
//    bool get isAdAvailable {
//      return _appOpenAd != null;
//    }
//
//   /// Load an AppOpenAd.
//   void loadAd(BuildContext context) {
//      print(getTestAd.adsShow);
//     if(getTestAd.adsShow == true){
//        if(getTestAd.splashAdShow == true){
//          if(getTestAd.splashOpenAdShow == true){
//            AppOpenAd.load(
//              adUnitId: adUnitId,
//              orientation: AppOpenAd.orientationPortrait,
//              request: AdRequest(),
//              adLoadCallback: AppOpenAdLoadCallback(
//                onAdLoaded: (ad) {
//                  _appOpenAd = ad;
//                  ad.show().then((value) {
//                    if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
//                      Navigator.push(context,MaterialPageRoute(builder: (_)=> Introduction1()));
//                    }else{
//                      Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
//                    }
//                  });
//                },
//                onAdFailedToLoad: (error) {
//                  print('AppOpenAd failed to load: $error');
//                  // Handle the error.
//                },
//              ),
//            );
//          }else{
//              if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
//                Navigator.push(context,MaterialPageRoute(builder: (_)=> Introduction1()));
//              }else{
//                Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
//              }
//          }
//        }else{
//          if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
//            Navigator.push(context,MaterialPageRoute(builder: (_)=> Introduction1()));
//          }else{
//            Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
//          }
//        }
//      }else{
//       if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
//        Navigator.push(context,MaterialPageRoute(builder: (_)=> Introduction1()));
//       }else{
//         Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
//       }
//     }
//   }
//
//   void showAdIfAvailable(BuildContext context) {
//      if (!isAdAvailable) {
//        print('Tried to show ad before available.');
//        loadAd(context);
//        return;
//      }
//      if (_isShowingAd) {
//        print('Tried to show ad while already showing an ad.');
//        return;
//      }
//      // Set the fullScreenContentCallback and show the ad.
//      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
//        onAdShowedFullScreenContent: (ad) {
//          _isShowingAd = true;
//          print('$ad onAdShowedFullScreenContent');
//        },
//        onAdFailedToShowFullScreenContent: (ad, error) {
//          print('$ad onAdFailedToShowFullScreenContent: $error');
//          _isShowingAd = false;
//          ad.dispose();
//          _appOpenAd = null;
//        },
//        onAdDismissedFullScreenContent: (ad) {
//          print('$ad onAdDismissedFullScreenContent');
//          _isShowingAd = false;
//          ad.dispose();
//          _appOpenAd = null;
//          loadAd(context);
//        },
//      );
//      _appOpenAd!.show();
//
//   }
// }
//
// InterstitialAd? _interstitialAd;
// int _numInterstitialLoadAttempts = 0;
// final AdRequest request = AdRequest(
//   keywords: <String>['foo', 'bar'],
//   contentUrl: 'http://foo.com/bar.html',
//   nonPersonalizedAds: true,
// );
// BannerAd? _bannerAd;
//
// class MyGoogleAdsManager{
//
//   void createInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: getTestAd.interstitial != null ?getTestAd.interstitial! :'ca-app-pub-3940256099942544/1033173712',
//         request: request,
//         adLoadCallback: InterstitialAdLoadCallback(
//           onAdLoaded: (InterstitialAd ad) {
//             print('$ad loaded');
//             _interstitialAd = ad;
//             _numInterstitialLoadAttempts = 0;
//             _interstitialAd!.setImmersiveMode(true);
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('InterstitialAd failed to load: $error.');
//             _numInterstitialLoadAttempts += 1;
//             _interstitialAd = null;
//             if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               createInterstitialAd();
//             }
//           },
//         ));
//   }
//
//   Future<void> showInterstitialAd() async{
//     if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
//       inter = 0;
//       if (_interstitialAd == null) {
//         print('Warning: attempt to show interstitial before loaded.');
//         return;
//       }
//       _interstitialAd!.show();
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdShowedFullScreenContent: (InterstitialAd ad) =>
//             print('ad onAdShowedFullScreenContent.'),
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           print('$ad onAdDismissedFullScreenContent.');
//           ad.dispose();
//           createInterstitialAd();
//         },
//         onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//           print('$ad onAdFailedToShowFullScreenContent: $error');
//           ad.dispose();
//           createInterstitialAd();
//         },
//       );
//       _interstitialAd = null;
//     }
//   }
//
//   Future<void> showBackInterstitialAd() async{
//     if (_interstitialAd == null) {
//       print('Warning: attempt to show interstitial before loaded.');
//       return;
//     }
//     _interstitialAd!.show();
//     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//       onAdShowedFullScreenContent: (InterstitialAd ad) =>
//           print('ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (InterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         createInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         createInterstitialAd();
//       },
//     );
//     _interstitialAd = null;
//   }
//
//   bannerAd(String type) {
//     return BannerAd(
//         size: type == "small"
//             ?AdSize.largeBanner
//             :type == "medium"
//               ?AdSize.mediumRectangle
//               :AdSize.leaderboard,
//         adUnitId: 'ca-app-pub-3940256099942544/6300978111',
//         listener: BannerAdListener(
//           onAdLoaded: (Ad ad){},
//           onAdFailedToLoad: (Ad ad, LoadAdError error) {
//             print('$BannerAd failedToLoad: $error');
//             ad.dispose();
//           },
//           onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
//           onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
//         ),
//         request: AdRequest()
//     );
//   }
//
//   backAdShow(){
//     if(getTestAd.adsShow == true){
//       if(getTestAd.backAdsShow == true && backInter == getTestAd.backInterCount){
//         backInter = 0;
//         showBackInterstitialAd();
//       }
//     }
//   }
//
// }


import 'dart:async';
import 'dart:ffi';

import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/screen/home_screen.dart';
import 'package:asset_player/screen/intro_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:asset_player/constants/const.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState appState) {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    print("-------->>>>>> ${appState}");
    if (appState == AppState.foreground) {
      appOpenAdManager.showAdIfAvailable();
    }
  }
}

class AppOpenAdManager {
  String adUnitId = getTestAd.appOpenAd !=  null ?getTestAd.appOpenAd! :'ca-app-pub-3940256099942544/9257395921';

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  final Duration maxCacheDuration = const Duration(hours: 4);

  /// Keep track of load time so we don't show an expired ad.
  DateTime? _appOpenLoadTime;

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  /// Load an AppOpenAd.
  void loadAd() {
    print(getTestAd.adsShow);
    AppOpenAd.load(
      adUnitId: adUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          print('AppOpenAd failed to load: $error');
          // Handle the error.
        },
      ),
    );
  }
  void loadAd1(BuildContext context) {
    print(getTestAd.adsShow);
    if(getTestAd.adsShow == true){
      if(getTestAd.splashAdShow == true){
        if(getTestAd.splashOpenAdShow == true){
          AppOpenAd.load(
            adUnitId: adUnitId,
            orientation: AppOpenAd.orientationPortrait,
            request: AdRequest(),
            adLoadCallback: AppOpenAdLoadCallback(
              onAdLoaded: (ad) {
                _appOpenAd = ad;
                ad.show();
                ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad){
                    if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
                      Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
                    }else{
                      Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
                    }
                  }
                );
              },
              onAdFailedToLoad: (error) {
                if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
                  Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
                }else{
                  Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
                }
                print('AppOpenAd failed to load: $error');
                //loadAd1(context);
                // Handle the error.
              },
            ),
          );
        }else{
          if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
            Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
          }else{
            Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
          }
        }
      }else{
        if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
          Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
        }else{
          Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
        }
      }
    }else{
      if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
        Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
      }else{
        Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
      }
    }
  }

  void showAdIfAvailable() {
    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    if (DateTime.now().subtract(maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _appOpenAd!.dispose();
      _appOpenAd = null;
      loadAd();
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    if(getTestAd.adsShow == true){
      _appOpenAd!.show();
    }
  }
}

InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;
final AdRequest request = AdRequest(
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  nonPersonalizedAds: true,
);
BannerAd? _bannerAd;

class MyGoogleAdsManager{
  String unitId = getTestAd.interstitial != null ?getTestAd.interstitial!
      :"/6499/example/interstitial";

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: unitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void createInterstitialAd1(BuildContext context) {
    if(getTestAd.splashAdShow == true){
      InterstitialAd.load(
          adUnitId: unitId,
          request: request,
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (InterstitialAd ad) {
              print('$ad loaded');
              _interstitialAd = ad;
              _numInterstitialLoadAttempts = 0;
              _interstitialAd!.setImmersiveMode(true);
              showInterstitialAd1(context);
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error.');
              _numInterstitialLoadAttempts += 1;
              _interstitialAd = null;
              if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                createInterstitialAd();
              }
            },
          ));
    }else{
      if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
        Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
      }else{
        Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
      }
    }
  }

  Future<void> showInterstitialAd(BuildContext context, var screen) async{
    if(getTestAd.adsShow == true && inter == getTestAd.appInterCount){
      inter = 0;
      if (_interstitialAd == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }
        _interstitialAd!.show();
      //_interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          Navigator.push(context, _createRoute(screen));
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          Navigator.push(context, _createRoute(screen));
          createInterstitialAd();
        },
      );
      _interstitialAd = null;
    } else{
      inter = inter + 1;
      Navigator.push(context, _createRoute(screen));
    }
  }

  Future<void> showInterstitialAd1(BuildContext context) async{
    if(getTestAd.adsShow == true){
      inter = 0;
      if (_interstitialAd == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }
      _interstitialAd!.show();
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
            Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
          }else{
            Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
          }
          //createInterstitialAd(id);
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          if(getTestAd.isIntroEverytimeShow == true && getTestAd.type != 0){
            Navigator.push(context,MaterialPageRoute(builder: (_)=> IntroSliderScreen()));
          }else{
            Navigator.push(context,MaterialPageRoute(builder: (_)=> HomeScreen()));
          }
          createInterstitialAd();
        },
      );
      _interstitialAd = null;
    }
  }

  Future<void> showBackInterstitialAd(BuildContext context) async{
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.show();
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        Navigator.pop(context);
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        Navigator.pop(context);
        createInterstitialAd();
      },
    );
    _interstitialAd = null;
  }

  Future<void> backAdShow(BuildContext context) async{
    if(getTestAd.adsShow == true && getTestAd.backAdsShow == true && backInter == getTestAd.backInterCount){
        backInter = 0;
        showBackInterstitialAd(context);
    }else{
      Navigator.pop(context);
    }
  }

  Route _createRoute(var screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}