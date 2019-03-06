import 'package:flutter/material.dart';

import './recentlyUpdated.dart';
import './allMeetings.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        bottom: TabBar(
          indicatorColor: Colors.blue,
          tabs: [
            Tab(text: "Meetings",),
            Tab(text: "Recent Notes",)
          ],
          
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage('assets/art.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: TabBarView(
          children: <Widget>[
            AllMeetings(),
            RecentlyUpdated(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
      )
    ),
    );
  }
}
