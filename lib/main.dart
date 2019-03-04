import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.amber),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Drawer App"),
        elevation: defaultTargetPlatform == TargetPlatform.android?5.0:0.0,
      ),
      drawer:new Drawer(
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
            new Divider(),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Dashboard"),
            ),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Meetings"),
            ),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Notes"),
            ),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Action Items"),
            ),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Team"),

            ),
            new Divider(),
            new ListTile(
              leading: const Icon(Icons.dashboard),
              title: new Text("Team"),

            ),
          ],
        ),
      ),
      body: new Container(
        child: new Center(
          child: new Text("HomePage"),
        ),
      ),
    );
  }
}
