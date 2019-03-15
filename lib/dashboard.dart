import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:memob/Detail.dart';
import 'package:memob/NotesClass.dart';
import 'package:memob/meetingClass.dart';
import 'package:memob/searchbar.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:requests/requests.dart';

import 'package:url_launcher/url_launcher.dart';
import './recentlyUpdated.dart';
import './allMeetings.dart';
import './drawer.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> {
  String userToken;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  List<MeetingClass> _meetings = new List();
  List<NotesClass> _notes = new List();

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
    } catch (PlatformException) {
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
        return null;
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
          HttpHeaders.CACHE_CONTROL: 'no-cache',
        });

        http.Response response1 = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/login/google-oauth2/?next=/mtoken/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache',
        });
    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        List<String> listMeetings = mData.keys.toList();
        _meetings.clear();
        for (String keys in listMeetings) {
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
            _meetings.add(meeting);
          }
        }
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
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

        _notes.clear();
        for (var recentNote in mData) {
          NotesClass note = new NotesClass(
              recentNote['action_items'],
              recentNote['meeting_title'],
              recentNote['is_archived'],
              recentNote['updated_at'],
              recentNote['meeting_uuid'],
              recentNote['event_uuid']);
          _notes.add(note);
        }
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }

  @override
  initState() {
    super.initState();
    initConnectivity().then((result) {
      if (result) {
        this.fetchData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    NotesClass result = await showSearch(
                        context: context, delegate: DataSearch(_notes));
                    if (result != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(result.meetingUuid,
                                  result.meetingTitle, result.eventUuid)));
                    }
                    
                  })
            ],
            bottom: TabBar(
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  text: "Meetings",
                ),
                Tab(
                  text: "Recent Notes",
                )
              ],
            ),
          ),
          drawer: Dwidget(userToken),
          body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage('assets/background.jpeg'),
                  fit: BoxFit.cover),
            ),
            child: TabBarView(
              children: <Widget>[
                AllMeetings(_meetings),
                RecentlyUpdated(_notes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
