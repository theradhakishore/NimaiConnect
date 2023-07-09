import 'dart:convert';

import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({Key? key}) : super(key: key);

  @override
  State<AllDoctors> createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  late Future doctorsList;

  Future getDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('DoctorsData');
    if (jsonString != null) {
      Map<String, dynamic> DoctorsData = json.decode(jsonString);
      int timestamp = DoctorsData['timestamp'];
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int validityPeriod = 3600000; // 1 hour in milliseconds
      bool isDataValid = (currentTime - timestamp) <= validityPeriod;

      if (!isDataValid) {
        var response = await http
            .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiDoctors'));
        var jsonData = jsonDecode(response.body);

        Map<String, dynamic> DoctorsData = {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': jsonData,
        };
        String jsonString = json.encode(DoctorsData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('DoctorsData', jsonString);
      }
      List<doctorApi> doctors = [];
      for (var c in DoctorsData['data']) {
        doctorApi doctor = doctorApi(
            c['id'].toString(),
            c['firstName'].toString(),
            c['lastName'].toString(),
            c['briefDetails'].toString(),
            c['practicingFrom'].toString());
        doctors.add(doctor);
      }

      return doctors;
    } else {
      var response = await http
          .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiDoctors'));
      var jsonData = jsonDecode(response.body);

      Map<String, dynamic> DoctorsData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': jsonData,
      };
      String jsonString = json.encode(DoctorsData);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('DoctorsData', jsonString);
      List<doctorApi> doctors = [];
      for (var c in DoctorsData['data']) {
        doctorApi doctor = doctorApi(
            c['id'].toString(),
            c['firstName'].toString(),
            c['lastName'].toString(),
            c['briefDetails'].toString(),
            c['practicingFrom'].toString());
        doctors.add(doctor);
      }

      return doctors;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    doctorsList = getDoctors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text(
                      AppLocalizations.of(context).availableDoctors,
                      style: TextStyle(
                          color: ApkColor.Purple,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: doctorsList,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Padding(
                      padding: EdgeInsets.all(64),
                      child: Center(
                          child: SizedBox(
                            height: 40,
                            child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse,

                          /// Required, The loading type of the widget
                            colors: const [
                            ApkColor.darkPurple,
                            ApkColor.Purple,
                            ApkColor.lightPurple
                          ],

                          /// Optional, The color collections
                          strokeWidth: 4,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                        ),
                      )),
                    );
                  } else
                    return Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return TextButton(
                              onPressed: () {
                                // courseID: snapshot.data[i].id
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DoctorDetails(
                                            doctorID: snapshot.data[i].id)));
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                // height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    color: ApkColor.white,
                                    borderRadius: BorderRadius.circular(10)),

                                child: Row(
                                  children: [
                                    if (int.parse(snapshot.data[i].id) % 2 !=
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
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data[i].firstName +
                                                  ' ' +
                                                  snapshot.data[i].lastName,
                                              style: TextStyle(
                                                  color: ApkColor.darkPurple,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              snapshot.data[i].briefDetails,
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
                                                      DateTime.parse(snapshot
                                                          .data[i]
                                                          .practicingFrom)),
                                              style: TextStyle(
                                                  color:
                                                      ApkColor.transparentBlack,
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
                          },
                        ),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class doctorApi {
  final String id, firstName, lastName, briefDetails, practicingFrom;

  doctorApi(this.id, this.firstName, this.lastName, this.briefDetails,
      this.practicingFrom);
}
