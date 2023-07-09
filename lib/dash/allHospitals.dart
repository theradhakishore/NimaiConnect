
import 'dart:convert';

import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/dash/hospitalDetails.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllHospitals extends StatefulWidget {
  const AllHospitals({Key? key}) : super(key: key);

  @override
  State<AllHospitals> createState() => _AllHospitalsState();
}

class _AllHospitalsState extends State<AllHospitals> {

  late Future hospitalsList;
  Future getHospitals() async {

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('HospitalData');

    if(jsonString!=null) {
      Map<String, dynamic> HospitalData = json.decode(jsonString);
      int timestamp = HospitalData['timestamp'];
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int validityPeriod = 3600000; // 1 hour in milliseconds
      bool isDataValid = (currentTime - timestamp) <= validityPeriod;

      if (!isDataValid) {
        var response = await http
            .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiHospitals'));
        var jsonData = jsonDecode(response.body);

        Map<String, dynamic> HospitalData = {
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch,
          'data': jsonData,
        };
        String jsonString = json.encode(HospitalData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('HospitalData', jsonString);
      }
      List<hospitalApi> hospitals = [];
      for (var c in HospitalData['data']) {
        hospitalApi hospital = hospitalApi(
            c['id'].toString(),
            c['hospital'].toString(),
            c['details'].toString(),
            c['address'].toString(),
            c['doctorHospitals'].toString());
        hospitals.add(hospital);
      }
      return hospitals;
    }
    else{
      var response = await http
          .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiHospitals'));
      var jsonData = jsonDecode(response.body);

      Map<String, dynamic> HospitalData = {
        'timestamp': DateTime
            .now()
            .millisecondsSinceEpoch,
        'data': jsonData,
      };
      String jsonString = json.encode(HospitalData);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('HospitalData', jsonString);
      List<hospitalApi> hospitals = [];
      for (var c in HospitalData['data']) {
        hospitalApi hospital = hospitalApi(
            c['id'].toString(),
            c['hospital'].toString(),
            c['details'].toString(),
            c['address'].toString(),
            c['doctorHospitals'].toString());
        hospitals.add(hospital);
      }
      return hospitals;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    hospitalsList = getHospitals();
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
                      AppLocalizations.of(context).availableHospitals,
                      style: TextStyle(
                          color: ApkColor.Purple,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                future: hospitalsList,
                builder: (context,
                    AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Padding(
                      padding: EdgeInsets.all(64),
                      child: Center(
                          child: SizedBox(
                            height: 40,
                            child: LoadingIndicator(
                              indicatorType:
                              Indicator.ballPulse,

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
                          itemBuilder:
                              (BuildContext context, int index) {
                            return TextButton(
                              onPressed: () {
                                // courseID: snapshot.data[i].id
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HospitalDetails(
                                            hospitalID: snapshot.data[index].id)
                                    )
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ApkColor.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                        image: AssetImage(
                                            'assets/icons/hospital.png'),width: 100,),
                                    Expanded(
                                      child:
                                      Container(
                                          margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                          child: Text(
                                            snapshot.data[index].hospital+" Hospital",
                                            style: TextStyle(
                                                color: ApkColor.transparentBlack3,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          )),
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
class hospitalApi {
  final String id, hospital, details, address, doctorHospitals;

  hospitalApi(
      this.id, this.hospital, this.details, this.address, this.doctorHospitals);
}
