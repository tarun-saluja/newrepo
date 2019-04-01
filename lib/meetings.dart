import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './Detail.dart';

class Meetings extends StatelessWidget {
  List<MeetingClass> meetings;
  List<MeetingClass> displaymeetings = new List<MeetingClass>();

  Meetings([this.meetings]);

  Widget build(BuildContext context) {
    @override
    Widget meetingCard = Center(
      child: CircularProgressIndicator(),
    );
    for (int i = 0; i < meetings.length; i++) {
      if ((DateTimeFormatter.isUpcomingMeeting(meetings[i].startTime)) ==
          false) {
        displaymeetings.add(meetings[i]);
      }
    }
    meetingCard = GridView.builder(
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.6),
      itemBuilder: _buildMeetingItem,
      itemCount: displaymeetings.length,
    );
    return meetingCard;
  }

  Widget _buildMeetingItem(BuildContext context, int index) {
    var today = DateFormat.yMd().format(new DateTime.now());
    var display = displaymeetings[index];
    var meetingDay = DateFormat.yMd().format(DateTime.parse(display.startTime));
    var isToday = today.compareTo(meetingDay);

    var isUpcoming = DateTimeFormatter.isUpcomingMeeting(display.startTime);
    return Container(
        margin: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Detail(display.uuid, display.title, display.eventUuid),
                ));
          },
          child: Card(
            elevation: 100.0,
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      decoration: new BoxDecoration(
                          color: (isToday == 0)
                              ? (isUpcoming == true ? Colors.blue : Colors.blue)
                              : Colors.grey[400],
                          border: Border.all(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: (isUpcoming == false)
                          ? ((isToday == 0)
                              ? isUpcoming == true
                                  ? Text(
                                      'Upcoming',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    )
                                  : Text(
                                      'Today',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    )
                              : Text(
                                  '${DateTimeFormatter.getDate(display.startTime)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ),
                                ))
                          : null),
                  Text(
                    display.title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                  Text(
                    '${DateTimeFormatter.getTime(display.startTime)}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
