
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Maintenance extends StatefulWidget {
  const Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ApkColor.white,
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(
                    image: AssetImage('assets/images/maintain.jpg'),
                    width: 250),
              ),
              Text('App is under Technical Maintenance',
                style: TextStyle(
                  color: ApkColor.transparentBlack,
                  fontSize: 18
                ),
              ),
              TextButton(
                  onPressed: () async {
                    const url = 'https://play.google.com/store/apps/details?id=com.app.rxone.nimai';
                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
                    throw 'Could not launch $url';
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(22, 10, 22, 10),
                    decoration: BoxDecoration(
                      color: ApkColor.Purple,
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: Text('Go to Nimai Care',
                      style: TextStyle(
                          color: ApkColor.white,
                          fontSize: 18
                      ),
                    ),
                  )
              )

            ],
          ),
        ),
      ),
    );
  }
}
