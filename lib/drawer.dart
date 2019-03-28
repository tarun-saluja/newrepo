import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/settings.dart';
import 'package:memob/teamClass.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:http/http.dart' as http;
import './webView.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class Dwidget extends StatefulWidget {
  final String userToken;
  String displayName;
  String profile_picture;
  Dwidget([this.userToken, this.displayName, this.profile_picture]);
  @override
  State<StatefulWidget> createState() {
    return _DwidgetState();
  }
}

class _DwidgetState extends State<Dwidget> {
  String userToken1;
  String displayName;
  String profile_picture;
  List<String> team = new List();
  List<TeamClass> teamNames = new List();
  //MyInAppBrowser inAppBrowser = new MyInAppBrowser();

  Future<List<TeamClass>> getAllTeamsData() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken1',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    print(response.body);
    Map<String, dynamic> mData = json.decode(response.body);
    List<dynamic> list = mData["results"];
    for (var teamData in list) {
      TeamClass team = new TeamClass(teamData['name']);
      teamNames.add(team);
    }
    return teamNames;
  }

  @override
  void initState() {
    super.initState();
    userToken1 = widget.userToken;
    displayName = widget.displayName;
    profile_picture = widget.profile_picture;
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
//      backgroundColor: Color.fromRGBO(35, 45, 71, 0.9),
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
                    "MEETNOTES",
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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Dashboard(),
                //     ));
                Navigator.popUntil(context, ModalRoute.withName('Dashboard'));
              },
              // leading: const Icon(Icons.dashboard),
              leading: Image.asset(
                'assets/dashboard.png',
                width: 25.0,
                height: 25.0,
              ),
              title: new Text(
                "Dashboard",
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
              title: new Text("Notes",
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
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ActionItems(),
                //     ));
                bool isNewRouteSameAsCurrent = false;
                Navigator.popUntil(context, (route) {
                  print('-------------------------');
                  print(route);
                  print(route.settings.name);
                  if (route.settings.name == "ActionItems") {
                    isNewRouteSameAsCurrent = true;
                    print('inside something----------------------------------------');
                  }
                  return true;
                });
                if (!isNewRouteSameAsCurrent) {
                  Navigator.pushNamed(
                      context,'ActionItems');
                }
                else
                {
                   Navigator.pop(context, 'ActionItems');
                }
              },
              leading: Image.asset(
                'assets/action_items.png',
                width: 25.0,
                height: 25.0,
              ),
              title: new Text("Action",
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

              title: Text("Team",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black38,
                      fontWeight: FontWeight.w400)),
              children: <Widget>[_buildTeamNames(),],
            ),
          ),
          new Divider(color: Colors.white,height: 50,),
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
              title: new Text("Settings",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black12,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30, 20, 70, 0),
            child: new ListTile(
                leading: (profile_picture != null)
                    ? (CircleAvatar(
                        backgroundImage: AssetImage(profile_picture),
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
                    : (new Text('User',
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
              title: new Text("Logout",
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
                  child: Center(
                      child: Text(snapshot.data[i].name)
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
