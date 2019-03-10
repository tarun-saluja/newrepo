import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/utilities.dart' as utilities;

//import 'package:http/http.dart' as http;

class Dwidget extends StatelessWidget {
  List data;
  List<Widget> teams_data = [Text('hello'),Text('hashedin')];


  //   Map<String, dynamic> mData = json.decode(response.body);
  //   List<dynamic> list = mData["results"];
  //   for (var teamData in list) {
  //     TeamClass team = new TeamClass(teamData['name']);
  //     teamNames.add(team);
  //   }
  //   return teamNames;
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   userToken1 = widget.userToken;
  // }

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
          new Divider(),
          new ExpansionTile(
            leading: const Icon(Icons.group),
            title: new Text("Team"),
            //children: <Widget>[Text("children 1"), Text("children 2")],
            children: teams_data,
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

  // Widget _buildTeamNames(BuildContext context, int index) {
  //   if(teamNames.length==0)
  //     return Center(child: CircularProgressIndicator());
  //   else{
  //     return ExpansionTile(
  //     title: Text("Teams"),
  //      children: <Widget>[
  //           Text(teamNames[index].name, style: TextStyle(color: Colors.black),)
  //         ],
  //     );
  //   }
    
  // }
}
