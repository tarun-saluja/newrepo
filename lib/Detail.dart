import 'package:flutter/material.dart';

import './share.dart';

class Detail extends StatefulWidget {
  final String uuid;

  Detail({Key key, @required this.uuid}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _DetailState();
  }
}

class _DetailState extends State<Detail> {
  String _uuid;

  @override
  void initState() {
    if (widget.uuid != null) {
      _uuid = widget.uuid;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(this._uuid),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context){
              return Constants.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      border: Border.all(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Text(
                    'Date Time'
                    ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(
                      color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () {
                        showDialog(
                          context: context,
                        );
                      },
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          new Icon(
                            Icons.attach_file,
                            color: Colors.amber,
                          ),
                          Text('2')
                        ],
                      ),
                  ),
                  )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            margin: new EdgeInsets.all(10.0),
            height: height * 0.60,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white70,
              border: Border.all(color: Colors.blue, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(color: Colors.white70,
                blurRadius: 10.0,
                spreadRadius: 1.0),
              ]
            ),
            child: ListView(
              children: <Widget>[
                Text('noteText',style: TextStyle(fontSize: 18.0, color: Colors.black),),
              ],
            ),
          )
        ],
      ),
    );
  }
  void choiceAction(String choice)
  {
    if (choice==Constants.Share)
    {
      Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new Share(),
              ));
    }
    else
    print("sign out");

  }
}

class Constants{
  static const String Share = 'Share';
  static const String Leave = 'Leave';

  static const List<String> choices = <String>[
    Share,
    Leave,
  ];
}

// class Choice {
//   const Choice({this.title, this.icon});

//   final String title;
//   final IconData icon;
// }

// const List<Choice> choices = const <Choice>[
//   const Choice(title: 'Car', icon: Icons.directions_car),
//   const Choice(title: 'Bicycle', icon: Icons.directions_bike),
//   const Choice(title: 'Boat', icon: Icons.directions_boat),
//   const Choice(title: 'Bus', icon: Icons.directions_bus),
//   const Choice(title: 'Train', icon: Icons.directions_railway),
//   const Choice(title: 'Walk', icon: Icons.directions_walk),
// ];

// class ChoiceCard extends StatelessWidget {
//   const ChoiceCard({Key key, this.choice}) : super(key: key);

//   final Choice choice;

//   @override
//   Widget build(BuildContext context) {
//     final TextStyle textStyle = Theme.of(context).textTheme.display1;
//     return Card(
//       color: Colors.white,
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(choice.icon, size: 128.0, color: textStyle.color),
//             Text(choice.title, style: textStyle),
//           ],
//         ),
//       ),
//     );
//   }
// }
