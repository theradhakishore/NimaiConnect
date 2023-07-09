import 'dart:convert';

import 'package:dr_nimai/getStarted/verification.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:dr_nimai/res/route.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:http/http.dart'as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  final String emailID;
  final String pass;
  const Verification({Key? key, required this.emailID, required this.pass}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  bool loading = false;
  String passcode="";
  List<userDetailsApi> userDetails=[];


  void emailVerification(String email,String pwd, String passcode) async{
    var response= await http.put(
      Uri.parse("https://nimaidev.azurewebsites.net/api/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'emailID': email,
        'password': pwd,
        'passcode': passcode
      }),
    );
    if(response.statusCode==200){

      var jsonData = jsonDecode(response.body);
      print(jsonData["userId"]);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', jsonData["token"]);
      prefs.setString('userRegistrationID', jsonData["registrationId"]);
      prefs.setInt('userID', jsonData["userId"]);
      prefs.setString('userName', jsonData["firstName"]);

      setState(() {
        loading=false;
      });
      Navigator.of(context).pushReplacementNamed(ApkRoute.HOME_FRAGMENT);
    }
    else{
      setState(() {
        loading=false;
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
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [ApkColor.lightPurple, ApkColor.darkPurple],
                  stops: [0.0, 1.0])),
          constraints: BoxConstraints.expand(),
          child: Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 80, 30, 0),
                        child: Image(
                            image: AssetImage(
                                'assets/images/login.png'),
                            width: 300),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Time and Health',
                              style: TextStyle(
                                  color: ApkColor.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              'are two precious assets',
                              style: TextStyle(
                                color: ApkColor.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 40, 0, 20),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Verification code',
                                    style: TextStyle(
                                        color: ApkColor.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'sent to '+ widget.emailID.toLowerCase(),
                                    style: TextStyle(
                                      color: ApkColor.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 12),
                              child: PinCodeTextField(
                                textStyle: TextStyle(
                                  color: ApkColor.white
                                ),
                                appContext: context,
                                length: 6,
                                onChanged: (value) {
                                  setState(() {
                                    passcode = value;
                                  });
                                },
                                enablePinAutofill: true,
                                pinTheme: PinTheme(
                                  activeColor: ApkColor.lightPurple,
                                  selectedColor: ApkColor.white,
                                  inactiveColor: ApkColor.transparentBlack,
                                  shape: PinCodeFieldShape.box,
                                  fieldHeight: 50,
                                  fieldWidth: 45,
                                ),
                                keyboardType: TextInputType.number,
                                cursorColor: ApkColor.appBackground,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  loading=true;
                                });
                                emailVerification(widget.emailID, widget.pass, passcode);
                              },
                              child: Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.fromLTRB(12, 40, 12, 50),
                                  padding: EdgeInsets.fromLTRB(22, 11, 22, 11),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ApkColor.black,
                                  ),
                                  child: Text(
                                    'Verify Yourself',
                                    style: TextStyle(color: ApkColor.white, fontSize: 20),
                                  )),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              if (loading)
                Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      padding:EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: ApkColor.transparentBlack3
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50,
                            child: LoadingIndicator(
                              indicatorType: Indicator
                                  .ballPulse,

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
                                style: TextStyle(
                                    color: ApkColor.white,
                                    fontSize:14
                                ),
                              ))
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

class userDetailsApi {
  final String token,userId,userName;
  userDetailsApi(this.token,this.userId,this.userName);
}
