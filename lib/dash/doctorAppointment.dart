import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:dr_nimai/dash/appointments.dart';
import 'package:dr_nimai/dash/home.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DoctorAppointment extends StatefulWidget {
  final String doctorID;

  const DoctorAppointment({Key? key, required this.doctorID}) : super(key: key);

  @override
  State<DoctorAppointment> createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  bool isBuildSetState = true;

  DateTime _focusedDay = DateTime.now();
  DateTime _firstDay = DateTime.now();

  var selectedTime;

  var selectedDate;

  var slots;
  var time = DateTime.parse("2023-02-01T23:00:00");

  List timingSlots = [];
  List<bool> timingSlotSelect = [];

  var doctorDetails;
  var doctorName;
  var doctorEmail;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDoctorDetails();
    setSlots();
    // print(DateFormat.jm().format(time));
  }

  bool checkInput(BuildContext context) {
    bool result = true;

    if (selectedDate == null && selectedTime == null) {
      CoolAlert.show(
        context: context,
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        type: CoolAlertType.error,
        title: 'Sorry',
        text: 'Please Select Appointment Date',
        loopAnimation: false,
      );
      result = false;
    }
    if (selectedDate == null && selectedTime != null) {
      CoolAlert.show(
        context: context,
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        type: CoolAlertType.error,
        title: 'Sorry',
        text: 'Please Select Appointment Date',
        loopAnimation: false,
      );
      result = false;
    }

    if (selectedDate != null && selectedTime == null) {
      CoolAlert.show(
        context: context,
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        type: CoolAlertType.error,
        title: 'Sorry',
        text: 'Please Select Appointment Time',
        loopAnimation: false,
      );
      result = false;
    }

    return result;
  }

  void onPressConfirm(BuildContext context) {
    if (checkInput(context)) {
      createAppointment();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Appointments()),
          (Route<dynamic> route) => false);

      CoolAlert.show(
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        context: context,
        type: CoolAlertType.success,
        text:
            'Appointment created successfully     Check your Appointment tab for details',
        loopAnimation: false,
      );
    }
  }

  void setSlots() {
    timingSlotSelect.clear();

    timingSlots.forEach((element) {
      timingSlotSelect.add(false);
    });
  }

  Future getDoctorDetails() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.https(
        'nimaidev.azurewebsites.net', 'api/NimaiDoctors/' + widget.doctorID));
    doctorDetails = jsonDecode(response.body);

    slots = doctorDetails['doctorSlots'];
    doctorName =
        'Dr. ' + doctorDetails['firstName'] + ' ' + doctorDetails['lastName'];
    doctorEmail = doctorDetails['emailId'].toString().toLowerCase();
    print(slots.length);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    }
  }

  void fetchSlots(selectedDate, slots) {
    timingSlots.clear();
    var d1 =
        DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
    for (int i = 0; i < slots.length; i++) {
      var d3 = DateTime.parse(slots[i]['start']);
      var d2 = DateTime.utc(d3.year, d3.month, d3.day);
      if (d1.compareTo(d2) == 0 && slots[i]['status'] == 'free') {
        timingSlots.add(slots[i]);
      }
    }
    // print(timingSlots);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here

    setState(() {
      if (args.value is DateTime) {
        selectedDate = args.value;
        selectedDate = selectedDate.toIso8601String();
        fetchSlots(DateTime.parse(selectedDate), slots);
        setSlots();
        print(selectedDate);
      }
    });
  }

  void onSelectSlotTiming(int index) {
    timingSlotSelect.clear();
    timingSlots.forEach((element) {
      timingSlotSelect.add(false);
    });
    timingSlotSelect[index] = true;
    selectedTime = timingSlots[index];
    print(selectedTime['id']);
    setState(() {});
  }

  Future<void> createAppointment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID = prefs.getInt('userID')!;
    String userName = prefs.getString('userName')!;

    var response = await http.put(
      Uri.https('nimaidev.azurewebsites.net',
          'api/appointments/' + selectedTime['id'].toString() + '/appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': userName,
        'patientID': userID.toString(),
        'doctorID': widget.doctorID.toString()
      }),
    );
    if (response.statusCode == 204) {
      // setState(() {
      //   loading = false;
      // });
      print('Appointment Created');
    }
  }

  // void refresh(){
  //   setState(() {
  //
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    // refresh();

    // if(isBuildSetState){
    //   // getCustomerbyID();
    //   // setSlots();
    //   isBuildSetState = false;
    //   setState(() {
    //
    //   });
    //
    // }
    return (loading)
        ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [ApkColor.appBackground],
                    stops: [1.0])),
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
                      ApkColor.lightPurple,
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
              backgroundColor: ApkColor.white,
              elevation: 0,
              iconTheme: IconThemeData(
                color: ApkColor.Purple, // <-- SEE HERE
              ),
            ),
            body: SafeArea(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(color: ApkColor.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                      child: Row(
                        children: [
                          Text(
                            'Book an ',
                            style: TextStyle(
                                color: ApkColor.Purple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Appointment',
                            style: TextStyle(
                                color: ApkColor.lightPurple,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        // height: 100,
                        child: SfDateRangePicker(
                          todayHighlightColor: ApkColor.lightPurple,
                          selectionColor: ApkColor.lightPurple,
                          view: DateRangePickerView.month,
                          // monthViewSettings: DateRangePickerMonthViewSettings(numberOfWeeksInView: 2),
                          selectionMode: DateRangePickerSelectionMode.single,
                          onSelectionChanged: _onSelectionChanged,
                          // monthViewSettings: DateRangePickerMonthViewSettings(
                          //   viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          //     backgroundColor: ApkColor.persianIndigo,
                          //     textStyle: TextStyle(fontSize: 16, letterSpacing: 0)
                          //   )
                          // ),
                          // enablePastDates : false,
                          maxDate: DateTime.utc(_firstDay.year,
                              _firstDay.month + 1, _firstDay.day),
                          minDate: _firstDay,
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text(
                        'Available Timings : ',
                        style: TextStyle(color: ApkColor.Purple, fontSize: 16,fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (timingSlots.isEmpty && selectedDate!=null) ...[
                      Container(
                        width: double.infinity,
                        height: 120,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            Text("No Appointment available on this date ",style: TextStyle(color:ApkColor.transparentBlack3,fontSize: 14),),
                            TextButton(
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
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorAppointment(doctorID: widget.doctorID)));
                              },
                              child: Text(
                                'Send email',
                                // style: TextStyle(color: ApkColor.white, fontSize: 16),
                              ),
                            ),
                            Text(" to schedule an Appointment ", style: TextStyle(color: ApkColor.transparentBlack3),),
                            // Text( doctorEmail, style: TextStyle(color: ApkColor.transparentBlack3),),
                          ],
                        ),
                      ),
                    ]else if (timingSlots.isEmpty && selectedDate==null) ...[
                      Container(
                        width: double.infinity,
                        height: 100,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          children: [
                            Text("Please Select Date for Appointment ",style: TextStyle(color:ApkColor.transparentBlack3,fontSize: 14),),
                          ],
                        ),
                      ),
                    ] else
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 14,
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: timingSlots.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: timingSlotSelect[index]
                                          ? ApkColor.lightPurple
                                          : ApkColor.transparentBlack2,
                                      primary: timingSlotSelect[index]
                                          ? ApkColor.white
                                          : ApkColor.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  50)),
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                    ),
                                    onPressed: () {
                                      onSelectSlotTiming(index);
                                      // print(Online.countBookings);
                                    },
                                    child: Text(
                                      '${DateFormat.jm().format(DateTime.parse(timingSlots[index]['start']))}-${DateFormat.jm().format(DateTime.parse(timingSlots[index]['end']))}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                // Container(
                                //   alignment:Alignment.center,
                                //
                                //   padding:EdgeInsets.fromLTRB(20,5,20,5),
                                //   margin:EdgeInsets.fromLTRB(0,10,0,0),
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(50),
                                //     color:ApkColor.pink,
                                //   ),
                                //
                                //   child: Text(
                                //     '${getBookingCount(timingSlots[index])} booked',
                                //     style: TextStyle(
                                //         color: ApkColor.white
                                //     ),
                                //   ),
                                // )
                              ],
                            );
                          },
                        ),
                      ),
                    if(selectedTime!=null)...[
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: ApkColor.darkPurple,
                              foregroundColor: ApkColor.white,
                              elevation: 3,
                              padding:
                              EdgeInsets.fromLTRB(60, 10, 60, 10),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(100),
                              ),
                            ),
                            onPressed: () async {
                              onPressConfirm(context);
                              // if (checkInput()) {
                              //   sendCustomerDataToDB();
                              //   loader = true;
                              //   Dialogs.showLoadingDialog(
                              //       context, _keyLoader);
                              // }
                            },
                            child: Text(
                              'Confirm Appointment',
                              style: TextStyle(
                                  color: ApkColor.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ]

                  ],
                ),
              ),
            ),
          );
  }
}
