import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:memob/utilities.dart' as utilities;
import './NotesClass.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import './notes.dart';

class RecentlyUpdated extends StatefulWidget {
  NotesClass startingNote;

  RecentlyUpdated({this.startingNote});

  @override
  State<StatefulWidget> createState() {
    return _RecentlyUpdatedState();
  }
}

class _RecentlyUpdatedState extends State<RecentlyUpdated> {
   String userToken;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  List<NotesClass> _notes = new List();

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
        getRecentNotes();
           if (meetingDataLoaded && noteDataLoaded) return null;
      }
       else {
        utilities.showLongToast(value);
        return null;
      }
    });
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

        _notes = new List();
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
          child: Notes(_notes),
        )
      ],
    );
  }
}
