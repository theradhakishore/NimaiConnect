import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:dr_nimai/dash/home.dart';
import 'package:dr_nimai/dash/medications.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadMedications extends StatefulWidget {
  final String appointmentID;
  final String doctorID;

  const UploadMedications(
      {Key? key, required this.appointmentID, required this.doctorID})
      : super(key: key);

  @override
  State<UploadMedications> createState() => _UploadMedicationsState();
}

class _UploadMedicationsState extends State<UploadMedications> {
  final List<String> medicationPrecautionsItems = [
    'Before Food',
    'After Food',
  ];

  final List<String> medicineUnitItems = ['Capsule','Tablet', 'ML'];
  final List<String> numberOfDoses = ['1', '2', '3', '4', '5'];

  List<String> DoseTimings = [];

  bool loading = false;
  bool visibility = false;

  TextEditingController medicineName = TextEditingController();
  TextEditingController medicineDoseAmount = TextEditingController();
  String selectedMedicationDoseUnit="";

  // String? selectedMedicineType;
  String selectedMedicineFoodRestrictions="";
  int? selectedNumberOfDoses;

  Color hintMedicineNameColor = ApkColor.transparentBlack;
  Color hintMedicineDoseAmount = ApkColor.transparentBlack;
  Color hintMedicationDoseUnit = ApkColor.transparentBlack;
  Color hintNumberOfDoses = ApkColor.transparentBlack;
  Color hintMedicineFoodRestrictions = ApkColor.transparentBlack;

  String selectedTime='';


  bool checkInput() {
    bool result = true;

    if (medicineName.text == "") {
      setState(() {
        hintMedicineNameColor = Colors.red;
      });
      result = false;
    }
    if (medicineDoseAmount.text == "") {
      setState(() {
        hintMedicineDoseAmount = Colors.red;
      });
      result = false;
    }
    if (selectedMedicationDoseUnit == "") {
      setState(() {
        hintMedicationDoseUnit = Colors.red;
      });
      result = false;
    }
    if (selectedNumberOfDoses == "") {
      setState(() {
        hintNumberOfDoses = Colors.red;
      });
      result = false;
    }
    if (selectedMedicineFoodRestrictions == "") {
      setState(() {
        hintMedicineFoodRestrictions = Colors.red;
      });
      result = false;
    }
    for (int i=0;i<selectedNumberOfDoses!;i++){
      if(DoseTimings[i]==' '){
        result=false;
      }
    }

    return result;
  }

  uploadMedications() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID=prefs.getInt('userID')!;

