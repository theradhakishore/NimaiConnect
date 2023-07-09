import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dr_nimai/dash/allDoctors.dart';
import 'package:dr_nimai/dash/allHospitals.dart';
import 'package:dr_nimai/dash/allSpecializations.dart';
import 'package:dr_nimai/dash/doctorDetails.dart';
import 'package:dr_nimai/dash/hospitalDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/color.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //to fetch all the doctors from the database
  bool isbuild = false;
  bool loading = true;
  String userName = '';
  bool checkOnce = false;

  // Future fetchDoctorList;
  late Future specializationsList;
  late Future doctorsList;
  late Future hospitalsList;

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

  Future getSpecializations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('SpecializationData');
    if (jsonString != null) {
      Map<String, dynamic> SpecializationData = json.decode(jsonString);
      int timestamp = SpecializationData['timestamp'];
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      int validityPeriod = 3600000; // 1 hour in milliseconds
      bool isDataValid = (currentTime - timestamp) <= validityPeriod;

      if (!isDataValid) {
        var response = await http.get(Uri.https(
            'nimaidev.azurewebsites.net', 'api/NimaiSpecializations'));
        var jsonData = jsonDecode(response.body);

        Map<String, dynamic> SpecializationData = {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': jsonData,
        };
        String jsonString = json.encode(SpecializationData);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('SpecializationData', jsonString);
      }
      List<specializationApi> specializations = [];
      for (var c in SpecializationData['data']) {
        specializationApi specialization = specializationApi(
            c['id'].toString(),
            c['specialization'].toString(),
            c['details'].toString(),
            c['icon'].toString(),
            c['doctorSpecializations'].toString());
        specializations.add(specialization);
      }
      return specializations;
    } else {
      var response = await http.get(
          Uri.https('nimaidev.azurewebsites.net', 'api/NimaiSpecializations'));
      var jsonData = jsonDecode(response.body);

      Map<String, dynamic> SpecializationData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': jsonData,
      };
      String jsonString = json.encode(SpecializationData);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('SpecializationData', jsonString);
      List<specializationApi> specializations = [];
      for (var c in SpecializationData['data']) {
        specializationApi specialization = specializationApi(
            c['id'].toString(),
            c['specialization'].toString(),
            c['details'].toString(),
            c['icon'].toString(),
            c['doctorSpecializations'].toString());
        specializations.add(specialization);
      }
      return specializations;
    }
  }

  Future getHospitals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('HospitalData');

    if (jsonString != null) {
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
          'timestamp': DateTime.now().millisecondsSinceEpoch,
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
    } else {
      var response = await http
          .get(Uri.https('nimaidev.azurewebsites.net', 'api/NimaiHospitals'));
      var jsonData = jsonDecode(response.body);

      Map<String, dynamic> HospitalData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
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

  setuserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName')!;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    specializationsList = getSpecializations();
    doctorsList = getDoctors();
    hospitalsList = getHospitals();
    setuserName();
    super.initState();
  }

  List<String> imageAddress = [
    'assets/images/0.png',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png'
  ];

  @override
  Widget build(BuildContext context) {
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
                          colors: const [ApkColor.lightPurple, ApkColor.Purple],

                          /// Optional, The color collections
                          strokeWidth: 4,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: ApkColor.appBackground,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(22, 15, 22, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                  image: AssetImage('assets/icons/logo.png'),
                                  width: 100),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).greeting,
                                          style: TextStyle(
                                              color: ApkColor.Purple,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          userName,
                                          style: TextStyle(
                                              color: ApkColor.lightPurple,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Text(
                                      AppLocalizations.of(context).subGreeting,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ApkColor.transparentBlack2),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CarouselSlider(
                                  options: CarouselOptions(
                                    aspectRatio: 2,
                                    viewportFraction: 0.9,
                                    initialPage: 0,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: imageAddress.map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Image(
                                                image: AssetImage(i)));
                                      },
                                    );
                                  }).toList(),
                                ),
                                Container(
                                    margin: EdgeInsets.fromLTRB(16, 20, 16, 20),
                                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    width: double.infinity,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: ApkColor.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context).specializations,
                                          style: TextStyle(
                                              color: ApkColor.Purple,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        FutureBuilder(
                                          future: specializationsList,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) {
                                              return Padding(
                                                padding: EdgeInsets.all(30),
                                                child: Center(
                                                    child: SizedBox(height: 30,
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
                                                  // margin: EdgeInsets.fromLTRB(
                                                  //     0, 16, 0, 16),
                                                  child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: snapshot.data.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      return TextButton(
                                                        onPressed: () {
                                                          Navigator.push(context, MaterialPageRoute(
                                                                  builder: (context) => AllSpecializations(
                                                                      specializationID: snapshot.data[index].id
                                                                  )
                                                             )
                                                          );
                                                        },

                                                        child: Container(
                                                          // height: 150,
                                                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              if (snapshot.data[index].specialization == 'Pathology') ...[
                                                                Container(
                                                                  padding: EdgeInsets.all(22),
                                                                  decoration: BoxDecoration(
                                                                      color: ApkColor.Purple,
                                                                      borderRadius: BorderRadius.circular(10)),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                    'assets/icons/pathology.svg',
                                                                  ),
                                                                ),
                                                              ] else if (snapshot
                                                                      .data[
                                                                          index]
                                                                      .specialization ==
                                                                  'Dental') ...[
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                          22),
                                                                  decoration: BoxDecoration(
                                                                      color: ApkColor
                                                                          .Purple,
                                                                      borderRadius:
                                                                          BorderRadius.circular(10)),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                    'assets/icons/dental.svg',
                                                                  ),
                                                                ),
                                                              ] else if (snapshot
                                                                      .data[
                                                                          index]
                                                                      .specialization ==
                                                                  'Cardiologist') ...[
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets.all(
                                                                          22),
                                                                  decoration: BoxDecoration(
                                                                      color: ApkColor.Purple,
                                                                      borderRadius: BorderRadius.circular(10)),
                                                                  child: SvgPicture.asset('assets/icons/cardio.svg',
                                                                  ),
                                                                ),
                                                              ],
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                        child:
                                                                            Text(
                                                                          snapshot.data[index].specialization,
                                                                          style: TextStyle(
                                                                              color: ApkColor.transparentBlack3,
                                                                              fontSize: 12,
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
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: ApkColor.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context).availableDoctors,
                                              style: TextStyle(
                                                  color: ApkColor.Purple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AllDoctors()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 5, 15, 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    color: ApkColor.lightPurple,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .seeall,
                                                    style: TextStyle(
                                                        color: ApkColor.white,
                                                        fontSize: 12),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        FutureBuilder(
                                          future: doctorsList,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.data == null) {
                                              return Padding(
                                                padding: EdgeInsets.all(30),
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
                                                  // margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder: (context, i) {
                                                      return TextButton(
                                                        onPressed: () {
                                                          // courseID: snapshot.data[i].id
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => DoctorDetails(
                                                                      doctorID: snapshot
                                                                          .data[
                                                                              i]
                                                                          .id)));
                                                        },
                                                        child: Container(
                                                          // height: MediaQuery.of(context).size.height,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 10, 0),
                                                          child: Column(
                                                            children: [
                                                              if (int.parse(snapshot
                                                                          .data[
                                                                              i]
                                                                          .id) %
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
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          'Dr.' +
                                                                              snapshot.data[i].firstName,
                                                                          style: TextStyle(
                                                                              color: ApkColor.transparentBlack3,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                                    Text(
                                                                      snapshot
                                                                          .data[
                                                                              i]
                                                                          .lastName,
                                                                      style: TextStyle(
                                                                          color: ApkColor
                                                                              .transparentBlack3,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
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
                                    )),
                                Container(
                                    margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
                                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    width: double.infinity,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: ApkColor.white,
                                      borderRadius: BorderRadius.circular(15),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Color(0xffDDDDDD),
                                      //     blurRadius: 20.0, // soften the shadow
                                      //     spreadRadius: 1.0, //extend the shadow
                                      //   )
                                      // ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .availableHospitals,
                                              style: TextStyle(
                                                  color: ApkColor.Purple,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => AllHospitals()));
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 5, 15, 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: ApkColor.lightPurple,
                                                  ),
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .seeall,
                                                    style: TextStyle(
                                                        color: ApkColor.white,
                                                        fontSize: 12),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        FutureBuilder(
                                          future: hospitalsList,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.data == null) {
                                              return Padding(
                                                padding: EdgeInsets.all(30),
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
                                                  // margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return TextButton(
                                                        onPressed: () {
                                                          // courseID: snapshot.data[i].id
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => HospitalDetails(
                                                                      hospitalID: snapshot
                                                                          .data[
                                                                              index]
                                                                          .id)));
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              10,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 10, 0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Image(
                                                                  image: AssetImage(
                                                                      'assets/icons/hospital.png')),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .hospital,
                                                                          style: TextStyle(
                                                                              color: ApkColor.transparentBlack3,
                                                                              fontSize: 12,
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
                                    )),
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

class doctorApi {
  final String id, firstName, lastName, briefDetails, practicingFrom;

  doctorApi(this.id, this.firstName, this.lastName, this.briefDetails,
      this.practicingFrom);
}

class specializationApi {
  final String id, specialization, details, icon, doctorSpecializations;

  specializationApi(this.id, this.specialization, this.details, this.icon,
      this.doctorSpecializations);
}

class hospitalApi {
  final String id, hospital, details, address, doctorHospitals;

  hospitalApi(
      this.id, this.hospital, this.details, this.address, this.doctorHospitals);
}
