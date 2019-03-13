import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memob/utilities.dart' as utilities;
// import 'package:memob/speechDialog.dart';
// import 'package:memob/attachmentListDialog.dart';
// import 'package:memob/cameraPage.dart';
import 'package:memob/dateTimeFormatter.dart' as DateTimeFormatter;
import 'package:flutter/cupertino.dart';
// import 'package:simple_permissions/simple_permissions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:memob/webView.dart';

import './share.dart';
import './dashboard.dart';
import './attachmentListDialog.dart';
import './cameraPage.dart';
import './speechDialog.dart';

class Detail extends StatefulWidget {
  final String meetingUuid;
  final String meetingTitle;
  final String meetingEventId;

  Detail([this.meetingUuid, this.meetingTitle, this.meetingEventId]);

  @override
  State<StatefulWidget> createState() {
    return _DetailState();
  }
}

class _DetailState extends State<Detail> {
  //String _uuid;
  Map<String, dynamic> data;
  List<dynamic> attachmentCountData;
  List<dynamic> attachmentData;
  String userToken;

  bool noteLoaded = false;
  bool attachmentCountLoaded = false;
  bool attachmentLoaded = false;
  bool emptyAttachment = false;

  String noteText;
  List<String> attendeesEmail;
  String rawHtml;
  String delta;
  bool recordPermission = false;

  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  int attachmentCount;

  var finalDateTime;

  Future<bool> initConnectivity() async {
    var connectionStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity());

      this.setState(() {
        if (connectionStatus == ConnectivityResult.none) {
          _connectionStatus = false;
        } else {
          _connectionStatus = true;
        }
      });
    } on PlatformException catch (e) {
      _connectionStatus = false;
    }

    if (!mounted) {
      return false;
    }
    return _connectionStatus;
  }

  // Future<Null> checkRecordPermission() async {
  //   bool res = await SimplePermissions.checkPermission(Permission.RecordAudio);
  //   if (res.toString() == 'true') {
  //     recordPermission = true;
  //   } else {
  //     bool res =
  //         await SimplePermissions.requestPermission(Permission.RecordAudio);
  //     if (res.toString() == 'true') {
  //       recordPermission = true;
  //     }
  //   }
  // }

  Future<Null> fetchData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        getRecentNotes(value);
        getRecentNotesCount(value);
      } else {
        utilities.showLongToast(value);
      }
    });
  }

  Future<String> getRecentNotes(String token) async {
    final response = await http.get(
        Uri.encodeFull(
            'https://app.meetnotes.co/api/v2/meeting-data/${widget.meetingUuid}'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $token',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        data = json.decode(response.body);

        List<dynamic> rawNote = data['raw_note'];
        List<dynamic> attendees = data['attendees'];
        rawHtml = data['raw_note'][0]['raw_html'];
        delta = data['raw_note'][0]['delta'];

        print(rawHtml);
        print(delta);
        attendeesEmail = new List();

        for (int i = 0; i < attendees.length; i++) {
          attendeesEmail.add('${data['attendees'][i]['email']}');
          //print('${data['attendees'][i]['email']}');
        }

        print(attendeesEmail);

        noteLoaded = true;
        noteText = rawNote.isNotEmpty ? '${data['raw_note'][0]['body']}' : '';
        finalDateTime = DateTimeFormatter.getDateTimeFormat(data['start_time']);
      });
    } else {
      // If that response was not OK, throw an error.
      noteLoaded = true;
      throw Exception('Failed to load post');
    }
    return 'Success';
  }

  Future<String> getRecentNotesCount(String token) async {
    final response = await http.get(
        Uri.encodeFull(
            'https://app.meetnotes.co/api/v2/attachments/?event=${widget.meetingEventId}'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $token',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        attachmentCountData = json.decode(response.body);

        if (attachmentCountData.isNotEmpty) {
          attachmentCount = attachmentCountData[0]['count'];
        } else {
          attachmentCount = 0;
        }
        attachmentCountLoaded = true;
      });
    } else {
      // If that response was not OK, throw an error.
      attachmentCountLoaded = true;
      throw Exception('Failed to load post');
    }
    return 'Success';
  }

  @override
  void initState() {
    super.initState();

    initConnectivity().then((result) {
      if (result) {
        this.fetchData();
      } else {
        noteLoaded = true;
        attachmentCountLoaded = true;
      }
    });
  }

  // @override
  // void initState() {
  //   if (widget.uuid != null) {
  //     _uuid = widget.uuid;
  //   }
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meetingTitle),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: (data != null) ? Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text('$finalDateTime'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      attachmentCount != 0
                          ? showDialog(
                              context: context,
                              child: new AttachmentDialog(widget.meetingUuid))
                          : Fluttertoast.showToast(
                              msg: "No Attachment",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                    },
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.attach_file,
                          color: Colors.amber,
                        ),
                        Text(attachmentCount.toString())
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            margin: new EdgeInsets.all(10.0),
            height: height * 0.60,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white70,
                      blurRadius: 10.0,
                      spreadRadius: 1.0),
                ]),
            child: ListView(
              children: <Widget>[
                Text(
                  '$noteText',
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ],
            ),
          )
        ],
      )
      :Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new CameraPage(widget.meetingTitle, widget.meetingUuid)));
              break;
            case 1:
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => 
                new Speech(widget.meetingUuid)
            ));
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.blue,
                size: 30.0,
              ),
              title: Text('')),
          BottomNavigationBarItem(
              icon: Icon(Icons.mic_none, color: Colors.blue, size: 30.0),
              title: Text('')),
        ],
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Share) {
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new Share(widget.meetingTitle, '$noteText',
                attendeesEmail, rawHtml, delta, widget.meetingUuid),
          ));
    } else {
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => Dashboard(),
          ));
    }
  }
}

class Constants {
  static const String Share = 'Share';
  static const String Leave = 'Leave';

  static const List<String> choices = <String>[
    Share,
    Leave,
  ];
}

// class Choice {
//   const Choice({this.title, this.icon});

//   final String title;
//   final IconData icon;
// }

// const List<Choice> choices = const <Choice>[
//   const Choice(title: 'Car', icon: Icons.directions_car),
//   const Choice(title: 'Bicycle', icon: Icons.directions_bike),
//   const Choice(title: 'Boat', icon: Icons.directions_boat),
//   const Choice(title: 'Bus', icon: Icons.directions_bus),
//   const Choice(title: 'Train', icon: Icons.directions_railway),
//   const Choice(title: 'Walk', icon: Icons.directions_walk),
// ];

// class ChoiceCard extends StatelessWidget {
//   const ChoiceCard({Key key, this.choice}) : super(key: key);

//   final Choice choice;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle textStyle = Theme.of(context).textTheme.display1;
//     return Card(
//       color: Colors.white,
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(choice.icon, size: 128.0, color: textStyle.color),
//             Text(choice.title, style: textStyle),
//           ],
//         ),
//       ),
//     );
//   }
// }
