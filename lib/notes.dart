import 'package:flutter/material.dart';

import './NotesClass.dart';
import './Detail.dart';

class Notes extends StatelessWidget {
  final List<NotesClass> notes;

  Notes([this.notes = const []]);

  Widget _buildNoteItem(BuildContext context, int index) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white70,
            border: new Border.all(color: Colors.blue, width: 1.0),
            borderRadius: new BorderRadius.circular(5.0),
          ),
          margin: new EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Detail(notes[index].meetingUuid,
              notes[index].meetingTitle,
              notes[index].eventUuid)
            ));
          },
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(notes[index].meetingTitle, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
            Text(notes[index].updatedAt, style: TextStyle(color: Colors.black),)
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget noteCard = Center(child: Text('No available notes'));
    if (notes.length > 0) {
      noteCard = ListView.builder(
        itemBuilder: _buildNoteItem,
        itemCount: notes.length,
      );
    }

    return noteCard;
  }
}
