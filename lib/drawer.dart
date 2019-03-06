import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memob/NotesClass.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import './meetingClass.dart';

class Dwidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DwidgetState();
  }
}

class _DwidgetState extends State<Dwidget> {
String userToken;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  List<MeetingClass> meetings = new List();
  List<NotesClass> recentNotes = new List();

  bool meetingDataLoaded = false;
  bool noteDataLoaded = false;

  var finalDateTime;

  Map<String, dynamic> data;

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

  Future<Null> fetchData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        getMeetingData();
        getRecentNotes();
        if (meetingDataLoaded && noteDataLoaded) return null;
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> getMeetingData() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/meetings/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      print("Hello");
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        List<String> list = mData.keys.toList();
        list.sort();

        Iterable<String> reversedList = list.reversed;

        print(reversedList);

        meetings = new List();

        for (String keys in reversedList) {
          List list = mData[keys];
          for (var meetingData in list) {
            MeetingClass meeting = new MeetingClass(
                meetingData['uuid'],
                meetingData['title'],
                meetingData['start_time'],
                meetingData['end_time'],
                meetingData['event_uuid'],
                meetingData['has_notes'],
                meetingData['is_archived']);
            meetings.add(meeting);
          }
        }
        meetingDataLoaded = true;
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      meetingDataLoaded = true;
      return null;
    }
  }

  Future<Null> getRecentNotes() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/recent-notes/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        List<dynamic> mData = json.decode(response.body);

        recentNotes = new List();
        for (var recentNote in mData) {
          NotesClass note = new NotesClass(
              recentNote['action_items'],
              recentNote['meeting_title'],
              recentNote['is_archived'],
              recentNote['updated_at'],
              recentNote['meeting_uuid'],
              recentNote['event_uuid']);
          recentNotes.add(note);
        }
        noteDataLoaded = true;
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      noteDataLoaded = true;
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity().then((result) {
      if (result) {
        this.fetchData();
      } else {
        meetingDataLoaded = true;
        noteDataLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
                child: new DrawerHeader(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Image.asset(
                    'assets/meetnotes_icon.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                  Text(
                    "MEETNOTES",
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.0,
                    style: new TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Colors.white70),
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.dashboard),
            title: new Text("Dashboard"),
          ),
          new ListTile(
            leading: const Icon(Icons.group_work),
            title: new Text("Meetings"),
          ),
          new ListTile(
            leading: const Icon(Icons.note),
            title: new Text("Notes"),
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("Action Items"),
          ),
          new Divider(),
          new ExpansionTile(
            leading: const Icon(Icons.group),
            title: new Text("Team"),
            children: <Widget>[Text("children 1"), Text("children 2")],
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("Settings"),
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("User"),
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("Logout"),
            onTap: () async{

                utilities.removeToken().then((result){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });

                },
          ),
        ],
      ),
    );
  }
}
