import 'dart:convert';

import 'package:dr_nimai/dash/doctorAppointment.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:dr_nimai/res/route.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetails extends StatefulWidget {
  final String doctorID;

  const DoctorDetails({Key? key, required this.doctorID}) : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  var doctorDetails;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoctorDetails();
  }

  Future getDoctorDetails() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.https(
        'nimaidev.azurewebsites.net', 'api/NimaiDoctors/' + widget.doctorID));
    doctorDetails = jsonDecode(response.body);
    // print(doctorDetails['doctorSlots']);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> videoCall() async {
    // var whatsapp = "+919692881199";
    var vieoCallURl_android = "https://teams.microsoft.com/l/meetup-join/19%3ameeting_OWVlNDM5YmUtMDhiOS00MjJhLWE3OTAtZTVmM2YyZGY2NzA3%40thread.v2/0?context=%7b%22Tid%22%3a%22c123dfed-1dec-42ee-92a8-0833f8fb8c44%22%2c%22Oid%22%3a%224c4c5329-9abf-4c2b-9ca3-cc46333d1db9%22%7d";
    // android , web
    await launch(vieoCallURl_android);
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ApkColor.lightPurple, ApkColor.darkPurple],
                    stops: [0.0, 1.0])),
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: SizedBox(
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
              ),
            ))
        : Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  // Text(
                  //   'Doctor Details ',
                  //   style: TextStyle(
                  //       color: ApkColor.white,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),
                ],
              ),
              backgroundColor: ApkColor.Purple,
              elevation: 0,
              iconTheme: IconThemeData(
                color: ApkColor.white, // <-- SEE HERE
              ),
            ),
            body: SafeArea(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [ApkColor.lightPurple, ApkColor.darkPurple],
                          stops: [0.0, 1.0])),
                  // constraints: BoxConstraints.expand(),
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Image(
                              image:
                                  AssetImage('assets/images/doctorDetails.png')),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/1.5,
                          decoration: BoxDecoration(
                              color: ApkColor.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(16, 25, 16, 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (int.parse(widget.doctorID) % 2 != 0) ...[
                                        Image(
                                          image: AssetImage('assets/icons/maleDoctor.png'),width: MediaQuery.of(context).size.width/4,),
                                      ] else ...[
                                        Image(
                                          image: AssetImage('assets/icons/femaleDoctor.png'),width: MediaQuery.of(context).size.width/4,),
                                      ],
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Dr. ' +
                                                      doctorDetails['firstName'] +
                                                      ' ' +
                                                      doctorDetails['lastName'],
                                                  style: TextStyle(
                                                      color: ApkColor.Purple,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'Practicing from : '+'${DateFormat.yMMMMd().format(DateTime.parse(doctorDetails['practicingFrom']))}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      ApkColor.transparentBlack2),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    elevation: 2,
                                                    backgroundColor: ApkColor.Purple,
                                                    foregroundColor: ApkColor.white,
                                                    padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(100),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorAppointment(doctorID: widget.doctorID)));
                                                  },
                                                  child: Text(
                                                    'Book Appointment',
                                                    // style: TextStyle(color: ApkColor.white, fontSize: 16),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      elevation: 2,
                                                      backgroundColor: ApkColor.lightPurple,
                                                      foregroundColor: ApkColor.white,
                                                      padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(100),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      videoCall();
                                                    },
                                                    child: Text(
                                                      'Video Call',
                                                      // style: TextStyle(color: ApkColor.white, fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 30, 0, 0),
                                        child: Text(
                                          'About Doctor',
                                          style: TextStyle(
                                              color: ApkColor.darkPurple,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Text(doctorDetails['briefDetails']),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          );
  }
}

class doctorDetailsApi {
  final String id, firstName, lastName, briefDetails, practicingFrom;

  doctorDetailsApi(this.id, this.firstName, this.lastName, this.briefDetails,
      this.practicingFrom);
}
