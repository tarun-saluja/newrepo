import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './cancelbutton.dart';
import './sendbutton.dart';
import './drawer.dart';
import './utilities.dart';

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
  final String rawHtml;
  final String delta;
  final String meetingUuid;

  Share(
      [this.meetingTitle,
      this.meetingBody,
      this.asigneeEmail,
      this.rawHtml,
      this.delta,
      this.meetingUuid]);

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
  String userToken;
  Map body;
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
                    String _mail = '';

                    for (Msg temp in _messages) {
                      _mail += temp.txt + ',';
                    }
                     postData(body);
                    
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
                  decoration:
                      new InputDecoration.collapsed(hintText: "Add email"),
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
  void _initAdd() {
    for (String temp in widget.asigneeEmail) _submitMsg(temp);
    print(widget.rawHtml);
    print(widget.delta);
    body = {
      'type': "Email",
      'mailRecipients': ["athar.ejaz@hashedin.com"],
      'rawHTML': "${widget.rawHtml}",
      'delta':"${widget.delta}"
    };
  }

  // Future postData() async {
  //   Response response;
  //   Dio dio = new Dio();
  //   Future<String> userToken =getTokenData();
  //   dynamic url =
  //       "https://app.meetnotes.co/api/v2/meeting/${widget.meetingUuid}/share/";
  //   try {
  //     response = await dio.post(url, data: {
  //       "type": "EMAIL",
  //       "mailRecipients": ["athar.ejaz@hashedin.com"],
  //       "rawHTML": widget.rawHtml,
  //       "delta": widget.delta
  //     },
  //     options: Options(headers: {
  //       "Authorization" : 'Token $userToken',
  //       "Content-Type": "multipart/form-data",

  //     }));
  //   } catch (e) {
  //     print("Error Upload: " + e.toString());
  //   }
  //   print("Response Upload:" + response.toString());
  // }

  Future<Null> postData(Map body) async{
    print(body);
    Future<String> token = getTokenData(); 
    dynamic url ="https://app.meetnotes.co/api/v2/meeting/${widget.meetingUuid}/share/";
    token.then((value) {
      if (value != null) {
        userToken = value;
        sendEmail(url,body);
      } else {
        showLongToast(value);
        return null;
      }
    });

    return null;
  }

  Future<Null> sendEmail(String url, Map body) async{
    var data = json.encode(body);
    print(data);
    var response = await http.post(url, 
    headers: {
      HttpHeaders.AUTHORIZATION: 'Token $userToken',
      HttpHeaders.CONTENT_TYPE: 'application/json;charset=UTF-8',
      HttpHeaders.ACCEPT: 'application/json, text/plain, */*',
      HttpHeaders.CACHE_CONTROL: 'no-cache',
      //HttpHeaders.acceptCharsetHeader: 'charset=utf-8'
    },
    
      body: '{"type":"EMAIL","mailRecipients":["athar.ejaz@hashedin.com"],"rawHTML":"<div><h2>GOALS</h2><input type=\"checkbox\" None disabled/> <span> </span><br></div><br/><p><br></p><p><span style=\"color: #1895ff\">@dipanshu.kapoor</span> </p><p><span style=\"color: #1895ff\">@kuma</span></p><p>We are glad to see you onboard! &nbsp;Your meetings are about to become fun, engaging and effective.</p><p>Here are a few tips to help you get started.</p><h2>No Agenda-No Meeting-No Exceptions</h2><p><br></p><p>All successful meetings have one thing in common -an agenda. Get your list of Agenda items or Goals ready for your meeting. Mark them as done as you go through the meeting. No one can derail your meeting now!</p><p>Just, click on the Agenda button on the left Menu.</p><p><br></p><p><br></p><p><br></p><h2>Add Some Action to Your Meeting</h2><p>You can assign action items to meeting attendees. Let me make some for you</p><p><br></p><p><span style=\"color: #1895ff\">@athar.ejaz</span> try out agenda on the left menu of the meeting. <span style=\"color: #1895ff\">#onboarding</span></p><p><span style=\"color: #1895ff\">@athar.ejaz</span> create an action item for yourself #today</p><p><br></p><p>To update status of action item, go to the right menu. There is a ton of features in the right menu, Explore them right now..Also, do not forget to check out the other widgets on the left menu.</p><p><br></p><h2>MeetNotes Plays Well with Your Work Apps</h2><p>MeetNotes works well with many of your existing work apps. We can remind you to set the agenda before the meeting, just in case you forget. Check out all the integration <a href=https://app.meetnotes.co/settings/integrations/all/>here</a>.</p><p><br></p><h2>Team Makes it All Better</h2><p>MeetNotes is built for high performing teams, so get your team over to MeetNotes, if you have not already. It easy to set up your team, add custom tags and meeting templates for your team. &nbsp;Just head over to the <a href=https://app.meetnotes.co/settings/teams/general/>settings page</a> to manage your team.</p><p><br></p><h2>Reach Out to Us</h2><p>If you need help, we are just a chat away. Just click on the chat icon at the lower corner of the screen. You can also check out our Getting Started section in our <a href=http://docs.meetnotes.co/>help center</a></p>","delta":{"ops":[{"insert":" "},{"attributes":{"agenda-item":"unchecked"},"insert":"\n"},{"insert":"\n"},{"attributes":{"tag":"8104"},"insert":"@dipanshu.kapoor"},{"insert":" "},{"attributes":{"actionItem":"7a35cc88-30ed-4baa-9559-4dffb6f970dd"},"insert":"\n"},{"insert":"@kuma","attributes":{"tag":"true"}},{"insert":"\n","attributes":{"actionItem":"6e80b2e0-5cf8-4e9e-bf01-0bcd2a4a48f2"}},{"insert":"We are glad to see you onboard!  Your meetings are about to become fun, engaging and effective.","attributes":{"color":"#000000"}},{"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"Here are a few tips to help you get started."},{"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"No Agenda-No Meeting-No Exceptions"},{"attributes":{"header":2},"insert":"\n"},{"attributes":{"height":"192","width":"624","color":"#000000"},"insert":{"image":"https://lh3.googleusercontent.com/Mj6y1Y9UCg5BAQOBeZTodW4aUkA7ljO8E30PBDItbfaScFxHfTqyvn5bFvCtJEvhMosgTVay0GGjInBppVI9yvshqEzqbxm1-Pp6aCgYbJRLA-EYMvb0LpEXbZ81wxaVURHCud_0"}},{"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"All successful meetings have one thing in common -an agenda. Get your list of Agenda items or Goals ready for your meeting. Mark them as done as you go through the meeting. No one can derail your meeting now!"},{"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"Just, click on the Agenda button on the left Menu."},{"insert":"\n"},{"attributes":{"height":"86","width":"86","color":"#000000"},"insert":{"image":"https://lh6.googleusercontent.com/z32ILLLB-Vqj47B_-SKvYl6O__dzE2pkY1whQlfdRF8-1Z7sqt6yqGNu6uQ8k-iOLlTNonQLRyKMqcwjs7mu0RaKFhrcV9iFeUPU8w3x8FnaZhNoBsDMc34FdZk4BEO6YajPpsYv"}},{"insert":"\n\n\n"},{"attributes":{"color":"#000000"},"insert":"Add Some Action to Your Meeting"},{"attributes":{"header":2},"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"You can assign action items to meeting attendees. Let me make some for you"},{"insert":"\n\n"},{"attributes":{"color":"#000000","tag":"true"},"insert":"@athar.ejaz"},{"attributes":{"color":"#000000"},"insert":" try out agenda on the left menu of the meeting. "},{"attributes":{"color":"#000000","tag":"true"},"insert":"#onboarding"},{"attributes":{"actionItem":"7a4d7634-2f07-4934-a134-75e7dc5b6cf1"},"insert":"\n"},{"attributes":{"color":"#000000","tag":"true"},"insert":"@athar.ejaz"},{"attributes":{"color":"#000000"},"insert":" create an action item for yourself "},{"attributes":{"tagDate":true,"color":"#000000"},"insert":"#today"},{"attributes":{"actionItem":"34ae511e-dfd9-48ba-8489-f0ee121ba3a7"},"insert":"\n"},{"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"To update status of action item, go to the right menu. There is a ton of features in the right menu, Explore them right now..Also, do not forget to check out the other widgets on the left menu."},{"insert":"\n\n"},{"attributes":{"color":"#000000"},"insert":"MeetNotes Plays Well with Your Work Apps"},{"attributes":{"header":2},"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"MeetNotes works well with many of your existing work apps. We can remind you to set the agenda before the meeting, just in case you forget. Check out all the integration "},{"attributes":{"color":"#000000","link":"https://app.meetnotes.co/settings/integrations/all/"},"insert":"here"},{"insert":".\n\n"},{"attributes":{"color":"#000000"},"insert":"Team Makes it All Better"},{"attributes":{"header":2},"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"MeetNotes is built for high performing teams, so get your team over to MeetNotes, if you have not already. It easy to set up your team, add custom tags and meeting templates for your team.  Just head over to the "},{"attributes":{"color":"#000000","link":"https://app.meetnotes.co/settings/teams/general/"},"insert":"settings page"},{"attributes":{"color":"#000000"},"insert":" to manage your team."},{"insert":"\n\n"},{"attributes":{"color":"#000000"},"insert":"Reach Out to Us"},{"attributes":{"header":2},"insert":"\n"},{"attributes":{"color":"#000000"},"insert":"If you need help, we are just a chat away. Just click on the chat icon at the lower corner of the screen. You can also check out our Getting Started section in our "},{"attributes":{"color":"#000000","link":"http://docs.meetnotes.co/"},"insert":"help center"},{"insert":"\n"}]}}'); 

    print(response.statusCode);
    print("${response.body}");
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
