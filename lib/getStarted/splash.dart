import 'dart:async';

import 'package:dr_nimai/dash/maintenance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../res/color.dart';
import '../res/route.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  late final LocalAuthentication auth;
  bool _supportState=false;
  
  // void checkBiometric(){
  //   auth=LocalAuthentication();
  //   auth.isDeviceSupported().then(
  //           (bool isSupported) => setState((){
  //             _supportState=isSupported;
  //           }),
  //   );
  // }
  //
  // Future<void> _getAvailableBiometrics() async{
  //   List<BiometricType> availableBiometrics=await auth.getAvailableBiometrics();
  //   if(!mounted){
  //     return;
  //   }
  // }
  //
  // Future<void> _autheticate() async{
  //   try{
  //     bool authenticated = await auth.authenticate(
  //       localizedReason: "by scanning your Finger Prints",
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: false,
  //       )
  //     );
  //     if(authenticated){
  //         Navigator.pushReplacementNamed(context, ApkRoute.HOME_FRAGMENT);
  //     }else{
  //         Navigator.pushReplacementNamed(context, ApkRoute.LOGIN_FRAGMENT);
  //
  //     }
  //   }on PlatformException catch(e){
  //     print(e);
  //   }
  //
  // }


  Future<void> userCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('userToken'));

    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(context,MaterialPageRoute(builder: (context) =>Maintenance()));
        });
    // if(prefs.getString('userToken')!=null) {
    //   // _getAvailableBiometrics();
    //   // if(_supportState){
    //   //   _autheticate();
    //   // }
    //   Future.delayed(Duration(seconds: 3), () {
    //     Navigator.pushReplacementNamed(context, ApkRoute.HOME_FRAGMENT);
    //   });
    // }else{
    //   Future.delayed(Duration(seconds: 3), () {
    //     Navigator.pushReplacementNamed(context, ApkRoute.LOGIN_FRAGMENT);
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    // checkBiometric();
    userCheck();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(),
          color: ApkColor.appBackground,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(
                    image: AssetImage('assets/icons/splash.png'), width: 180),
              ),
              Container(
                child: SizedBox(
                  height: 40,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,

                    /// Required, The loading type of the widget
                    colors: const [
                      ApkColor.lightPurple,
                      ApkColor.Purple
                    ],

                    /// Optional, The color collections
                    strokeWidth: 4,

                    /// Optional, The stroke of the line, only applicable to widget which contains line
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('Nimai ',style: TextStyle(color: ApkColor.Purple,fontSize: 28,fontWeight: FontWeight.bold),),
                    // Text('Connect',style: TextStyle(color: ApkColor.lightPurple,fontSize: 28,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
