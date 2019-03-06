import 'package:flutter/material.dart';

import './NotesClass.dart';
import './notes.dart';

class RecentlyUpdated extends StatefulWidget {
  NotesClass startingNote;

  RecentlyUpdated({this.startingNote});

  @override
  State<StatefulWidget> createState() {
    return _RecentlyUpdatedState();
  }
}

class _RecentlyUpdatedState extends State<RecentlyUpdated> {
  List<NotesClass> _notes = [
    new NotesClass(
        1, "MeetNotes Scrum", true, "04-03-2019", "meeting_uuid", "event_uuid"),
    new NotesClass(
        1, "MeetNotes Scrum", true, "04-03-2019", "meeting_uuid", "event_uuid"),
    new NotesClass(
        1, "MeetNotes Scrum", true, "04-03-2019", "meeting_uuid", "event_uuid"),
    new NotesClass(
        1, "MeetNotes Scrum", true, "04-03-2019", "meeting_uuid", "event_uuid"),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Notes(_notes),
        )
      ],
    );
  }
}
