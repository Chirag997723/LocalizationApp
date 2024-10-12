import 'package:flutter/cupertino.dart';

class LanguageChangeProvider with ChangeNotifier{
  Locale _currentLocale = Locale("en");


  Locale get currentLocale => _currentLocale;

  void changeLocale(String _locale){
    this._currentLocale = new Locale(_locale);
    notifyListeners();
  }

}

class LoadingProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  setLoad(bool status) {
    _loading = status;
    notifyListeners();
  }
}