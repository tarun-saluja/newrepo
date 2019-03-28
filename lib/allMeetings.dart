import 'package:flutter/material.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import './meetingClass.dart';
import './meetings.dart';

import 'package:memob/meetingClass.dart';

class AllMeetings extends StatefulWidget {
  final List<MeetingClass> meetings;
  var connectionStatus;
  AllMeetings([this.meetings = const [],this.connectionStatus]);

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
  static var position=0;
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
    // if (_meetings == null || _meetings.length == 0) {
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    // for (var i = initial; i < _meetings.length; i++) {
    //   if (i != 0 &&
    //       DateTimeFormatter.getDate(_meetings[i].startTime) !=
    //           DateTimeFormatter.getDate(_meetings[i - 1].startTime)) {
    //     low=initial;
    //     initial = i;
        return Column(
          children: <Widget>[
//             Container(
//               child: Text(
//                 'hello',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),

               Expanded(
                child: Meetings(_meetings),
              ),

          ],
        );
  //     }
  //   }

  //  if (_meetings == null || _meetings.length == 0) {
  //     return Center(
  //       child: CircularProgressIndicator(),
  //     );}
  //  return ListView.builder(
  //         itemBuilder: _buildDateOnDashboard,
  //         itemCount: _meetings.length,
  //       );
  //      }
     
  //      Widget _buildDateOnDashboard(BuildContext context, int index) {
  //        if(index!=0&& DateTimeFormatter.getDate(_meetings[index].startTime) !=
  //             DateTimeFormatter.getDate(_meetings[index - 1].startTime)){
  //               return Container(
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(DateTimeFormatter.getDate(_meetings[index-1].startTime))
  //                     ,
  //                     Meetings(_meetings.sublist(position,index))
  //                   ],
  //                 ),
  //               );
  //             }
  //             return Text('');
   }
}
