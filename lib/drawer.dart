import 'dart:convert';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/teamClass.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:http/http.dart' as http;

class Dwidget extends StatefulWidget {
  final String userToken;
  Dwidget([this.userToken]);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DwidgetState();
  }
}

class _DwidgetState extends State<Dwidget> {
  String userToken1;
  List<String> team = new List();
  List<TeamClass> teamNames = new List();
  Future<List<TeamClass>> getAllTeamsData() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken1',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

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
    // TODO: implement initState
    super.initState();
    userToken1 = widget.userToken;
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ));
            },
            leading: const Icon(Icons.dashboard),
            title: new Text("Dashboard"),
          ),
          new ListTile(
            leading: const Icon(Icons.group_work),
            title: new Text("Meetings"),
          ),
          new ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebView(
                          initialUrl: 'https://app.meetnotes.co/m/cac2faac-c04b-4c00-9373-fa1c50de72a6/',
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController wvc){
                            wvc.evaluateJavascript('_ga=GA1.2.1533643988.1551348935; __stripe_mid=a03694ae-9866-409a-add0-f178eaaccf0d; intercom-id-fvxq07yl=8125b2f6-73f2-4774-8e0e-2b2fbd49a335; csrftoken=fODVBsMCNtNrLSP5Cw7pnib5fkw0zi3K; sessionid=z25vciupmwdpkw44slia7ulxgzov9sfy; IS_GENUINE=true; REFERRER=; _gid=GA1.2.1999392027.1552367089; userId=e045d269b3384dfd8401fcb0f264c888; API_TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiYXRoYXIuZWphekBoYXNoZWRpbi5jb20iLCJ1dWlkIjoiZTA0NWQyNjliMzM4NGRmZDg0MDFmY2IwZjI2NGM4ODgifQ.n1qfJYe73ehwOTZ1m59Fv2uR21GmVM6BdDFd3tZO6SCZ9HVL4jHxn78hJ3qRHhctcZS-mwekC7W9nS8oSTMnXo-OzddmAd6Y52kJGkydhwn0h8ZjHoyemDF8aj5V4yCer_PE7FxduR9VNk3r8sDOojG3oiBuSpqIrNqC-BRy1AYHTzCNPEgpDejLHQOcgz1yyQpKKNQHGN_M0uxdpBsjoGG5JSjiK_QUm7U4pp01Cz606ZodaeSJNz6-nh5mP1JKvQVmZimx4d3GB4yoW7WgRKHOBp0WN3lNLK_9aOBLHxm61m9zB2BLvmU_XCS5hKS_H3wRvQdlcxNjIhjsu7l-vA; __stripe_sid=c21ef2a3-84d7-446e-bcd0-b104009dad31; intercom-session-fvxq07yl=ZjRteE1tY2dmMDZRWjlrYVJ3N3FBVTFoN004TTlmNkJ3NnpySERiaS9UMDVxVURoVVRyWFJsNmU1MFZWRXJsKy0tVDhIT3V6NDU3NzBqSStjMHZrSkFodz09--12d13087a1dc00aa601fe93043baddb9aee274cf; _ga=GA1.2.1533643988.1551348935; __stripe_mid=a03694ae-9866-409a-add0-f178eaaccf0d; intercom-id-fvxq07yl=8125b2f6-73f2-4774-8e0e-2b2fbd49a335; csrftoken=fODVBsMCNtNrLSP5Cw7pnib5fkw0zi3K; sessionid=z25vciupmwdpkw44slia7ulxgzov9sfy; IS_GENUINE=true; REFERRER=; REFERRER=; _gid=GA1.2.1999392027.1552367089; userId=e045d269b3384dfd8401fcb0f264c888; API_TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiYXRoYXIuZWphekBoYXNoZWRpbi5jb20iLCJ1dWlkIjoiZTA0NWQyNjliMzM4NGRmZDg0MDFmY2IwZjI2NGM4ODgifQ.n1qfJYe73ehwOTZ1m59Fv2uR21GmVM6BdDFd3tZO6SCZ9HVL4jHxn78hJ3qRHhctcZS-mwekC7W9nS8oSTMnXo-OzddmAd6Y52kJGkydhwn0h8ZjHoyemDF8aj5V4yCer_PE7FxduR9VNk3r8sDOojG3oiBuSpqIrNqC-BRy1AYHTzCNPEgpDejLHQOcgz1yyQpKKNQHGN_M0uxdpBsjoGG5JSjiK_QUm7U4pp01Cz606ZodaeSJNz6-nh5mP1JKvQVmZimx4d3GB4yoW7WgRKHOBp0WN3lNLK_9aOBLHxm61m9zB2BLvmU_XCS5hKS_H3wRvQdlcxNjIhjsu7l-vA; __stripe_sid=c21ef2a3-84d7-446e-bcd0-b104009dad31; intercom-session-fvxq07yl=RlVJbTNtb2xqUUptQ3dTR0l5OHJkSE1oM1VJdm5uMFRqMUtvZ21vTHVKc2czSDdJWWdMNk5YMnJQT3RON3FBdi0tODVCRytWcXNSTDJlRXQ1a0x6dityQT09--cc9dffce88fcc7873be357bde0bbc62e9c8ca041');
                          },
                        ),
                  ));
            },
            leading: const Icon(Icons.note),
            title: new Text("Notes"),
          ),
          new ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActionItems(),
                  ));
            },
            leading: const Icon(Icons.call_to_action),
            title: new Text("Action Items"),
          ),
          new Container(
            child: ExpansionTile(
              leading: Icon(Icons.group),
              title: Text("Teams"),
              children: <Widget>[_buildTeamNames()],
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.settings),
            title: new Text("Settings"),
          ),
          new ListTile(
            leading: const Icon(Icons.person),
            title: new Text("User"),
          ),
          new ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: new Text("Logout"),
            onTap: () async {
              utilities.removeToken().then((result) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/Login', (Route<dynamic> route) => false);
              });
            },
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
                return Center(child: Text(snapshot.data[i].name));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
