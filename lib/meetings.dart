import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import 'package:memob/updatedAtFormatter.dart' as UpdateAtFormatter;

import './meetingClass.dart';
import './Detail.dart';

class Meetings extends StatelessWidget {
  final List<MeetingClass> meetings;

  Meetings([this.meetings = const []]);

  Widget _buildMeetingItem(BuildContext context, int index) {
    var today = DateFormat.yMd().format(new DateTime.now());
    var meetingDay =
        DateFormat.yMd().format(DateTime.parse(meetings[index].startTime));
    var isToday = today.compareTo(meetingDay);

    var isUpcoming =
        DateTimeFormatter.isUpcomingMeeting(meetings[index].startTime);
    return Container(
      // decoration: new BoxDecoration(
      //   color: Colors.white70,
      //   border: new Border.all(color: Colors.blue, width: 1.0),
      //   borderRadius: new BorderRadius.circular(5.0),
      // ),
      margin: new EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(meetings[index].uuid,
                    meetings[index].title, meetings[index].eventUuid),
              ));
        },
        child: Card(
          elevation: 100.0,
          color: Colors.white,
          child: Container(
            margin: EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                    decoration: new BoxDecoration(
                        color: (isToday == 0 || isUpcoming == true)
                            ? (isUpcoming == true ? Colors.blue : Colors.green)
                            : Colors.grey[400],
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: (isToday == 0 || isUpcoming == true)
                        ? (isUpcoming == true
                            ? Text(
                                'Upcoming',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              )
                            : Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.white),
                              ))
                        : Text(
                            '${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white),)),
                Text(
                  meetings[index].title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  '${DateTimeFormatter.getTime(meetings[index].startTime)}',
                  style: TextStyle(fontSize: 12.0, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    Widget meetingCard = Center(
      child: CircularProgressIndicator(),
    );
    if (meetings.length > 0) {
       meetingCard = GridView.builder(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5),
        itemBuilder: _buildMeetingItem,
        itemCount: meetings.length,
      );
    }
    return meetingCard;
  }
}
