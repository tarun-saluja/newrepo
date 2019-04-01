import 'package:flutter/material.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './meetings.dart';

import 'package:memob/meetingClass.dart';

class AllMeetings extends StatefulWidget {
  final List<MeetingClass> meetings;
  var connectionStatus;

  AllMeetings([this.meetings = const [], this.connectionStatus]);

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
  static var position = 0;
  List<MeetingClass> _meetings;

  @override
  void initState() {
    if (widget.meetings != null) {
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
        ),
      ],
    );
  }
}
