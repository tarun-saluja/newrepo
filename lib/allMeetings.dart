import 'package:flutter/material.dart';

import './meetingClass.dart';
import './meetings.dart';

class AllMeetings extends StatefulWidget {
  List<MeetingClass> meetings;

  AllMeetings([this.meetings]);

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
  List<MeetingClass> _meetings;

  @override
  void initState() {
    if(widget.meetings != null){
      _meetings = widget.meetings;
    }
    super.initState();
  }

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
