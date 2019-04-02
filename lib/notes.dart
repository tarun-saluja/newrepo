import 'package:flutter/material.dart';

import './Detail.dart';
import './NotesClass.dart';
import './constants.dart';

class Notes extends StatelessWidget {
  final List<NotesClass> notes;

  Notes([this.notes = const []]);

  @override
  Widget build(BuildContext context) {
    Widget noteCard = Center(child: CircularProgressIndicator());
    if (notes.length > 0) {
      noteCard = ListView.builder(
        itemBuilder: _buildNoteItem,
        itemCount: notes.length,
      );
    }

    return noteCard;
  }

  Widget _buildNoteItem(BuildContext context, int index) {
    var updatedAt;
    Duration diff =
        DateTime.now().difference(DateTime.parse(notes[index].updatedAt));
    if (diff.inDays > 365)
      updatedAt =
          "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    else if (diff.inDays > 30)
      updatedAt =
          "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    else if (diff.inDays > 7)
      updatedAt =
          "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    else if (diff.inDays > 0)
      updatedAt = "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    else if (diff.inHours > 0)
      updatedAt = "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    else if (diff.inMinutes > 0)
      updatedAt =
          "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    else
      updatedAt = "$JUST_NOW";

    var open = notes[index].actionItems;
    return Container(
        height: 80,
        margin: new EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Detail(notes[index].meetingUuid,
                        notes[index].meetingTitle, notes[index].eventUuid)));
          },
          child: Card(
            elevation: 100.0,
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          notes[index].meetingTitle,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Last Modified $updatedAt',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            (open != 0)
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[200]),
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 2.0, 10.0, 2.0),
                                    child: Text(
                                      '$open Open',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12),
                                    ),
                                  )
                                : Text(''),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'arrow.png',
                              height: 15,
                              width: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
