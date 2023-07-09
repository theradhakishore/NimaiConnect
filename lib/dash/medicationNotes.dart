
import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:dr_nimai/dash/medications.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MedicationNotes extends StatefulWidget {
  final String id;
  const MedicationNotes({Key? key,required this.id}) : super(key: key);

  @override
  State<MedicationNotes> createState() => _MedicationNotesState();
}

class _MedicationNotesState extends State<MedicationNotes> {

  TextEditingController medicationNotes=TextEditingController();

  Future saveNotes() async {

    var response = await http.put(
      Uri.https('nimaidev.azurewebsites.net',
          'api/NimaiMedications/${widget.id}'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'id': widget.id,
        'Notes': medicationNotes.text.toString(),
      }),
    );
    print(response.body);
    print(Uri.https('nimaidev.azurewebsites.net',
        'api/NimaiMedications/${widget.id}'));

    if (response.statusCode == 204) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Medications()));
      CoolAlert.show(
        context: context,
        backgroundColor: ApkColor.black,
        confirmBtnColor: ApkColor.black,
        type: CoolAlertType.success,
        title: 'Success',
        text: 'Medication Notes Added',
        loopAnimation: false,
      );
    }
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
          height: MediaQuery.of(context).size.height,
          color: ApkColor.appBackground,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(22, 0, 22, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Medication',
                            style: TextStyle(
                                color: ApkColor.Purple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            ' Notes',
                            style: TextStyle(
                                color: ApkColor.lightPurple,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(22, 10, 22, 30),
                  padding: EdgeInsets.fromLTRB(22,22, 22,22),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ApkColor.white),
                  child: TextFormField(
                    controller: medicationNotes,
                    enabled: true,
                    maxLines: 20,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        hintStyle: TextStyle(
                            fontSize: 12,
                            color: ApkColor.transparentBlack)),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ApkColor.darkPurple,
                    foregroundColor: ApkColor.white,
                    elevation: 3,
                    padding:
                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(100),
                    ),
                  ),
                  onPressed: () async {
                    saveNotes();
                  },
                  child: Text(
                    'Save Notes',
                    style: TextStyle(
                        color: ApkColor.white, fontSize: 16),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
