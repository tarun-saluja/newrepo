import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './Detail.dart';

class Meetings extends StatelessWidget {
  List<MeetingClass> meetings;
  List<MeetingClass> displaymeeting = new List<MeetingClass>();

  Meetings([this.meetings]);

  Widget _buildMeetingItem(BuildContext context, int index) {
    var today = DateFormat.yMd().format(new DateTime.now());
    var meetingDay =
        DateFormat.yMd().format(DateTime.parse(displaymeeting[index].startTime));
    var isToday = today.compareTo(meetingDay);

    var isUpcoming =
        DateTimeFormatter.isUpcomingMeeting(displaymeeting[index].startTime);
//    if(isUpcoming==false) {
//      displaymeeting.add(meetings[index]);
//    }
//    print(displaymeeting);
    return Container(
          margin: EdgeInsets.fromLTRB(5.0,5.0,2.0,5.0),
//      alignment: Alignment.topLeft,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //  (index == 0) ? ((Text(' ${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white,fontSize: 18),)))
                //  :(index!=0 && DateTimeFormatter.getDate(meetings[index].startTime) != DateTimeFormatter.getDate(meetings[index-1].startTime)) ?
                //  (Text(' ${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white, fontSize: 18),)
                //  )
                //  :(Text('',style: TextStyle(fontSize: 18))),

                child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detail(displaymeeting[index].uuid,
                            displaymeeting[index].title, displaymeeting[index].eventUuid),
                      ));
                  //  onTap: () async {
                  //     String url = "https://app.meetnotes.co/m/${meetings[index].uuid}/";
                  //     //CookieManager.setCookie(url, 'sessionid', '1etsh16q7x3hpl5en89nszcgsfnt00j6;');
                  //     await inAppBrowser.open(url: "https://app.meetnotes.co/m/${meetings[index].uuid}/", options: {
                  //       "useShouldOverrideUrlLoading": true,
                  //       "useOnLoadResource": true,
                  //       "hideTitleBar": false,
                  //     });
                },
                child: Card(
                  elevation: 100.0,
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 18, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                            decoration: new BoxDecoration(
                                color: (isToday == 0)
                                    ? (isUpcoming == true
                                        ? Colors.blue
                                        : Colors.blue)
                                    : Colors.grey[400],
                                border:
                                    Border.all(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: (isUpcoming == false)
                                ? ((isToday == 0)
                                    ? isUpcoming == true
                                        ? Text(
                                            'Upcoming',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          )
                                        : Text(
                                            'Today',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          )
                                    : Text(
                                        '${DateTimeFormatter.getDate(displaymeeting[index].startTime)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ))
                                : null),
                        Text(
                          displaymeeting[index].title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        Text(
                          '${DateTimeFormatter.getTime(displaymeeting[index].startTime)}',
                          style: TextStyle(fontSize: 12.0, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
              ));

  }

  Widget build(BuildContext context) {
    @override
    Widget meetingCard = Center(
      child: CircularProgressIndicator(),
    );
    print(meetings);
    for (int i = 0; i < meetings.length; i++) {
      if((DateTimeFormatter.isUpcomingMeeting(meetings[i].startTime))==false){
        displaymeeting.add(meetings[i]);
      }
    }



          meetingCard = GridView.builder(
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.6),
            itemBuilder: _buildMeetingItem,
            itemCount: displaymeeting.length,
          );
    return meetingCard;
  }
}
