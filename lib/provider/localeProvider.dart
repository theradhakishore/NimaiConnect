
import 'package:dr_nimai/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier{
  Locale? _locale;
  Locale? get locale => _locale;
  void setLocale(Locale locale){

    if(!L10n.all.contains(locale)) return;

    _locale=locale;
    notifyListeners();
  }

  // void clearLocale(){
  //   _locale= Locale.;
  //   notifyListeners();
  // }

}