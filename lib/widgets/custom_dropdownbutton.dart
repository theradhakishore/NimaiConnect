import 'package:dr_nimai/l10n/l10n.dart';
import 'package:dr_nimai/provider/localeProvider.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CustomDropDownWidget extends StatelessWidget {
  const CustomDropDownWidget({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final LocaleProvider provider;



  @override
  Widget build(BuildContext context) {

    List<Language> languageList = [
      Language(
        langName: 'English',
        locale: const Locale('en'),
      ),
      Language(
        langName: 'हिंदी',
        locale: const Locale('hi'),
      ),
      Language(
        langName: 'ଓଡିଆ',
        locale: const Locale('or'),
      )
    ];

    return Container(
      width: 150,
      child: DropdownButtonFormField2(
        decoration: InputDecoration(
          //Add isDense true and zero Padding.
          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
          isDense: true,
          contentPadding: EdgeInsets.zero,
          // border: InputBorder.none,
          filled: true,
          fillColor: ApkColor.white,

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        isExpanded: true,
        hint: const Text(
          'Languages',
          style: TextStyle(
              fontSize: 14,
              color: ApkColor.Purple),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: ApkColor.Purple,
        ),
        buttonHeight: 40,
        buttonPadding: const EdgeInsets.only( right: 10),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        items:languageList.map<DropdownMenuItem<Locale>>((value) {
          return DropdownMenuItem<Locale>(
            value: value.locale,
            child: Text(value.langName.toString(),
              style: TextStyle(color: Colors.black,fontSize: 14),
            ),
            onTap: (){
              final provider =
              Provider.of<LocaleProvider>(context, listen: false);
              provider.setLocale(value.locale);
            },
          );
        }).toList(),
        // validator: (value) {
        //   if (value == null) {
        //     return 'Please select Food Precaution.';
        //   }
        // },
        onChanged: (value) {
        },
        onSaved: (value) {},
      ),
    );
  }
}

class Language {
  Locale locale;
  String langName;
  Language({
    required this.locale,
    required this.langName,
  });
}




