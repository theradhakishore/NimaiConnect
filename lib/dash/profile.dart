import 'package:dr_nimai/dash/medications.dart';
import 'package:dr_nimai/dash/referralMail.dart';
import 'package:dr_nimai/provider/localeProvider.dart';
import 'package:dr_nimai/recorder/recorder_home_view.dart';
import 'package:dr_nimai/res/route.dart';
import 'package:dr_nimai/widgets/custom_dropdownbutton.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}



class _ProfileState extends State<Profile> {

  String userName='';
  String userRegistrationID='';
  bool loading=true;

  final List<String> languages = ['English', 'Hindi'];


  fetchUserDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName=prefs.getString('userName')!;
    userRegistrationID=prefs.getString('userRegistrationID')!;
    setState(() {
      loading=false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<LocaleProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: loading
              ? Center(
            child: Padding(
              padding: EdgeInsets.all(50),
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
          )
              : Container(
            width: MediaQuery.of(context).size.width,
            color: ApkColor.appBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(22, 30, 22, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(AppLocalizations.of(context).your,
                            style: TextStyle(
                                color: ApkColor.Purple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(AppLocalizations.of(context).profile,
                            style: TextStyle(
                                color: ApkColor.lightPurple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                      // Container(
                      //   width: 130,
                      //   margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      //   child: SizedBox(
                      //     height: 40,
                      //     child: DropdownButtonFormField2(
                      //       decoration: InputDecoration(
                      //         //Add isDense true and zero Padding.
                      //         //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      //         isDense: true,
                      //         contentPadding: EdgeInsets.zero,
                      //         // border: InputBorder.none,
                      //         filled: true,
                      //         fillColor: ApkColor.white,
                      //
                      //         border: OutlineInputBorder(
                      //           borderSide: BorderSide.none,
                      //           borderRadius: BorderRadius.circular(100),
                      //         ),
                      //         //Add more decoration as you want here
                      //         //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      //       ),
                      //       isExpanded: true,
                      //       hint: const Text(
                      //         'Language',
                      //         style: TextStyle(
                      //             fontSize: 12,
                      //             color: ApkColor.Purple),
                      //       ),
                      //       icon: const Icon(
                      //         Icons.arrow_drop_down,
                      //         color: ApkColor.Purple,
                      //       ),
                      //       iconSize: 30,
                      //       buttonHeight: 40,
                      //       buttonPadding:
                      //       const EdgeInsets.only(right: 10),
                      //       dropdownDecoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       items: languages
                      //           .map((item) => DropdownMenuItem<String>(
                      //         value: item,
                      //         child: Text(
                      //           item,
                      //           style: const TextStyle(
                      //             fontSize: 14,
                      //           ),
                      //         ),
                      //       ))
                      //           .toList(),
                      //       validator: (value) {
                      //         if (value == null) {
                      //           return 'Please select Doses.';
                      //         }
                      //       },
                      //       onChanged: (value) {
                      //
                      //       },
                      //       onSaved: (value) {
                      //         // doseselectedValue = value.toString();
                      //         // print(doseselectedValue);
                      //       },
                      //     ),
                      //   ),
                      // ),
                      CustomDropDownWidget(provider: provider)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(22, 0, 22, 10),
                  padding: EdgeInsets.fromLTRB(22, 15, 22, 30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ApkColor.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffDDDDDD),
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 1.0, //extend the shadow
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( userName,
                        style: TextStyle(
                            color: ApkColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                        ),
                      ),

                      // Container(
                      //   margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      //   child: Text('+91 9777248034',
                      //     style: TextStyle(
                      //       color: ApkColor.transparentBlack2,
                      //       fontSize: 14,
                      //
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(userRegistrationID.toLowerCase(),
                          style: TextStyle(
                            color: ApkColor.transparentBlack2,
                            fontSize: 14,

                          ),
                        ),
                      ),



                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecorderHomeView(
                              title: 'Voice Prescriptions',
                            )));
                  },
                  child: Container(
                      margin: EdgeInsets.fromLTRB(14, 0,14, 0),
                      padding: EdgeInsets.fromLTRB(22, 15, 22, 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height/8,
                      decoration: BoxDecoration(
                        color: ApkColor.Purple,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffDDDDDD),
                            blurRadius: 20.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                          )
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/icons/record.svg',width: 36,),
                          Container(
                            // margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                            child: Text(AppLocalizations.of(context).record,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: ApkColor.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: FittedBox(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => ReferralMail(userName: userName)
                                )
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(30),

                            width: 120,
                            decoration:BoxDecoration(
                                color: ApkColor.Purple,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffDDDDDD),
                                      offset: Offset(0,4),
                                      blurRadius: 10,
                                      spreadRadius: 0
                                  )]

                            ),

                            child: Column(
                              children: [
                                SvgPicture.asset('assets/icons/refer.svg'),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                  child: FittedBox(
                                    child: Text(AppLocalizations.of(context).refer,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ApkColor.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {

                          },
                          child: Container(
                            padding: EdgeInsets.all(30),

                            width: 120,
                            decoration:BoxDecoration(
                                color: ApkColor.Purple,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffDDDDDD),
                                      offset: Offset(0,4),
                                      blurRadius: 10,
                                      spreadRadius: 0
                                  )]

                            ),

                            child: Column(
                              children: [
                                SvgPicture.asset('assets/icons/contact.svg'),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                  child: FittedBox(
                                    child: Text(AppLocalizations.of(context).contact,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ApkColor.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () { },
                          child: Container(
                            padding: EdgeInsets.all(30),
                            width: 120,
                            decoration:BoxDecoration(
                                color: ApkColor.Purple,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffDDDDDD),
                                      offset: Offset(0,4),
                                      blurRadius: 10,
                                      spreadRadius: 0
                                  )]

                            ),

                            child: Column(
                              children: [
                                SvgPicture.asset('assets/icons/logout.svg'),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 3),
                                  child: FittedBox(
                                    child: Text(AppLocalizations.of(context).logout,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: ApkColor.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
