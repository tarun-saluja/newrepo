import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memob/actionClass.dart';
import 'package:memob/settings.dart';
import 'package:memob/teamClass.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:http/http.dart' as http;

import './api_service.dart';
import './constants.dart';
import './dashboard.dart';

class Dwidget extends StatefulWidget {
  final String userToken;
  String displayName;
  String profilepicture;

  Dwidget([this.userToken, this.displayName, this.profilepicture]);

  @override
  State<StatefulWidget> createState() {
    return _DwidgetState();
  }
}

class _DwidgetState extends State<Dwidget> {
  String userToken1;
  String displayName;
  String profilepicture;
  List<String> team = new List();
  List<TeamClass> teamNames = new List();

  List<ActionClass> allActions = new List();
  List allAssignees = new List();
  List allMeetings = new List();

  List<ActionClass> myActions = new List();
  List myAssignees = new List();
  List myMeetings = new List();

  String userToken;
  int userID;
  String profile_picture;
  bool _connectionStatus = false;

  var api = new API_Service();

  @override
  void initState() {
    super.initState();
    userToken1 = widget.userToken;
    displayName = widget.displayName;
    profilepicture = widget.profilepicture;
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    double heights = MediaQuery.of(context).size.height;
    double widths = MediaQuery.of(context).size.width;
    print(heights);
    print(widths);
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07191666666, widths*0.08506944444, 0, widths*0.12152777777),
            child: new ListTile(
              leading: Image.asset(
                'assets/meetnotes_icon.png',
                width: 30,
                height: 30,
              ),
              title: new Text(
                "$LOGONAME",
                textScaleFactor: 1.2,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
//          new Container(
//            child: Container(
//              margin: EdgeInsets.fromLTRB(widths*0.07191666666, widths*0.08506944444, 0, widths*0.12152777777),
//              child: new Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: <Widget>[
//                  new Image.asset(
//                    'assets/meetnotes_icon.png',
//                    width: 30,
//                    height: 30,
//                  ),
//                  Text(
//                    "$LOGONAME",
//                    textScaleFactor: 1.6,
//                    style: new TextStyle(color: Colors.black26,
//                    fontFamily: 'Roboto'),
//                  ),
//                ],
//              ),
//            ),
//          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, 0, 0, 0),
            child: new ListTile(
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('Dashboard'));
              },
              leading: Image.asset(
                'assets/dashboard.png',
                width: 25,
                height: 25,
              ),
              title: new Text(
                "$DASHBOARDS",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, 0, 0, 0),
            child: new ListTile(
              onTap: () {
                m=1;
                Navigator.popUntil(context, ModalRoute.withName('Dashboard'));
              },
              leading: Image.asset(
                'assets/notes.png',
                width: 25,
                height: 25,
              ),
              title: new Text("$NOTES",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, 0, 0, 0),
            child: new ListTile(
              onTap: () {
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  if (route.settings.name == "ActionItems") {
                    isNewRouteSameAsCurrent = true;
                  }
                  return true;
                });
                if (!isNewRouteSameAsCurrent) {
                  Navigator.pushNamed(context, 'ActionItems');
                } else {
                  Navigator.pop(context, 'ActionItems');
                }
              },
              leading: Image.asset(
                'assets/action_items.png',
                width: 25,
                height: 25,
              ),
              title: new Text("$ACTION",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400)),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, widths*0.07291666666, 0, 0),
            child: ExpansionTile(
              leading: Image.asset(
                'assets/team.png',
                width: 25,
                height: 25,
              ),
              title: Text("$TEAM",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
              children: <Widget>[
                _buildTeamNames(),
              ],
            ),
          ),
          new Divider(
            color: Colors.white,
            height: widths*0.12152777777,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, heights*0.06166666666, 0, 0),
            child: new ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
                    ));
              },
              leading: Image.asset(
                'assets/settings.png',
                width: 25,
                height: 25,
                color: Colors.black12,
              ),
              title: new Text("$SETTINGS",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, 0, 0, 0),
            child: new ListTile(
                leading: (profilepicture != null)
                    ? Container(
                    height: 30,
                    width: 30,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                profilepicture)
                        )
                    ))
                    : (CircleAvatar(
                        backgroundImage: AssetImage('assets/blank_user.jpeg'),
                        maxRadius: 17,
                      )),
                title: (displayName != null)
                    ? (new Text(displayName,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400)))
                    : (new Text('User',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto',
                            color: Colors.black38,
                            fontWeight: FontWeight.w400)))),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(widths*0.07291666666, 0, 0, 0),
            child: new ListTile(
              leading: Image.asset(
                'assets/logout.png',
                width: 25,
                height: 25,
              ),
              title: new Text("$LOGOUT",
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
              onTap: () async {
                utilities.removeToken().then((result) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamNames() {
    return Container(
      child: new FutureBuilder(
          future: getAllTeamsData(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TeamClass>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              for (var i = 0; i < snapshot.data.length; i++) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 6.0),
                  child: Center(child: Text(snapshot.data[i].name, style: TextStyle(fontFamily: 'Roboto'),)),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<List<TeamClass>> getAllTeamsData() async {
    final response = await api.getAllTeams(userToken1);

    Map<String, dynamic> mData = json.decode(response.body);
    List<dynamic> list = mData["results"];
    for (var teamData in list) {
      TeamClass team = new TeamClass(teamData['name']);
      teamNames.add(team);
    }
    return teamNames;
  }
  Future<Null> getUserDetails() async {
    var response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/settings/account/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Token ' + userToken1,
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.cacheControlHeader: 'no-cache'
        });
//    print(response.body.substring(100,120));

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        profilepicture = mData['profile_picture'];

//        print(myActions[0]);
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }
}
