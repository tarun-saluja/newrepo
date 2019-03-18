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
  Dwidget([this.userToken]);
  @override
  State<StatefulWidget> createState() {
    return _DwidgetState();
  }
}

class _DwidgetState extends State<Dwidget> {
  String userToken1;
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
            // onTap: () async {
            //   String url =
            //       "https://app.meetnotes.co/m/59a915a5-a63a-4a96-9a38-a845eb560b2a/";
            //   //CookieManager.setCookie(url, 'sessionid', '1etsh16q7x3hpl5en89nszcgsfnt00j6;');
            //   await inAppBrowser.open(
            //       url:
            //           "https://app.meetnotes.co/m/59a915a5-a63a-4a96-9a38-a845eb560b2a/",
            //       options: {
            //         "useShouldOverrideUrlLoading": true,
            //         "useOnLoadResource": true,
            //         "hideTitleBar": false,
            //       });
            // },
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WebviewTest(),
            //       ));
            // },
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
            //                 wvc.evaluateJavascript('document.cookie = "sessionid=1etsh16q7x3hpl5en89nszcgsfnt00j6;');
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