    int length=DoseTimings.toString().length;
    var response = await http.post(
      Uri.parse("https://nimaidev.azurewebsites.net/api/NimaiMedications"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": "${widget.appointmentID}|${widget.doctorID}|${userID.toString()}",
        "medicineName": medicineName.text.toString(),
        "appointmentId": "${widget.appointmentID}",
        "doctorId": "${widget.doctorID}",
        "paitentId": "${userID.toString()}",
        "medicineImage": "",
        "medicineType": "",
        "medicineDoseAmount": medicineDoseAmount.text.toString(),
        "medicationDoseUnit": selectedMedicationDoseUnit.toString(),
        "numberOfDoses": selectedNumberOfDoses.toString(),
        "dosesDetails": DoseTimings.toString().substring(1, length - 1),
        "medicineFoodRestrictions": selectedMedicineFoodRestrictions.toString(),
        "medicationNotes":"",
      }),
    );
    print(widget.appointmentID);
    print(widget.doctorID);

    if (response.statusCode == 201) {
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Medications()),
          (Route<dynamic> route) => false);

      CoolAlert.show(
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        context: context,
        type: CoolAlertType.success,
        text: 'Medication Added Successfully Check Medications in your Profile',
        loopAnimation: false,
      );
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid Input'),
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

  onPressSave() {
    if (checkInput()) {
      setState(() {
        loading = true;
      });
      uploadMedications();
    } else {
      CoolAlert.show(
        context: context,
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        type: CoolAlertType.error,
        title: 'Sorry',
        text: 'Please fill All the Details',
        loopAnimation: false,
      );
    }
  }

  Future<void> displayTimeDialog(int index) async {

    final TimeOfDay? time =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      setState(() {
        selectedTime = time.format(context);
        DoseTimings[index]= 'Dose${index+1}: '+selectedTime;
      });
    }
    print(DoseTimings);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(22, 30, 22, 20),
                  child: Row(
                    children: [
                      Text(
                        'Your ',
                        style: TextStyle(
                            color: ApkColor.Purple,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Medications',
                        style: TextStyle(
                            color: ApkColor.lightPurple,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(22, 0, 22, 22),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medicine Details',
                            style: TextStyle(
                                color: ApkColor.Purple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ApkColor.white),
                            child: TextFormField(
                              controller: medicineName,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Medicine Name',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApkColor.transparentBlack)),
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ApkColor.white),
                            child: TextFormField(
                              controller: medicineDoseAmount,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Medicine Dose Amount',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 0),
                                  hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: ApkColor.transparentBlack)),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: SizedBox(
                              height: 50,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  //Add isDense true and zero Padding.
                                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  // border: InputBorder.none,
                                  filled: true,
                                  fillColor: ApkColor.white,

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  //Add more decoration as you want here
                                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  'Medicine Unit',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ApkColor.transparentBlack),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                                buttonHeight: 60,
                                buttonPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                items: medicineUnitItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select Medicine Unit.';
                                  }
                                },
                                onChanged: (value) {
                                  selectedMedicationDoseUnit = value.toString();
                                  //Do something when changing the item if you want.
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: SizedBox(
                              height: 50,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  //Add isDense true and zero Padding.
                                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  // border: InputBorder.none,
                                  filled: true,
                                  fillColor: ApkColor.white,

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  //Add more decoration as you want here
                                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  'Number of Doses',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ApkColor.transparentBlack),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                                buttonHeight: 60,
                                buttonPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                items: numberOfDoses
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select Doses.';
                                  }
                                },
                                onChanged: (value) {
                                  selectedNumberOfDoses =
                                      int.parse(value.toString());
                                  setState(() {
                                    DoseTimings=[];
                                    for(int i=0;i<selectedNumberOfDoses!;i++){
                                      DoseTimings.add(' ');
                                    }
                                    visibility = true;
                                  });
                                },
                                onSaved: (value) {
                                  // doseselectedValue = value.toString();
                                  // print(doseselectedValue);
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: visibility,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(22, 20, 22, 20),
                              child: ListView.builder(

                                shrinkWrap: true,
                                itemCount: selectedNumberOfDoses,
                                itemBuilder: (BuildContext context, int index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:70,
                                          child: Text('Dose ${index+1}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: ApkColor.Purple),)),
                                      Text(
                                        DoseTimings[index] != ' '
                                            ? '${DoseTimings[index].substring(7)}'
                                            : '',
                                        style: const TextStyle(fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: ApkColor.Purple,
                                            padding: const EdgeInsets.all(7),
                                            textStyle: const TextStyle(fontSize: 20),
                                          ),
                                          child: const Text('Select Time',style: TextStyle(fontSize: 12),),
                                          onPressed: (){
                                            displayTimeDialog(index);
                                            print(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: SizedBox(
                              height: 50,
                              child: DropdownButtonFormField2(
                                decoration: InputDecoration(
                                  //Add isDense true and zero Padding.
                                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  // border: InputBorder.none,
                                  filled: true,
                                  fillColor: ApkColor.white,

                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  //Add more decoration as you want here
                                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                ),
                                isExpanded: true,
                                hint: const Text(
                                  'Food Precautions',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: ApkColor.transparentBlack),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                                buttonHeight: 60,
                                buttonPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                items: medicationPrecautionsItems
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select Food Precaution.';
                                  }
                                },
                                onChanged: (value) {
                                  selectedMedicineFoodRestrictions =
                                      value.toString();
                                  //Do something when changing the item if you want.
                                },
                                onSaved: (value) {},
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              onPressSave();
                            },
                            child: Container(
                                alignment: FractionalOffset.bottomCenter,
                                margin: EdgeInsets.fromLTRB(12, 40, 12, 20),
                                padding: EdgeInsets.fromLTRB(30, 11, 30, 11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ApkColor.Purple,
                                ),
                                child: Text(
                                  'Save Medications',
                                  style: TextStyle(
                                      color: ApkColor.white, fontSize: 14),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            Center(
                child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              padding: EdgeInsets.all(40),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  color: ApkColor.transparentBlack3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,

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
                        'Uploading',
                        style: TextStyle(color: ApkColor.white, fontSize: 14),
                      ))
                ],
              ),
            )),
        ],
      )),
    );
  }
}
