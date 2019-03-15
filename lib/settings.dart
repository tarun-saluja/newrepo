import 'dart:io';
import 'package:memob/utilities.dart' as utilities;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Settings();
  }
}

class _Settings extends State<Settings> {
  bool dailyEmail;
  bool dailySlack;
  bool meetingReminder;
  bool meetingAgenda;
  bool meetingsFeedback;
  String name;
  String email;
  String userToken;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<Null> fetchData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
        fetchUserData();
      } else {
        utilities.showLongToast(value);
        return null;
      }
    });
  }

  Future<Null> fetchUserData() async {
    final response = await http.get(
        Uri.encodeFull('https://app.meetnotes.co/api/v2/settings/account/'),
        headers: {
          HttpHeaders.AUTHORIZATION: 'Token $userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache'
        });

    if (response.statusCode == 200) {
      this.setState(() {
        Map<String, dynamic> mData = json.decode(response.body);
        name = mData['user']['display_name'];
        email = mData['user']['email'];
        dailyEmail = mData["notification_settings"]["DAILY_SUMMARY"];
        dailySlack =
            mData["notification_settings"]["DAILY_SUMMARY_SLACK_REMINDER"];
        meetingReminder = mData["notification_settings"]["MEETING_REMINDER"];
        meetingAgenda =
            mData["notification_settings"]["MEETING_AGENDA_REMINDER"];
        meetingsFeedback =
            mData["notification_settings"]["DAILY_FEEDBACK_REMINDER"];
      });
      return null;
    } else {
      // If that response was not OK, throw an error.
      return null;
    }
  }

  Future<Null> settingsUpdate(Map body) async {
    var data = json.encode(body);
    var response =
        await http.post('https://app.meetnotes.co/api/v2/settings/account/',
            headers: {
              HttpHeaders.AUTHORIZATION: 'Token $userToken',
              HttpHeaders.CONTENT_TYPE: 'application/json',
              HttpHeaders.ACCEPT: 'application/json',
              HttpHeaders.CACHE_CONTROL: 'no-cache'
            },
            body: data);
    print("${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          child: ListView(
            children: <Widget>[
              Text('Name'),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: name,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              Text('Email'),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: email,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              CheckboxListTile(
                title: Text('Daily Summary via Email'),
                value: this.dailyEmail,
                onChanged: (bool val) {
                  this.setState(() {
                    dailyEmail = !dailyEmail;
                  });
                  Map body = {
                    "settings": {"DAILY_SUMMARY": dailyEmail}
                  };
                  settingsUpdate(body);
                },
              ),
              CheckboxListTile(
                title: Text('Daily Summary via Slack'),
                value: this.dailySlack,
                onChanged: (bool val) {
                  this.setState(() {
                    dailySlack = !dailySlack;
                  });
                  Map body = {
                    "settings": {"DAILY_SUMMARY_SLACK_REMINDER": dailySlack}
                  };
                  settingsUpdate(body);
                },
              ),
              CheckboxListTile(
                title: Text('Meeting Reminder'),
                value: this.meetingReminder,
                onChanged: (bool val) {
                  this.setState(() {
                    meetingReminder = !meetingReminder;
                  });
                  Map body = {
                    "settings": {"MEETING_REMINDER": meetingReminder}
                  };
                  settingsUpdate(body);
                },
              ),
              CheckboxListTile(
                title: Text('Meeting Agenda Reminder'),
                value: this.meetingAgenda,
                onChanged: (bool val) {
                  this.setState(() {
                    meetingAgenda = !meetingAgenda;
                  });
                  Map body = {
                    "settings": {"MEETING_AGENDA_REMINDER": meetingAgenda}
                  };
                  settingsUpdate(body);
                },
              ),
              CheckboxListTile(
                title: Text('Daily Meetings Feedback'),
                value: this.meetingsFeedback,
                onChanged: (bool val) {
                  this.setState(() {
                    meetingsFeedback = !meetingsFeedback;
                  });
                  Map body = {
                    "settings": {"DAILY_FEEDBACK_REMINDER": meetingsFeedback}
                  };
                  settingsUpdate(body);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
