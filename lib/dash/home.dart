import 'package:dr_nimai/dash/appointments.dart';
import 'package:dr_nimai/dash/medications.dart';
import 'package:flutter/material.dart';
import 'package:dr_nimai/dash/dashboard.dart';
import 'package:dr_nimai/dash/profile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../res/color.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {



  int index = 0;
  int dexLength = 4;
  List<Color> dexColor = [ApkColor.Purple, ApkColor.transparentBlack, ApkColor.transparentBlack,ApkColor.transparentBlack];

  PageController _pageViewController = PageController();
  List<Widget> _screens = [ Dashboard(), Medications(),Appointments(), Profile()];

  bool isSetListenersAppointment = false;



  void _onPageChanged (int index) {
    setState(() {
      this.index = index;
    });
  }

  void onItemTapped (int index) {

    dexColor.clear();
    dexColor = List.filled(dexLength, ApkColor.transparentBlack, growable: true);
    dexColor[index] = ApkColor.Purple;
    _pageViewController.jumpToPage(index);

  }



  @override
  Widget build(BuildContext context) {

    // TODO: documentation
    // data = ModalRoute.of(context)?.settings.arguments as Map;
    // print('FUCKER');



    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(

      body: PageView(
        controller: _pageViewController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),


      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: ApkColor.transparentBlack,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/home.svg', color: dexColor[0],),
              label: AppLocalizations.of(context).dashboard,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/medication.svg', color: dexColor[1],),
            label: AppLocalizations.of(context).medications,
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/appointments.svg', color: dexColor[2],),
              label: AppLocalizations.of(context).appointments
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/profile.svg', color: dexColor[3],),
              label: AppLocalizations.of(context).profile
          )
        ],
        currentIndex: index,
        backgroundColor: ApkColor.white,
        selectedItemColor: ApkColor.Purple,
        showSelectedLabels: true,
        showUnselectedLabels: true,

        onTap: (int index) {
          onItemTapped(index);
          // onTapBottomNav(index, context);
        },
      ),

    );
  }
}

