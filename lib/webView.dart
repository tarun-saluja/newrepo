import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class WebView extends StatefulWidget {
  String meetingUuid;
  String userToken;
  WebView([this.meetingUuid, this.userToken]);
  @override
  State<StatefulWidget> createState() {
    return _WebView();
  }

}

class _WebView extends State<WebView> {

  String _meetingUuid;
  String _userToken;

  @override
  void initState() {
    _userToken = widget.userToken;
    _meetingUuid = widget.meetingUuid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://app.meetnotes.co/m/fdc0dcd2-e836-46d9-aefc-39798594486f/",
      headers: {'sessionid':'py2uz2dbg4sgaz462yw31d7yivx9ncnz;',
          // HttpHeaders.AUTHORIZATION: 'Token $_userToken',
          // HttpHeaders.CONTENT_TYPE: 'application/json',
          // HttpHeaders.ACCEPT: 'application/json',
          // HttpHeaders.CACHE_CONTROL: 'no-cache',sess
          //HttpHeaders.COOKIE: 'sessionid=py2uz2dbg4sgaz462yw31d7yivx9ncnz; path="/"',        
          }
    );
  }

}