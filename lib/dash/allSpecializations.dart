import 'dart:convert';

import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllSpecializations extends StatefulWidget {
  final String specializationID;

  const AllSpecializations({Key? key, required this.specializationID})
      : super(key: key);

  @override
  State<AllSpecializations> createState() => _AllSpecializationsState();
}

class _AllSpecializationsState extends State<AllSpecializations> {
  var specializationDetails;
  bool loading = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecializationDetails();
  }

  Future getSpecializationDetails() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.https('nimaidev.azurewebsites.net',
        'api/NimaiSpecializations/' + widget.specializationID));
    specializationDetails = jsonDecode(response.body);
    print(specializationDetails);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Container(
            color: ApkColor.appBackground,
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: SizedBox(
                  height: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,

                    /// Required, The loading type of the widget
                    colors: const [
                      ApkColor.Purple,
                      ApkColor.darkPurple,
                      ApkColor.lightPurple
                    ],

                    /// Optional, The color collections
                    strokeWidth: 4,

                    /// Optional, The stroke of the line, only applicable to widget which contains line
                  ),
                ),
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: ApkColor.appBackground,
              elevation: 0,
              iconTheme: IconThemeData(
                color: ApkColor.Purple, // <-- SEE HERE
              ),
            ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: ApkColor.appBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(22, 0, 22, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Available ' +
                                  specializationDetails[
                                      'specialization'] +
                                  ' Specialists',
                              style: TextStyle(
                                  color: ApkColor.Purple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          // padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                          width: double.infinity,

                          // height: MediaQuery.of(context).size.height / 8,
                          // decoration: BoxDecoration(
                          //   color: ApkColor.white,
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  specializationDetails['doctorSpecializations'].length,
                              itemBuilder: (BuildContext context, index) {
                                return TextButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DoctorDetails(
                                                doctorID: specializationDetails[
                                                'doctorSpecializations']
                                                [index]['id']
                                                    .toString())));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    decoration: BoxDecoration(
                                      color: ApkColor.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    // margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Row(
                                      children: [
                                        if (specializationDetails[
                                                        'doctorSpecializations']
                                                    [index]['id'] %
                                                2 !=
                                            0) ...[
                                          Image(
                                            image: AssetImage(
                                                'assets/icons/maleDoctor.png'),
                                            width: 70,
                                          ),
                                        ] else ...[
                                          Image(
                                            image: AssetImage(
                                                'assets/icons/femaleDoctor.png'),
                                            width: 70,
                                          ),
                                        ],
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  specializationDetails['doctorSpecializations']
                                                              [index]
                                                          ['firstName'] +
                                                      ' ' +
                                                      specializationDetails[
                                                              'doctorSpecializations']
                                                          [
                                                          index]['lastName'],
                                                  style: TextStyle(
                                                      color: ApkColor
                                                          .darkPurple,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  specializationDetails[
                                                          'doctorSpecializations']
                                                      [
                                                      index]['briefDetails'],
                                                  style: TextStyle(
                                                      color: ApkColor
                                                          .transparentBlack2,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'Practicing From : ' +
                                                      DateFormat.yMMMMd().format(
                                                          DateTime.parse(
                                                              specializationDetails['doctorSpecializations']
                                                                      [
                                                                      index]
                                                                  [
                                                                  'practicingFrom'])),
                                                  style: TextStyle(
                                                      color: ApkColor
                                                          .transparentBlack,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
