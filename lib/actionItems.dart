import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';
import 'package:memob/actionManager.dart';
import 'package:memob/drawer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:memob/utilities.dart' as utilities;

class ActionItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActionItems();
  }
}

class _ActionItems extends State<ActionItems> {
  List<ActionClass> allActions = new List();
  List<ActionClass> myActions = new List();
  List assignees = new List();
  List meetings = new List();

  List myAssignees =new List();
  List myMeetings = new List();
  // ..................................................................

  String userToken;
  int  userID;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

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
        //getUserId();
        getAllActionsData();
        if (meetingDataLoaded && noteDataLoaded) return null;
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> getAllActionsData() async {
    allActions = [];
    myActions = [];
    meetings = [];
    assignees = [];
    myAssignees = [];
    myMeetings = [];
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v1/action-items/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);

        List<dynamic> list = mData['results'];

        for(int i=0; i<list.length;i++) {
        assignees.add( mData['results'][i]['assignee']);
        }

        for(int i=0; i<list.length;i++) {
        meetings.add( mData['results'][i]['meeting']);
        }

        for (var actionData in list) {
          if (actionData['assignee'] != null) {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee']['profile_picture'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          } else {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          }
        }
        meetingDataLoaded = true;
        getUserId();
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      meetingDataLoaded = true;
      return null;
    }
  }
  Future<Null> getUserId() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/settings/account/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
          userID= mData['user']['id'];

        for(var i=0;i<allActions.length;i++){
        if( assignees[i]!=null && assignees[i]['id']==userID){
            myActions.add(allActions[i]);
            myAssignees.add(assignees[i]);
            myMeetings.add(meetings[i]);
        }
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
    initConnectivity().then((result) {
      if (result) {
        this.fetchData();
      } else {
        meetingDataLoaded = true;
        noteDataLoaded = true;
      }
    });
    super.initState();
  }
  // ....................................................................

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('ACTION ITEMS'),
            actions: <Widget>[
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.filter
                ),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Filters.choices.map((String filter) {
                    return PopupMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList();
                },
              )
            ],
            bottom: TabBar(
              indicatorColor: Colors.blue,
              tabs: <Widget>[
                Tab(
                  text: 'All Actions',
                ),
                Tab(
                  text: 'My Actions',
                )
              ],
            ),
          ),
          drawer: Dwidget(userToken),
          body: Container(
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: AssetImage('assets/background.jpeg'), fit: BoxFit.cover),
            ),
            child: TabBarView(
              children: <Widget>[
                ActionManager(allActions,meetings,assignees),
                ActionManager(myActions,myMeetings,myAssignees)
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<Null> fetchOpenActionData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        //getUserId();
        getOpenActionsData();
        if (meetingDataLoaded && noteDataLoaded) return null;
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> getOpenActionsData() async {
    allActions = [];
    myActions = [];
    meetings = [];
    assignees = [];
    myAssignees = [];
    myMeetings = [];
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v1/action-items/?status__in=pending,doing'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);

        List<dynamic> list = mData['results'];

        for(int i=0; i<list.length;i++) {
        assignees.add( mData['results'][i]['assignee']);
        }

        for(int i=0; i<list.length;i++) {
        meetings.add( mData['results'][i]['meeting']);
        }

        for (var actionData in list) {
          if (actionData['assignee'] != null) {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee']['profile_picture'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          } else {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          }
        }
        meetingDataLoaded = true;
        getUserId();
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      meetingDataLoaded = true;
      return null;
    }
  }

  Future<Null> fetchRecentlyUpdatedActionData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        //getUserId();
        getRecentlyUpdatedActionsData();
        if (meetingDataLoaded && noteDataLoaded) return null;
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> getRecentlyUpdatedActionsData() async {
    allActions = [];
    myActions = [];
    meetings = [];
    assignees = [];
    myAssignees = [];
    myMeetings = [];
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v1/action-items/?ordering=-updated_at'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);

        List<dynamic> list = mData['results'];

        for(int i=0; i<list.length;i++) {
        assignees.add( mData['results'][i]['assignee']);
        }

        for(int i=0; i<list.length;i++) {
        meetings.add( mData['results'][i]['meeting']);
        }

        for (var actionData in list) {
          if (actionData['assignee'] != null) {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee']['profile_picture'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          } else {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          }
        }
        meetingDataLoaded = true;
        getUserId();
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      meetingDataLoaded = true;
      return null;
    }
  }


  Future<Null> fetchRecentlyClosedActionData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        //getUserId();
        getRecentlyClosedActionsData();
        if (meetingDataLoaded && noteDataLoaded) return null;
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> getRecentlyClosedActionsData() async {
    allActions = [];
    myActions = [];
    meetings = [];
    assignees = [];
    myAssignees = [];
    myMeetings = [];
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v1/action-items/?ordering=-updated_at&status=done'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);

        List<dynamic> list = mData['results'];

        for(int i=0; i<list.length;i++) {
        assignees.add( mData['results'][i]['assignee']);
        }

        for(int i=0; i<list.length;i++) {
        meetings.add( mData['results'][i]['meeting']);
        }

        for (var actionData in list) {
          if (actionData['assignee'] != null) {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee']['profile_picture'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          } else {
            ActionClass action = new ActionClass(
              actionData['uuid'],
              actionData['event_uuid'],
              //actionData['meeting'],
              actionData['note'],
              actionData['assignee'],
              actionData['assigned_to'],
              actionData['status'],
              actionData['is_deleted'],
              actionData['created_at'],
              actionData['due_date'],
              // actionData['tags'],
              actionData['isExternallyModified'],
              //  actionData['comments'],
            );
            allActions.add(action);
          }
        }
        meetingDataLoaded = true;
        getUserId();
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      meetingDataLoaded = true;
      return null;
    }
  }


  void choiceAction(String choice) {
    if(choice == Filters.Everything) {
      fetchData();
    }
    else if(choice == Filters.OpenActions) {
      fetchOpenActionData();
    }
    else if(choice == Filters.RecentlyUpdated)
    {
      fetchRecentlyUpdatedActionData();
    }
    else if(choice == Filters.RecentlyClosed) {
      fetchRecentlyClosedActionData();
    }
  }
}

class Filters {
  static const String Everything = 'Everything';
  static const String OpenActions = 'All Open Actions';
  static const String RecentlyUpdated = 'Recently Updated';
  static const String RecentlyClosed = 'Recently Closed';

  static const List<String> choices = <String>[
    Everything,
    OpenActions,
    RecentlyUpdated,
    RecentlyClosed
  ];
}
