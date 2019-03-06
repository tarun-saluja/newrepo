import 'package:flutter/material.dart';

import './meetingClass.dart';
import './meetings.dart';

import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:memob/meetingClass.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:memob/utilities.dart' as utilities;

class AllMeetings extends StatefulWidget {
  final MeetingClass startingMeeting;

  AllMeetings({this.startingMeeting});

  @override
  State<StatefulWidget> createState() {
    return _AllMeetingsState();
  }
}

class _AllMeetingsState extends State<AllMeetings> {
   String userToken;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  List<MeetingClass> _meetings = new List();

  bool meetingDataLoaded = false;
  bool noteDataLoaded = false;

  var finalDateTime;

  // Map<String, dynamic> data;

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
    }
    catch(PlatformException) {
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
           if (meetingDataLoaded && noteDataLoaded) return null;
      }
       else {
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
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        List<String> list = mData.keys.toList();
        list.sort();

        Iterable<String> reversedList = list.reversed;

        print(reversedList);

        _meetings = new List();

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
            _meetings.add(meeting);
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

  @override
  initState() {
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
    return Column(
      children: <Widget>[
        Expanded(
          child: Meetings(_meetings),
        )
      ],
    );
  }
}
