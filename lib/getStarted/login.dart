import 'dart:convert';
import 'dart:io';

import 'package:dr_nimai/getStarted/verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/color.dart';
import '../res/route.dart';

// import resources

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

bool isObscure = true;

class _LoginState extends State<Login> {
  String hintUserId = 'User ID';
  String hintPassword = 'Password';
  Color hintUserIDColor = ApkColor.transparentBlack;
  Color hintPasswordColor = ApkColor.transparentBlack;

  TextEditingController userID = TextEditingController();
  TextEditingController password = TextEditingController();

  String useridError = '';
  String passwordError = '';
  bool connected = true;
  String apiErr = '';
  bool loading = false;




  @override
  void initState() {
    _fetchConnectivity();

    super.initState();
  }

  _fetchConnectivity() async {
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_FULLSCREEN);

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      connected = false;
      setState(() {});
    }
  }

  postLoginData(String email, String pwd) async {
    var response = await http.post(
      Uri.parse("https://nimaidev.azurewebsites.net/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'emailID': email, 'password': pwd}),
    );
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Verification(emailID: email, pass: pwd)));
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Credentials'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: ApkColor.black,
        padding: EdgeInsets.fromLTRB(32, 16, 16, 16),
        margin: EdgeInsets.fromLTRB(24, 0, 24, 20),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            connected
                ? Container(
                    color: ApkColor.appBackground,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 80, 30, 0),
                          child: Image(
                              image: AssetImage('assets/icons/logo2.png'),
                              width: 300),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0,40),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Time and Health',
                                style: TextStyle(
                                    color: ApkColor.Purple,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text(
                                'are two precious assets',
                                style: TextStyle(
                                  color: ApkColor.Purple,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        ApkColor.lightPurple,
                                        ApkColor.darkPurple
                                      ],
                                      stops: [
                                        0.0,
                                        1.0
                                      ]),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              child: Container(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 40, 0, 0),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Let\'s Begin',
                                              style: TextStyle(
                                                  color: ApkColor.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            // SizedBox(height: 3,),
                                            Text(
                                              'with your User ID',
                                              style: TextStyle(
                                                color: ApkColor.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(22, 20, 22, 0),
                                        padding:
                                            EdgeInsets.fromLTRB(22, 0, 22, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: ApkColor.white),
                                        child: TextField(
                                          controller: userID,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: hintUserId,
                                              hintStyle: TextStyle(
                                                  color: hintUserIDColor,
                                                  fontSize: 14)),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autocorrect: false,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(22, 20, 22, 0),
                                        padding:
                                            EdgeInsets.fromLTRB(22, 0, 22, 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: ApkColor.white),
                                        child: TextField(
                                          controller: password,
                                          obscureText: isObscure,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: hintPassword,
                                              suffixIcon: IconButton(
                                                color: ApkColor.lightPurple,
                                                icon: Icon(isObscure
                                                    ? Icons.visibility
                                                    : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    isObscure = !isObscure;
                                                  });
                                                },
                                              ),
                                              hintStyle: TextStyle(
                                                  color: hintPasswordColor,
                                                  fontSize: 14)),
                                          autocorrect: false,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Create Account ? ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: ApkColor.lightPurple),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pushNamed(
                                                    ApkRoute
                                                        .REGISTRATION_FRAGMENT);
                                              },
                                              child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  // margin: EdgeInsets.fromLTRB(22, 100, 22, 10),
                                                  // padding: EdgeInsets.fromLTRB(22, 11, 22, 11),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    // color: ApkColor.black,
                                                  ),
                                                  child: Text(
                                                    'Sign up',
                                                    style: TextStyle(
                                                        color: ApkColor.white,
                                                        fontSize: 14),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: ApkColor.black,
                                          foregroundColor: ApkColor.white,
                                          elevation: 2,
                                          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100),
                                          ),


                                        ),
                                        onPressed: () async {
                                          if (userID.text.toString() == '') {
                                            setState(() {
                                              hintUserId = "Enter User ID";
                                              hintUserIDColor = Colors.red;
                                            });
                                          }
                                          if (password.text.toString() == '') {
                                            setState(() {
                                              hintPassword = "Enter Password";
                                              hintPasswordColor = Colors.red;
                                            });
                                          }
                                          if (userID.text.toString() != '' &&
                                              password.text.toString() != '') {
                                            // apiErr = '';
                                            setState(() {
                                              loading = true;
                                            });

                                            String emailID = userID.text
                                                .toString()
                                                .toUpperCase();
                                            String pwd =
                                                password.text.toString();
                                            postLoginData(emailID, pwd);
                                          }

                                          // Navigator.of(context).pushNamed(ApkRoute.VERIFICATION_FRAGMENT);
                                        },

                                        child: Text(
                                          'Sign in',
                                          style: TextStyle(
                                              color: ApkColor.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: Center(
                      child: Text('Please Connect to the Internet'),
                    ),
                  ),
            if(loading)
              Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                        color: ApkColor.transparentBlack3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse,

                            /// Required, The loading type of the widget
                            colors: const [
                              ApkColor.white,
                            ],

                            /// Optional, The color collections
                            strokeWidth: 4,

                            /// Optional, The stroke of the line, only applicable to widget which contains line
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'Identifying',
                              style: TextStyle(color: ApkColor.white, fontSize: 14),
                            ))
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
