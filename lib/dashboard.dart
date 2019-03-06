import 'package:flutter/material.dart';
import 'package:memob/searchbar.dart';

import './recentlyUpdated.dart';
import './allMeetings.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Dashboard'),
              actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
              bottom: TabBar(
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(
                    text: "Meetings",
                  ),
                  Tab(
                    text: "Recent Notes",
                  )
                ],
              ),
            ),
            drawer: Drawer(),
            body: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: AssetImage('assets/art.jpg'), fit: BoxFit.cover),
              ),
              child: TabBarView(
                children: <Widget>[
                  AllMeetings(),
                  RecentlyUpdated(),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            )),
      ),
    );
  }
}
