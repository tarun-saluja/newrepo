import 'package:flutter/material.dart';


class Detail extends StatelessWidget {
  final String uuid;

  Detail({Key key, @required this.uuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(this.uuid),
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
}
