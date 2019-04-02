import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memob/settings.dart';
import 'package:memob/teamClass.dart';
import 'package:memob/utilities.dart' as utilities;

import './api_service.dart';
import './constants.dart';

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
  var api = new API_Service();

  @override
  void initState() {
    super.initState();
    userToken1 = widget.userToken;
    displayName = widget.displayName;
    profilepicture = widget.profilepicture;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new Container(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 35, 50, 50),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Image.asset(
                    'assets/meetnotes_icon.png',
                    width: 30.0,
                    height: 30.0,
                  ),
                  Text(
                    "$LOGONAME",
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.6,
                    style: new TextStyle(color: Colors.black26),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 70, 0),
            child: new ListTile(
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('Dashboard'));
              },
              leading: Image.asset(
                'assets/dashboard.png',
                width: 25.0,
                height: 25.0,
              ),
              title: new Text(
                "$DASHBOARD",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black38,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 70, 0),
            child: new ListTile(
              leading: Image.asset(
                'assets/notes.png',
                width: 25.0,
                height: 25.0,
              ),
              title: new Text("$NOTES",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 70, 0),
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
                width: 25.0,
                height: 25.0,
              ),
              title: new Text("$ACTION",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(30, 30, 70, 0),
            child: ExpansionTile(
              leading: Image.asset(
                'assets/team.png',
                width: 30.0,
                height: 30.0,
              ),
              title: Text("$TEAM",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
              children: <Widget>[
                _buildTeamNames(),
              ],
            ),
          ),
          new Divider(
            color: Colors.white,
            height: 50,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 120, 70, 0),
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
                width: 25.0,
                height: 25.0,
                color: Colors.black12,
              ),
              title: new Text("$SETTINGS",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black12,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 20, 70, 0),
            child: new ListTile(
                leading: (profilepicture != null)
                    ? (CircleAvatar(
                        backgroundImage: AssetImage(profilepicture),
                        maxRadius: 17,
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
                            fontWeight: FontWeight.w400)))
                    : (new Text('$USER',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontWeight: FontWeight.w400)))),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 0, 70, 0),
            child: new ListTile(
              leading: Image.asset(
                'assets/logout.png',
                width: 25.0,
                height: 25.0,
              ),
              title: new Text("$LOGOUT",
                  style: TextStyle(
                      fontSize: 18,
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
                  child: Center(child: Text(snapshot.data[i].name)),
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
}
