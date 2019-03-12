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
      url: "https://app.meetnotes.co/m/fdc0dcd2-e836-46d9-aefc-39798594486f/?suppress_webview_warning=true",
      headers: {
          HttpHeaders.AUTHORIZATION: 'Token $_userToken',
          HttpHeaders.CONTENT_TYPE: 'application/json',
          HttpHeaders.ACCEPT: 'application/json',
          HttpHeaders.CACHE_CONTROL: 'no-cache',
          HttpHeaders.COOKIE: '_ga=GA1.2.161743977.1551343962; __stripe_mid=c11cd2d7-3222-47f0-be30-5a60140b1673; _hjIncludedInSample=1; IS_GENUINE=true; REFERRER=; REFERRER=; csrftoken=GkypxP7JUrey4s4J9vTTKEVlXbwmzoN1; sessionid=py2uz2dbg4sgaz462yw31d7yivx9ncnz; userId=6999674ac8a14e5c874e6c72563153b9; API_TOKEN=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiZGlwYW5zaHUua2Fwb29yQGhhc2hlZGluLmNvbSIsInV1aWQiOiI2OTk5Njc0YWM4YTE0ZTVjODc0ZTZjNzI1NjMxNTNiOSJ9.ZG1tNM1QMOgrf8JZfg6u5WhhBB68HuzPsVKRiHmvQGh-FaqCYbKPjXlx6JYsfJ7oweQ1dTsBWBR2GtD0xtu1oh0hRdutJJ9nSiwdJ5TlaLO2j5b54g1Y697PeSLaFUAa5yS61JY4lAlh1rmpDb4F6mIpiU69vucDt0FQAvjwNf2_shFRhnb_iaf6a1Zk4i7mRDXmIs4ZRYQNxXe-2_TAoBEvlot4XKRT-p0l_lZ67mPyx9TomnTKzu9xY5pZU6Q07FpfXU0SEaV16fivBov114fFtMel1l8jFfSVGWw-0oOkjzQ_UIS6nkcDNbNl0pwlwb1Q8IXpJQj49XGLJinLZw; _gid=GA1.2.392089721.1552277681; __stripe_sid=1b3f20fa-544c-402b-b56d-e1d85ec8b006; _gat_UA-85972959-1=1'
        }
    );
  }

}