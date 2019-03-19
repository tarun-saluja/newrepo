import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './Detail.dart';

class Meetings extends StatelessWidget {
  List<MeetingClass> meetings;
  Meetings([this.meetings]);

  Widget _buildMeetingItem(BuildContext context, int index) {
    var today = DateFormat.yMd().format(new DateTime.now());
    var meetingDay =
        DateFormat.yMd().format(DateTime.parse(meetings[index].startTime));
    var isToday = today.compareTo(meetingDay);

    var isUpcoming =
        DateTimeFormatter.isUpcomingMeeting(meetings[index].startTime);

    return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,  
    children: <Widget>[
     (index == 0) ? ((Text(' ${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white,fontSize: 18),)))
     :(index!=0 && DateTimeFormatter.getDate(meetings[index].startTime) != DateTimeFormatter.getDate(meetings[index-1].startTime)) ?
     (Text(' ${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white, fontSize: 18),)
     ) 
     :(Text('',style: TextStyle(fontSize: 18))),
     
     Container(
      margin: new EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detail(meetings[index].uuid,
                    meetings[index].title, meetings[index].eventUuid),
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
            margin: EdgeInsets.fromLTRB(25, 18, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            '${DateTimeFormatter.getDate(meetings[index].startTime)}',style: TextStyle(color: Colors.white,fontSize: 12.0,),)),
                Text(
                  meetings[index].title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
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
    )
    ],
    );
  }

  Widget build(BuildContext context) {
  @override 
    
    Widget meetingCard = Center(
      child: CircularProgressIndicator(),
    );
    if (meetings.length > 0) {

        meetingCard = GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.35),
          itemBuilder: _buildMeetingItem,
          itemCount: meetings.length,
        );

      
    }
    return meetingCard;
  }
}
