import 'dart:convert';
import 'dart:io';
import './webView.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/settings.dart';
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
  //final CookieManager cookieManager = CookieManager();

  Future<List<TeamClass>> getAllTeamsData() async {
    final response = await http.get(
        //Uri.encodeFull('https://app.meetnotes.co/api/v2/teams/'),
        Uri.encodeFull('https://app.meetnotes.co/m/cac2faac-c04b-4c00-9373-fa1c50de72a6/'),
        headers: {
          // HttpHeaders.AUTHORIZATION: 'Token $userToken1',
          // HttpHeaders.CONTENT_TYPE: 'application/json',
          // HttpHeaders.ACCEPT: 'application/json',
          // HttpHeaders.CACHE_CONTROL: 'no-cache'
          HttpHeaders.COOKIE : '_ga=GA1.2.1533643988.1551348935; __stripe_mid=a03694ae-9866-409a-add0-f178eaaccf0d; intercom-id-fvxq07yl=8125b2f6-73f2-4774-8e0e-2b2fbd49a335; IS_GENUINE=true; REFERRER=; _gid=GA1.2.1999392027.1552367089; userId=e045d269b3384dfd8401fcb0f264c888; API_TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiYXRoYXIuZWphekBoYXNoZWRpbi5jb20iLCJ1dWlkIjoiZTA0NWQyNjliMzM4NGRmZDg0MDFmY2IwZjI2NGM4ODgifQ.n1qfJYe73ehwOTZ1m59Fv2uR21GmVM6BdDFd3tZO6SCZ9HVL4jHxn78hJ3qRHhctcZS-mwekC7W9nS8oSTMnXo-OzddmAd6Y52kJGkydhwn0h8ZjHoyemDF8aj5V4yCer_PE7FxduR9VNk3r8sDOojG3oiBuSpqIrNqC-BRy1AYHTzCNPEgpDejLHQOcgz1yyQpKKNQHGN_M0uxdpBsjoGG5JSjiK_QUm7U4pp01Cz606ZodaeSJNz6-nh5mP1JKvQVmZimx4d3GB4yoW7WgRKHOBp0WN3lNLK_9aOBLHxm61m9zB2BLvmU_XCS5hKS_H3wRvQdlcxNjIhjsu7l-vA; _g=GA1.2.1533643988.1551348935; _hjIncludedInSample=1; _gat_UA-85972959-1=1; csrftoken=PzYbOQzkq3bNMTKzMp7UvsgOlcDcPEF0; sessionid=sm9yh597cptfrkx4h3hl2ou4wzopc6eo; __stripe_sid=d2117a6a-744e-44a9-b624-04e2a749032d; intercom-session-fvxq07yl=ZkV0Z3BTS3VLbngrSEJjQ2xVWVdBdVB6Ry9vZHorV1N1eE02L2VQbHk1VDQyRXFRQWprZ1JJa216R2JVbzE2Ry0tU1U5c0MyaWJMRG11N0pvd1dZWVpKQT09--84efbb5cb1bdd8cb8f23c66dfad21f987d405c40; _ga=GA1.2.1533643988.1551348935; __stripe_mid=a03694ae-9866-409a-add0-f178eaaccf0d; intercom-id-fvxq07yl=8125b2f6-73f2-4774-8e0e-2b2fbd49a335; REFERRER=; REFERRER=; _gid=GA1.2.1999392027.1552367089; csrftoken=PzYbOQzkq3bNMTKzMp7UvsgOlcDcPEF0; sessionid=sm9yh597cptfrkx4h3hl2ou4wzopc6eo; intercom-session-fvxq07yl=cVNWRGdtSlJ5QWhLbEZ2Y2VnUHF3d254djRRMndldFY1NW5zOXZrdXhQbmVkUWVOdlcvVmdQblE3VmZwTU11ei0tY3N0dGdmL3V3MW1WYi9mNXhkZU1RUT09--70e18a206a2856d278238880753174ca5c25912b',
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
    // TODO: implement initState
    super.initState();
    userToken1 = widget.userToken;
  }
  void _onAddCookies(BuildContext context) async {
    Map<String,String> cookie;
    cookie = {
      'domain': 'https://app.meetnotes.co',
      'cookieString': 'sessionid=sm9yh597cptfrkx4h3hl2ou4wzopc6eo; path="/"',
    };
    //cookieManager.addCookie(cookie);
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewTest(),
                  ));
            },
            leading: const Icon(Icons.group_work),
            title: new Text("Meetings"),
          ),
          new ListTile(
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WebView(
            //               initialUrl:
            //                   'https://app.meetnotes.co/m/59a915a5-a63a-4a96-9a38-a845eb560b2a/',
            //               javascriptMode: JavascriptMode.unrestricted,
            //               onWebViewCreated: (WebViewController wvc) {
            //                 //_onAddCookies(context);
            //                 wvc.evaluateJavascript('document.cookie = "sessionid=sm9yh597cptfrkx4h3hl2ou4wzopc6eo;');
            //                 //wvc.evaluateJavascript('window.location.href="www.google.com"');
            //               },
            //             ),  
            //       ));
            // },
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ));
            },
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
