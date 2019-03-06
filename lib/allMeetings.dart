import 'package:flutter/material.dart';

import './meetingClass.dart';
import './meetings.dart';

class AllMeetings extends StatefulWidget {
  MeetingClass startingMeeting;

  AllMeetings({this.startingMeeting});

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
  List<MeetingClass> _meetings = [
    new MeetingClass(
        "uuid", "Meeting 1", "2019-03-04", "endTime", "eventUuid", true, true),
    new MeetingClass(
        "uuid", "Meeting 2", "2019-03-05", "endTime", "eventUuid", true, true),
    new MeetingClass(
        "uuid", "Meeting 3", "2019-03-04", "endTime", "eventUuid", true, true)
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Meetings(_meetings),
        )
      ],
    );
  }
}
