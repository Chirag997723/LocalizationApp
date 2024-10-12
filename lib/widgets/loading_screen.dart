import 'package:asset_player/constants/app_colors.dart';
import 'package:asset_player/constants/language_change_provider.dart';
import 'package:asset_player/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoadingScreen {
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, LoadingCustom(child: child!));
      } else {
        return LoadingCustom(child: child!);
      }
    };
  }
}
class LoadingCustom extends StatelessWidget {
  final Widget child;
  const LoadingCustom({
    Key? key,
    required this.child
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
        body: ChangeNotifierProvider<LoadingProvider>(
            create: (context) => LoadingProvider(),
            builder: (context, _) {
              return Stack(
                  children: [
                    child,
                    Consumer<LoadingProvider>(
                        builder: (context, provider, child) {
                          return provider.loading
                              ? Container(
                            color: AppColors.white,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                //CircularProgressIndicator(color: AppColors.grey1),
                                Lottie.asset("asset/loading.json", width: 100),
                                SizedBox(height: 10),
                                Text(S.of(context).loading, style: TextStyle(color: AppColors.grey2, fontSize: 16))
                              ],
                            ),
                          )
                              : Container();
                        }
                    )
                  ]
              );
            }
        )
    );
  }
}