import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memob/utilities.dart' as utilities;
import 'dart:async';
import 'dart:convert';
//import 'package:http/http.dart' as http;

class Dwidget extends StatelessWidget {
  List data;

  // Future<String> getData() async {
  //   var response = await http.get(
  //       Uri.encodeFull("https://jsonplaceholder.typicode.com/posts"),
  //       headers: {"Accept": "application/json"});
  //   data = jsonDecode(response.body);
  //   print(data[1]["title"]);

  //   return "Success!";
  // }
  // @override
  // void initState()
  // {
  //   this.getData();
  // }
  // new ListView.builder(
  //               itemCount: data == null ? 0:data.length,
  //               itemBuilder: (BuildContext context, int index){

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
            leading: const Icon(Icons.call_to_action),
            title: new Text("Action Items"),
          ),
          new Divider(),
          new ExpansionTile(
            leading: const Icon(Icons.group),
            title: new Text("Team"),
            children: <Widget>[Text("children 1"), Text("children 2")],
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("Settings"),
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("User"),
          ),
          new ListTile(
            leading: const Icon(Icons.call_to_action),
            title: new Text("Logout"),
            onTap: () async{

                utilities.removeToken().then((result){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Login', (Route<dynamic> route) => false);
                });

                },
          ),
        ],
      ),
    );
  }
}
