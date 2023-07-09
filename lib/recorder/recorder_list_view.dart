import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dr_nimai/res/color.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  final Function onDelete;
  const RecordListView(
      {Key? key, required this.records, required this.onDelete})
      : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return widget.records.isEmpty
        ? Center(child: Text('No Recordings Available'))
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
                itemCount: widget.records.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (BuildContext context, int i) {
                  return ExpansionTile(
                    title: Text('Prescription' +
                        ' ${widget.records.length - i}'),
                    backgroundColor: ApkColor.white,
                    textColor: ApkColor.Purple,
                    iconColor: ApkColor.Purple,
                    shape: ContinuousRectangleBorder(),
                    subtitle: Text(_getDateFromFilePatah(
                        filePath: widget.records.elementAt(i))),
                    onExpansionChanged: ((newState) {
                      if (newState) {
                        setState(() {
                          _selectedIndex = i;
                        });
                      }
                    }),
                    children: [
                      Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              minHeight: 5,
                              backgroundColor: ApkColor.appBackground,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(ApkColor.darkPurple),
                              value: _selectedIndex == i ? _completedPercentage : 0,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: _selectedIndex == i
                                      ? _isPlaying
                                          ? Icon(Icons.pause)
                                          : Icon(Icons.play_arrow)
                                      : Icon(Icons.play_arrow),
                                  onPressed: () => _onPlay(
                                      filePath: widget.records.elementAt(i),
                                      index: i),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      File file = File(widget.records[i]);
                                      await file.delete().then((value) {
                                        _selectedIndex = -1;
                                        widget.onDelete();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        );
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(DeviceFileSource((filePath)));
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String _getDateFromFilePatah({required String filePath}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$year-$month-$day');
  }
}
