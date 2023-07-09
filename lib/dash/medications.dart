import 'dart:convert';

import 'package:dr_nimai/dash/medicationNotes.dart';
import 'package:dr_nimai/dash/uploadOnlyMedications.dart';
import 'package:dr_nimai/dash/uploadPrescription.dart';
import 'package:dr_nimai/generated/l10n.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Medications extends StatefulWidget {
  const Medications({Key? key}) : super(key: key);

  @override
  State<Medications> createState() => _MedicationsState();
}

class _MedicationsState extends State<Medications> {
  bool notAvailable=false;
  List<medicationApi> Medications = [];

  Future getMedications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userID=prefs.getInt('userID')!;
    var response = await http.get(Uri.https(
        'nimaidev.azurewebsites.net', 'api/NimaiMedications/Patient/${userID}'));
    var jsonData = jsonDecode(response.body);
    for (var c in jsonData) {
      medicationApi medication = medicationApi(
        c['medicineName'].toString(),
        c['medicineDoseAmount'].toString(),
        c['medicationDoseUnit'].toString(),
        c['numberOfDoses'].toString(),
        c['dosesDetails'].toString().split(","),
        c['medicineFoodRestrictions'].toString(),
        c['appointmentId'].toString(),
        c['doctorId'].toString(),
        c['paitentId'].toString(),
        c['id'].toString(),
        c['medicationNotes'].toString()
      );
      Medications.add(medication);
    }
    if(Medications.isEmpty){
      setState(() {
        notAvailable=true;
      });
    }
    return Medications;
  }
  // Future<void> deleteMedication(var aid,var did, var pid)async {
  //   var response = await http.delete(
  //       Uri.parse("https://nimaidev.azurewebsites.net/api/NimaiMedications/${aid}%7C${did}%7C${pid}"),);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                          AppLocalizations.of(context).medications,
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
                                    UploadOnlyMedications())
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
                    Text('No Medications Uploaded',style: TextStyle(color: ApkColor.transparentBlack,fontSize: 16,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              FutureBuilder(
                  future: getMedications(),
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
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: double.infinity,
                          constraints: BoxConstraints.expand(),
                          child: Column(

                            children: [
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadPrescription(
                                                          appointmentID:
                                                          snapshot.data[index].appointmentId,
                                                          doctorID:
                                                          snapshot.data[index].doctorId)));
                                        },
                                        child: Container(
                                          margin:
                                          EdgeInsets.fromLTRB(12, 0, 12, 0),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: ApkColor.white,
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      if (snapshot.data[index]
                                                          .medicationDoseUnit ==
                                                          'Tablet') ...[
                                                        SvgPicture.asset(
                                                          'assets/icons/pills2.svg',
                                                          width: 28,
                                                        ),
                                                      ] else
                                                        ...[
                                                          SvgPicture.asset(
                                                            'assets/icons/syrup.svg',
                                                            width: 28,
                                                          ),
                                                        ],
                                                      Container(
                                                          margin:
                                                          EdgeInsets.fromLTRB(
                                                              10, 0, 0, 0),
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .medicineName,
                                                            style: TextStyle(
                                                                color: ApkColor
                                                                    .darkPurple,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ))
                                                    ],
                                                  ),
                                                  FilledButton.icon(
                                                      onPressed: (){
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    MedicationNotes(
                                                                        id:snapshot.data[index].id
                                                                        )
                                                            )
                                                        );
                                                      },
                                                      style:TextButton.styleFrom(
                                                        backgroundColor: ApkColor.white,
                                                        foregroundColor: ApkColor.Purple
                                                      ),
                                                      icon: SvgPicture.asset(
                                                        'assets/icons/note.svg',
                                                        width: 18,
                                                      ),
                                                      label: Text('Add Notes',style: TextStyle(
                                                        fontSize: 12
                                                      ),
                                                      ))
                                                  // IconButton(
                                                  //   padding:EdgeInsets.zero,
                                                  //   onPressed: () {
                                                  //     // print(snapshot.data[index].patientId);
                                                  //     // deleteMedication(snapshot.data[index].appointmentId,snapshot.data[index].doctorId,snapshot.data[index].paitentId);
                                                  //   },
                                                  //   icon: SvgPicture.asset(
                                                  //     'assets/icons/delete.svg',
                                                  //     // width: 24,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),

                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    snapshot.data[index].medicineDoseAmount +
                                                        ' ' + snapshot.data[index].medicationDoseUnit +
                                                        '    ' + snapshot.data[index].numberOfDoses + ' times in a Day',
                                                    style: TextStyle(
                                                        color: ApkColor.lightPurple,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                              ),
                                              ExpansionTile(
                                                title: Text('Medication Timings',style: TextStyle(fontSize: 14),),
                                                textColor: ApkColor.Purple,
                                                iconColor: ApkColor.Purple,
                                                shape: ContinuousRectangleBorder(),
                                                children: [
                                                  Column(
                                                    children: [
                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: ClampingScrollPhysics(),
                                                          itemCount: snapshot.data[index].doseDetails.length,
                                                          itemBuilder:(BuildContext context,int i){
                                                            return Container(
                                                              margin: EdgeInsets.fromLTRB(
                                                                  0, 0, 0, 5),
                                                              child: Table(
                                                                border: TableBorder.all(
                                                                    color: ApkColor.transparentBlack3,
                                                                    style: BorderStyle.solid,
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    width: 0.2),
                                                                children: [
                                                                  // Text('Morning'),
                                                                  TableRow(
                                                                      children:[
                                                                        Column(
                                                                          children: [
                                                                            Text('Dose ${i+1}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: ApkColor.Purple),),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Text(snapshot.data[index].doseDetails[i].toString().substring(7)),
                                                                          ],
                                                                        ),
                                                                        // Text('09:00 AM'),
                                                                        Column(
                                                                          children: [
                                                                            Text(snapshot.data[index].medicineFoodRestrictions),
                                                                          ],
                                                                        )
                                                                      ]
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                      ),
                                                    ],
                                                  ),
                                                  if(snapshot.data[index].medicationNotes!=null)...[
                                                    ExpansionTile(
                                                      title: Text('Medication Notes',style: TextStyle(fontSize: 14),),
                                                      textColor: ApkColor.Purple,
                                                      iconColor: ApkColor.Purple,
                                                      shape: ContinuousRectangleBorder(),
                                                      children: [
                                                        Container(
                                                            child: Text(snapshot.data[index].medicationNotes,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: ApkColor.black
                                                              ),
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  ]
                                                ],
                                              ),


                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class medicationApi {
  final String medicineName, medicineDoseAmount, medicationDoseUnit, numberOfDoses, medicineFoodRestrictions,appointmentId,doctorId,paitentId,id,medicationNotes;
  List<String> doseDetails;

  medicationApi(this.medicineName,
      this.medicineDoseAmount, this.medicationDoseUnit, this.numberOfDoses, this.doseDetails, this.medicineFoodRestrictions, this.appointmentId,this.doctorId,this.paitentId,this.id,this.medicationNotes);
}
