import 'dart:io';

import 'package:memob/utilities.dart' as utilities;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';

class Actions extends StatefulWidget {
  final List<ActionClass> allActions;
  final List<dynamic> meetings;
  final List<dynamic> assignees;

  Actions(
      [this.allActions = const [],
      this.meetings = const [],
      this.assignees = const []]);

  @override
  State<StatefulWidget> createState() {
    return _Actions();
  }
}

class _Actions extends State<Actions> {
  List<ActionClass> allActions;
  List<dynamic> meetings;
  List<dynamic> assignees;
  String userToken;

  @override
  void initState() {
    allActions = widget.allActions;
    meetings = widget.meetings;
    assignees = widget.assignees;

    super.initState();
  }

  Widget _buildActionItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        border: new Border.all(color: Colors.blue, width: 1.0),
        borderRadius: new BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                        allActions[index].profilePicture != null
                            ? (CircleAvatar(
                                backgroundImage: NetworkImage(
                                    allActions[index].profilePicture),
                              ))
                            : (Text('No assignee')),
                        Text('  '),
                        (assignees[index] != null)
                            ? Text(
                                assignees[index]['display_name'],
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : Text('null',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))
                      ])),
                  Row(children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                      decoration: BoxDecoration(
                          color: (allActions[index].status == 'pending')
                              ? Colors.blue
                              : (allActions[index].status == 'doing'
                                  ? Colors.yellow
                                  : Colors.green)),
                      child: Text(allActions[index].status),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (choice) => choiceAction(choice, index),
                      itemBuilder: (BuildContext context) {
                        return Status.choices.map((String choice) {
                          return PopupMenuItem<String>(
                              value: choice, child: Text(choice));
                        }).toList();
                      },
                    ),
                  ])
                ]),
            Text(
              allActions[index].note,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget actionCard = Center(
      child: CircularProgressIndicator(),
    );
    if (allActions.length > 0) {
      actionCard = ListView.builder(
        itemBuilder: _buildActionItem,
        itemCount: allActions.length,
      );
    }

    return actionCard;
  }

  void choiceAction(String choice, int index) {
    // print("Print");
    // print(index);
    // print(meetings[index]);
    String url = 'https://app.meetnotes.co/api/v2/action-item/' +
        allActions[index].uuid +
        '/command/update/';
   

    print(url);
    Map body;
    if (choice == Status.Doing) {
      body = {'new_value': "doing", 'field': "status"};
      setState(() {
        allActions[index].status = 'doing';
      });
    } else {
      body = {'new_value': "done", 'field': "status"};
      setState(() {
        allActions[index].status = 'done';
      });
    }
    apiRequest(url, body);
  }

  Future<Null> apiRequest(String url, Map body) async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        statusUpdate(url, body);
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });

    return null;
  }

  Future<Null> statusUpdate(String url, Map body) async {
    var data = json.encode(body);
    var response = await http.patch(url,
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        },
        body: data);
    print("${response.body}");
  }
}

class Status {
  static const String Doing = 'Mark as Doing';
  static const String Done = 'Mark as Done';

  static const List<String> choices = <String>[
    Doing,
    Done,
  ];
}