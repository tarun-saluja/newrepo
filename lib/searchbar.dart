import 'package:flutter/material.dart';
import 'package:memob/NotesClass.dart';

class SearchBar  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search App'),
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {
          //         showSearch(context: context, delegate: DataSearch());
          //       })
          // ],
        ),
        drawer: Drawer(),
    );
  }
}
class DataSearch extends SearchDelegate<String> {
  List<NotesClass> _notes;
  DataSearch([this._notes]);
  
  List<String> names = new List();

  final recentNames = [];

  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    names=new List();
    for (var i = 0; i < _notes.length; i++) {
      names.add(_notes[i].meetingTitle.toString());
      }
    final suggestionList = query.isEmpty ? recentNames : names.where((p)=>p.contains(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
            leading: Icon(Icons.location_city),
            title: Text(suggestionList[index]),
          ),
      itemCount: suggestionList.length,
    );
  }
}