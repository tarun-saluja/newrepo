import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'package:memob/NotesClass.dart';
import 'package:memob/meetingClass.dart';
import 'package:memob/utilities.dart' as utilities;

import './allMeetings.dart';
import './api_service.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memob/Detail.dart';
import 'package:path/path.dart' as p;
import 'package:open_file/open_file.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

final detail = new Detail();
var m = kAndroidUserAgent;
class Download extends StatefulWidget {
  static final Download _dashboard = new Download._private();

  Download._private();

  factory Download() {
    return _dashboard;
  }

  @override
  State<StatefulWidget> createState() {
    return _DownloadState();
  }
}

class _DownloadState extends State<Download> {
  String userToken;
  String _displayName;
  String _profilepicture;
  bool _connectionStatus = false;
  final Connectivity _connectivity = new Connectivity();

  List<MeetingClass> _meetings = new List();
  List<NotesClass> _notes = new List();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return new MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Flutter File Manager Demo"),
          ),
          body:
//          Container(
//            child: RaisedButton(
//              onPressed: _open,
//              child:Text('Press Me'),
//            )
//          )));
          FutureBuilder(
            future: _files(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('Press button to start.');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('Awaiting result...');
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  return snapshot.data != null
                      ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].absolute.path),
                            subtitle: Text(
                                "Extension: ${p.extension(snapshot.data[index].absolute.path).replaceFirst('.', '')}"), // getting extension
                          )))
                      : Center(
                    child: Text("Nothing!"),
                  );
              }
              return null; // unreachable
            },
          )
      ),
    );
  }
  _open() async{
    OpenFile.open("/data/user/0/com.exmaple.memob/app_flutter/Pictures/flutter_test/Image_1555828980452.jpg");
  }
  _files() async {
    var root = (await  getApplicationDocumentsDirectory());
    print(root);
    var fm = FileManager(root: root);
    var files = await fm.filesTree();
    return files;
  }

  var api = new API_Service();

  @override
  initState() {
    super.initState();
    flutterWebviewPlugin.close();
  }
}
