import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import './cancelbutton.dart';
import './sendbutton.dart';
import './drawer.dart';

final ThemeData iOSTheme = new ThemeData(
  primarySwatch: Colors.red,
  primaryColor: Colors.grey[400],
  primaryColorBrightness: Brightness.dark,
);

final ThemeData androidTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.green,
);

const String defaultUserName = "User";

// class MyChat extends StatelessWidget {
//   @override
//   Widget build(BuildContext ctx) {
//     return new MaterialApp(
//       title: "",
//       theme: defaultTargetPlatform == TargetPlatform.iOS
//         ? iOSTheme
//         : androidTheme,
//       home: new Chat(),
//     );
//   }
// }

class Share extends StatefulWidget {
  final String meetingTitle;
  final String meetingBody;
  final List<String> asigneeEmail;

  Share([this.meetingTitle, this.meetingBody, this.asigneeEmail]);

  // @override
  // State createState() => ShareWindow();

  @override
  State<StatefulWidget> createState() {
    return ShareWindow();
  }
}

class ShareWindow extends State<Share> with TickerProviderStateMixin {
  final List<Msg> _messages = <Msg>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isWriting = false;
  // String _meetingTitle;
  // String _meetingBody;

@override
  void initState() {
    super.initState();
    _initAdd();
  }
  @override
  Widget build(BuildContext ctx) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("MeetNotes"),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: new Dwidget(),
      body: new Column(children: <Widget>[
        new Divider(),
        new Container(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                CancelButton(onPressed: () {
                  Navigator.pop(context);
                }),
                Text(
                  "Share Notes",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SendButton(
                  onPressed: () async {
                    String _mail='';
                    
                    for (Msg temp in _messages)
                    {
                       _mail+=temp.txt + ',';
                    }
                    final url =
                        'mailto:$_mail?subject=${widget.meetingTitle}&body=${widget.meetingBody}%20plugin';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ]),
        ),
        new Divider(
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("All Attendees"),
            Text("Only Me"),
            Text("Domain"),
          ],
        ),
        new Divider(
          color: Colors.black,
        ),
        new Flexible(
            child: new ListView.builder(
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
          reverse: true,
          padding: new EdgeInsets.all(6.0),
        )),
        new Divider(height: 1.0),
        new Container(
          child: _buildComposer(),
          decoration: new BoxDecoration(color: Theme.of(ctx).cardColor),
        ),
      ]),
    );
  }

  Widget _buildComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Add email to invite"),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          child: new Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : new IconButton(
                          icon: new Icon(Icons.add),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(top: new BorderSide(color: Colors.brown)))
              : null),
    );
  }
  //  _sendEmail(String meetingTitle,String meetingBody)
  // {

  // }
  // _launchEmailApp() async {
  //   const url = 'mailto:smith@example.org?subject=News&body=New%20plugin';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  void _initAdd()
  {
    for(String temp in widget.asigneeEmail)
    _submitMsg(temp);
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });
    Msg msg = new Msg(
      txt: txt,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 800)),
    );
    setState(() {
      _messages.insert(0, msg);
    });
    msg.animationController.forward();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }
    super.dispose();
  }
}

class Msg extends StatelessWidget {
  Msg({this.txt, this.animationController});
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 18.0),
              child: new CircleAvatar(child: new Text("@")),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(top: 11.0),
                    child: new Text(txt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
