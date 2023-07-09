import 'dart:convert';

import 'package:dr_nimai/dash/allDoctors.dart';
import 'package:dr_nimai/dash/uploadPrescription.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key? key}) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  var appointmentID;
  bool notAvailable=false;
  List<appointmentApi> Appointments = [];

  Future getAppointments() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID=prefs.getInt('userID')!;


    var response = await http.get(Uri.https(
        'nimaidev.azurewebsites.net', 'api/Appointments/${userID}/myappointment'));
    var jsonData = jsonDecode(response.body);

    for (var c in jsonData) {
      appointmentApi appointment = appointmentApi(
        c['id'].toString(),
        c['start'].toString(),
        c['end'].toString(),
        c['doctorName'].toString(),
        c['status'].toString(),
        c['doctor'].toString(),
      );
      Appointments.add(appointment);
    }
    if(Appointments.isEmpty){
      setState(() {
        notAvailable=true;
      });
    }
    return Appointments;
  }
  // Future redirect(int i) async {
  //   try{
  //     final queryParameters = {
  //       'AppointmentId': '1000${Appointments[i].id}',
  //     };
  //     var response = await http.get(Uri.https(
  //         'nimaidev.azurewebsites.net','filemedication/ListMedications',queryParameters));
  //     print(response.statusCode);
  //   }catch(error){
  //     print('$error');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: ApkColor.appBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(22, 20, 22, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppLocalizations.of(context).your,
                            style: TextStyle(
                                color: ApkColor.Purple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            AppLocalizations.of(context).appointments,
                            style: TextStyle(
                                color: ApkColor.lightPurple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      TextButton(

                        style: TextButton.styleFrom(
                          backgroundColor: ApkColor.darkPurple,
                          foregroundColor: ApkColor.white,
                          elevation: 2,
                          padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),


                        ),

                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AllDoctors())
                          );
                        },

                        child: Text(
                          '+ Add',
                          style: TextStyle(

                              fontSize: 14
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: notAvailable,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No Appointments Created',style: TextStyle(color: ApkColor.transparentBlack,fontSize: 16,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: getAppointments(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return Center(
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
                        );
                      } else
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, i) {
                              return TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UploadPrescription(
                                                  appointmentID:
                                                      snapshot.data[i].id,
                                                  doctorID:
                                                      snapshot.data[i].doctor)));
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                  padding: EdgeInsets.fromLTRB(22, 15, 22, 30),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ApkColor.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Color(0xffDDDDDD),
                                    //     blurRadius: 20.0, // soften the shadow
                                    //     spreadRadius: 1.0, //extend the shadow
                                    //   )
                                    // ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dr.' +
                                                    snapshot.data[i].doctorName,
                                                style: TextStyle(
                                                    color: ApkColor.Purple,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 5, 0, 0),
                                                child: Text(
                                                  '${DateFormat.yMMMMd().format(DateTime.parse(snapshot.data[i].start))}',
                                                  style: TextStyle(
                                                    color:
                                                        ApkColor.transparentBlack,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Text(
                                                  '${DateFormat.jm().format(DateTime.parse(snapshot.data[i].start))}-${DateFormat.jm().format(DateTime.parse(snapshot.data[i].end))}',
                                                  style: TextStyle(
                                                    color:
                                                        ApkColor.transparentBlack,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (snapshot.data[i].status ==
                                              'confirmed') ...[
                                            Container(
                                              width: 100,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: ApkColor.confirmed,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              child: Text('Confirmed',
                                                  style: TextStyle(
                                                      color: ApkColor.white)),
                                            ),
                                          ] else ...[
                                            Container(
                                              width: 100,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: ApkColor.waiting,
                                                  borderRadius:
                                                      BorderRadius.circular(100)),
                                              child: Text(
                                                'Waiting',
                                                style: TextStyle(
                                                    color: ApkColor.white),
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class appointmentApi {
  final String id, start, end, doctorName, status, doctor;

  appointmentApi(
      this.id, this.start, this.end, this.doctorName, this.status, this.doctor);
}
