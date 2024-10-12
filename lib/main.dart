import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/models/get_test_ad_model.dart';
import 'package:asset_player/screen/splash_screen.dart';
import 'package:asset_player/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';

int selectIndex = 1;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

const int maxFailedLoadAttempts = 3;
int inter = 0;
int backInter = 0;
GetTestAd getTestAd = GetTestAd();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>(
        create: (context) =>  LanguageChangeProvider(),
        child: Builder(
        builder: (context) => GlobalLoaderOverlay(
          child: MaterialApp(
            title: 'Asset Player',
            debugShowCheckedModeBanner: false,
            builder: LoadingScreen.init(),
            locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.selectColor),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
          overlayColor: AppColors.white,
          useDefaultLoading: false,
          overlayWidgetBuilder: (_) { //ignored progress for the moment
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                //CircularProgressIndicator(color: AppColors.grey1),
                  Lottie.asset("assets/loading.json", width: 100),
                  SizedBox(height: 10),
                  Text(S.of(context).loading, style: TextStyle(color: AppColors.grey2, fontSize: 16))
                ],
              ),
            );
          },
      )));
  }
}

