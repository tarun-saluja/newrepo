import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './Detail.dart';
import './constants.dart';
import './meetingClass.dart';

class holder {
  DateTime date;
  List<MeetingClass> meetinglist = new List<MeetingClass>();

  holder(DateTime date, List<MeetingClass> meetings) {
    this.date = date;
    this.meetinglist = meetings;
  }
}

List<holder> total_meeting = List<holder>();

class Meetings extends StatelessWidget {
  List<MeetingClass> meetings;
  List<MeetingClass> displaymeetings = new List<MeetingClass>();
  List<holder> total_meeting = new List<holder>();

  Meetings([this.meetings]);

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

// Determine if we should use mobile layout or not, 600 here is
// a common breakpoint for a typical 7-inch tablet.
    final bool useMobileLayout = shortestSide < 600;

    Widget meetingCard = Center(
      child: CircularProgressIndicator(),
    );
    for (int i = 0; i < meetings.length; i++) {
      if ((DateTimeFormatter.isUpcomingMeeting(meetings[i].startTime)) ==
          false) {
        displaymeetings.add(meetings[i]);
      }

    }
    formatData(context);
    for(int i=0;i<total_meeting.length;i++){
      print(total_meeting[i].date);
      print(total_meeting[i].meetinglist.length);
    }

    if (meetings.length > 0) {
      meetingCard =
          ListView.builder(
            itemCount: total_meeting.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int parentIndex) {
              return new Container(
                  padding: EdgeInsets.only(left:20, right: 20, bottom: 6, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              dayprint(parentIndex),
                              style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      GridView.builder(
                        physics: ClampingScrollPhysics(),
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ( useMobileLayout ? 2 : 3), childAspectRatio: 1.5),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildMeetingItem(context, parentIndex, index);
                        },
                        itemCount: total_meeting[parentIndex].meetinglist.length,
                        shrinkWrap: true,
                      )
                    ],
                  ));
            },
          );
    }
    else{
      meetingCard = Container(
        color: Color(0XFFeaf0f5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
              child: Image.asset('assets/empty.png',
                fit: BoxFit.cover,
                height: 150,
                width: 180,
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:18.0),
                child: Text('No Meetings Created',style: TextStyle(fontFamily: 'Roboto',color: Color.fromRGBO(188, 196, 209, 1), fontSize: 20),),
              )])));
//    child:Text('Tarun'))),

    }
    return meetingCard;
  }

  String dayprint(int index){
    String formattedDate = DateFormat('EEE d MMM').format(total_meeting[index].date);
    if (index==0){
      return ('Today - '+formattedDate);
    }
    if (index==1){
      return ('Yesterday - ' + formattedDate);
    }
    return (formattedDate);
  }
  formatData(BuildContext context) {
    if(displaymeetings==null || displaymeetings.length ==0){
      return;
    }


    var date = new DateTime.now();
    for (int index = 0; index < displaymeetings.length; index = index + 1) {
      List<MeetingClass> meet = new List<MeetingClass>();
      int count=0;
      for (int index1 = 0;
      index1 < displaymeetings.length;
      index1++) {

        String x = displaymeetings[index1].startTime;
        int flag = 0;

        if (int.parse(x.substring(8, 10)) == (date.day)) {
          count=count+1;
          meet.add(displaymeetings[index1]);
//        print(count);
        }
      }

      holder h = new holder(date, meet);
      if(count>0) {
        total_meeting.add(h);
        index=index+count-1;
      }

//      print(MaterialLocalizations.of(context).firstDayOfWeekIndex);
      date = date.subtract(new Duration(days: 1));

    }
//    print(total_meeting[0]);

  }

  Widget _buildMeetingItem(BuildContext context,int parentIndex, int index) {
    var today = DateFormat.yMd().format(new DateTime.now());
    var display = total_meeting[parentIndex].meetinglist[index];
    var meetingDay = DateFormat.yMd().format(DateTime.parse(display.startTime));
    var isToday = today.compareTo(meetingDay);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var isUpcoming = DateTimeFormatter.isUpcomingMeeting(display.startTime);
    return Container(
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
            color: Color.fromRGBO(255, 255, 255, 1),
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                      decoration: new BoxDecoration(
                          color: (isToday == 0)
                              ? (isUpcoming == true ? Colors.blue : Colors.blue)
                              : Color(0XFFBCC4D1),
                          border: Border.all(color: Colors.white, width: 1.0),
                          borderRadius: BorderRadius.circular(
                              height * 0.01290560471 * 2)),
                      child: (isUpcoming == false)
                          ? ((isToday == 0)
                          ? isUpcoming == true
                          ? Text(
                        '$UPCOMING',
                        style: TextStyle(
                            fontFamily:'RobotoMedium',fontSize: 12.0, color: Colors.white),
                      )
                          : Text(
                        '$TODAY',
                        style: TextStyle(
                            fontFamily:'RobotoMedium', fontSize: 12.0, color: Colors.white),
                      )
                          : Text(
                        '${DateTimeFormatter.getDate(display.startTime)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily:'RobotoMedium', fontSize: 12.0,
                        ),
                      ))
                          : null),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                        children:[
                          Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              alignment: Alignment.bottomLeft,
                              child:Text(
                                display.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontFamily: 'RobotoBold',
                                    color: Color(0XFF5A6278)),
                              )),
                          Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              alignment: Alignment.bottomLeft,
                              child:Text(
                                '${DateTimeFormatter.getTime(display.startTime)}',
                                style: TextStyle(fontSize: 12.0,fontFamily: 'Roboto', color: Color(0XFFBCC4D1)),
                              )),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
