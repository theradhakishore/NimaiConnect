import 'package:dr_nimai/dash/doctorAppointment.dart';
import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/dash/referralMail.dart';
import 'package:dr_nimai/getStarted/verification.dart';
import 'package:dr_nimai/l10n/l10n.dart';
import 'package:dr_nimai/provider/localeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


import 'dash/home.dart';
import 'getStarted/login.dart';
import 'getStarted/registration.dart';
import 'getStarted/splash.dart';
import 'res/route.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static String? authTokenValue;

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context)=>ChangeNotifierProvider(
      create: (context)=>LocaleProvider(),
      builder:(context,child){
        final provider=Provider.of<LocaleProvider>(context);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return MaterialApp(
            title: 'Nimai Connect',
            theme: ThemeData(
              fontFamily: 'Poppins',
            ),
            locale: provider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            debugShowCheckedModeBanner: false,
            initialRoute: ApkRoute.SPLASH_SCREEN,
            routes: {
              ApkRoute.SPLASH_SCREEN: (context) => Splash(),
              ApkRoute.LOGIN_FRAGMENT: (context) => Login(),
              ApkRoute.REGISTRATION_FRAGMENT: (context) => Registration(),
              ApkRoute.HOME_FRAGMENT: (context) => Home(),
              ApkRoute.VERIFICATION_FRAGMENT: (context) => Verification(emailID: '', pass: '',),
              ApkRoute.DOCTORDETAILS_FRAGMENT: (context) => DoctorDetails(doctorID: ''),
              ApkRoute.DOCTORAPPOINTMENT_FRAGMENT: (context) => DoctorAppointment(doctorID: ''),
              ApkRoute.DOCTORAPPOINTMENT_FRAGMENT: (context) => DoctorAppointment(doctorID: ''),
              ApkRoute.REFERRAlMAIL_FRAGMENT: (context) => ReferralMail(userName:''),
              // ApkRoute.APPOINTMENT_FRAGMENT: (context)  => Appointment(),
              // ApkRoute.PROFILE_FRAGMENT: (context)  => Profile(),
              // ApkRoute.APPOINTMENTDETAILS_FRAGMENT: (context)  => AppointmentDetails(),
            },
          );


    }
  );
}
