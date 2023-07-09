import 'dart:convert';

import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

class HospitalDetails extends StatefulWidget {
  final String hospitalID;

  const HospitalDetails({Key? key, required this.hospitalID}) : super(key: key);

  @override
  State<HospitalDetails> createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  var hospitalDetails;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHospitalDetails();
  }

  Future getHospitalDetails() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.https('nimaidev.azurewebsites.net',
        'api/NimaiHospitals/' + widget.hospitalID));
    hospitalDetails = jsonDecode(response.body);
    // print(doctorDetails['doctorSlots']);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
  }

  // Future getDoctors() async {
  //   var response = await http
  //       .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiDoctors'));
  //   var jsonData = jsonDecode(response.body);
  //   // print(response.body);
  //   List<doctorApi> doctors = [];
  //   for (var c in jsonData) {
  //     doctorApi doctor = doctorApi(
  //         c['id'].toString(),
  //         c['firstName'].toString(),
  //         c['lastName'].toString(),
  //         c['briefDetails'].toString(),
  //         c['practicingFrom'].toString());
  //     doctors.add(doctor);
  //   }
  //
  //   return doctors;
  // }

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
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                              image: AssetImage('assets/icons/hospital.png'),
                              width: MediaQuery.of(context).size.width / 2.5),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hospitalDetails['hospital'] +
                                              ' Hospital',
                                          style: TextStyle(
                                              color: ApkColor.Purple,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text(
                                  //   'Diabetics Speciality',
                                  //   style: TextStyle(
                                  //       fontSize: 12,
                                  //       color: ApkColor.transparentBlack2),
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/location.svg',
                                        width: 24,
                                      ),
                                      Text(
                                        hospitalDetails['address'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ApkColor.transparentBlack2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                      child: Text(
                        'Available Doctors',
                        style: TextStyle(
                            color: ApkColor.lightPurple,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          padding: EdgeInsets.fromLTRB(15, 20, 10, 20),
                          width: double.infinity,

                          // height: MediaQuery.of(context).size.height / 8,
                          decoration: BoxDecoration(
                            color: ApkColor.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      hospitalDetails['doctorHospitals'].length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DoctorDetails(
                                                            doctorID: hospitalDetails['doctorHospitals'][index]['id'].toString())));
                                          },
                                          child: Row(
                                            children: [
                                              if (hospitalDetails['doctorHospitals'][index]['id'] % 2 != 0) ...[
                                                Image(
                                                  image: AssetImage(
                                                      'assets/icons/maleDoctor.png'),
                                                  width: MediaQuery.of(context).size.width /6,
                                                ),
                                              ] else ...[
                                                Image(
                                                  image: AssetImage('assets/icons/femaleDoctor.png'),
                                                  width: MediaQuery.of(context).size.width / 6,
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
                                                        hospitalDetails['doctorHospitals'][index]['firstName'] + ' ' +
                                                            hospitalDetails['doctorHospitals'][index]['lastName'],
                                                        style: TextStyle(
                                                            color: ApkColor
                                                                .darkPurple,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        hospitalDetails['doctorHospitals'][index]['briefDetails'],
                                                        style: TextStyle(
                                                            color: ApkColor.transparentBlack2,
                                                            fontSize: 12
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Practicing From : ' +
                                                            DateFormat.yMMMMd().format(
                                                                DateTime.parse(
                                                                    hospitalDetails['doctorHospitals'][index]['practicingFrom'])),
                                                        style: TextStyle(
                                                            color: ApkColor.transparentBlack,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    );
                                  }))),
                    )
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
