import 'package:flutter/material.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './meetings.dart';

import 'package:memob/meetingClass.dart';

class AllMeetings extends StatefulWidget {
  final List<MeetingClass> meetings;

  AllMeetings([this.meetings = const []]);

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
  List<MeetingClass> _meetings;
 static var initial = 0;
  static var low=0;
  @override
  void initState() {
    if (widget.meetings != null) {
      _meetings = widget.meetings;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_meetings == null || _meetings.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    for (var i = initial; i < _meetings.length; i++) {
      if (i != 0 &&
          DateTimeFormatter.getDate(_meetings[i].startTime) !=
              DateTimeFormatter.getDate(_meetings[i - 1].startTime)) {
        low=initial;
        initial = i;
        return Column(
          children: <Widget>[
            Container(
              child: Text(
                'hello',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              child: Meetings(_meetings.sublist(low, i)),
            )
          ],
        );
      }
    }
  }
}
