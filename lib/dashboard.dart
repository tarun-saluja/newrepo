import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:memob/NotesClass.dart';
import 'package:memob/meetingClass.dart';
import 'package:memob/utilities.dart' as utilities;

import './allMeetings.dart';
import './api_service.dart';
import './constants.dart';
import './drawer.dart';
import './recentlyUpdated.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();


class Dashboard extends StatefulWidget {
  static final Dashboard _dashboard = new Dashboard._private();

  Dashboard._private();

  factory Dashboard() {
    return _dashboard;
  }

  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin{
  String userToken;
  String _displayName;
  String _profilepicture;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();
  TabController _tabController;

  List<MeetingClass> _meetings = new List();
  List<NotesClass> _notes = new List();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('$DASHBOARD',style: TextStyle(color: Color(0XFFBCC4D1),fontSize: 18, fontFamily: 'RobotoBold'),),
            leading:  Builder(
              builder: (context) =>
                  FlatButton(
                    onPressed:(){
                      Scaffold.of(context).openDrawer();
                    },
                    child: new Image.asset('assets/menu.png',
                      fit: BoxFit.fill,
                    ),
                  ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorWeight: 3,
              unselectedLabelColor: Color(0XFF8A93AA),
              labelColor: Color(0XFF1794FF),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
//                  text: 'All ' + ACTION,
                  child: Text(ALL_MEETINGS, style: TextStyle(fontSize: 17, fontFamily: 'RobotoMedium'),),
                ),
                Tab(
                  child: Text(RECENT_NOTES, style: TextStyle(fontSize: 17, fontFamily: 'RobotoMedium'),),
                ),

              ],
            ),
          ),
          drawer: Dwidget(userToken, _displayName, _profilepicture),
          body: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: AssetImage('assets/bg.png'), fit: BoxFit.cover),
            ),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                new RefreshIndicator(
                    child: AllMeetings(_meetings), onRefresh: getMeetingData),
                new RefreshIndicator(
                    child: RecentlyUpdated(_notes), onRefresh: getRecentNotes)
              ],
            ),
          ),
        ),
      ),
    );
  }

  int value(){
//    print('klklklkl');
    print(secondtab[m]);
    return secondtab[m];
  }

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
  var api = new API_Service();
  Future<Null> fetchData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (true) {
        userToken = value;
        getMeetingData();
        getRecentNotes();
        getUserDetails();
      } else {
        utilities.showLongToast(value);
      }
    });
  }

  Future<Null> getMeetingData() async {
    final response = await api.getMeeting(userToken);
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
        _meetings.sort((a, b) => b.startTime.compareTo(a.startTime));
      });
    }
  }

  Future<Null> getUserDetails() async {
    final response = await api.getUser();

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        _displayName = mData['user']['display_name'];
        _profilepicture = mData['user']['profilepicture'];
      });

    }
  }

  Future<Null> getRecentNotes() async {
    final response = await api.getRecentNotesDetails();
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
    }
  }

  @override
  initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    flutterWebviewPlugin.close();
    initConnectivity().then((result) {
      if (result) {
        this.fetchData();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
