import 'dart:io';
import 'package:dr_nimai/recorder/recorder_list_view.dart';
import 'package:dr_nimai/recorder/recorder_view.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class RecorderHomeView extends StatefulWidget {
  final String _title;

  const RecorderHomeView({Key? key, required String title})
      : _title = title,
        super(key: key);

  @override
  _RecorderHomeViewState createState() => _RecorderHomeViewState();
}

class _RecorderHomeViewState extends State<RecorderHomeView> {
  late Directory appDirectory;
  List<String> records = [];

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        backgroundColor: ApkColor.Purple,
        elevation: 0,
        iconTheme: IconThemeData(
          color: ApkColor.white, // <-- SEE HERE
        ),
      ),
      body: Container(
        color: ApkColor.appBackground,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: RecordListView(
                records: records,
                onDelete: _fetchData,
              ),
            ),
            Expanded(
              flex: 1,
              child: RecorderView(
                onSaved: _fetchData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _fetchData() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      setState(() {});
    });
  }
}
