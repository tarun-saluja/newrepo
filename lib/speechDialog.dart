import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:memob/uploadAttachment.dart' as UploadAttachment;
import 'package:memob/utilities.dart' as utilities;
import 'package:memob/Detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:speech_recognition/speech_recognition.dart';

class Speech extends StatefulWidget {
  final String meetingUuid;

  @override
  _MyAppState createState() => new _MyAppState();

  Speech(this.meetingUuid);
}

class _MyAppState extends State<Speech> {
  String _platformVersion = 'Unknown';

  //Permission permission;
  String userToken;
  SpeechRecognition _speech;

  String textFilePath;

  bool _speechRecognitionAvailable = true;
  bool _isListening = true;
  bool isstop=false;

  String transcription = '';
  String lastWord = '';
  int lastwordindex = 0;

  String _currentLocale = 'en_US';

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    fetchData();
    checkPermission();
    getPermissionStatus();
  }
  Future<Null> _goback() {
    flutterWebviewPlugin.show();
    Navigator.pop(context);
//    Navigator.popUntil(context, ModalRoute.withName('Detail'));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  Future<String> get _localPath async {
    String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Text/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/Document_${timestamp()}.txt';
    return filePath;
  }

  Future<File> _localFile() async {
    final path = await _localPath;
    return File(path);
  }

  Future<File> writeToFile() async {
    final file = await _localFile();
    // Write the file
    return file.writeAsString(transcription);
  }

  Future<Null> fetchData() async {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        userToken = value;
      } else {
        utilities.showLongToast(value);
      }
    });
  }

  bool visibilitylisten = true;
  bool visibilitystop = false;
  bool visibilitySelectOption = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "listen") {
        visibilitylisten = visibility;
      }
      if (field == "stop") {
        visibilitystop = visibility;
      }
      if (field == "selectoption") {
        visibilitySelectOption = visibility;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return new WillPopScope(
        onWillPop: _goback,
        child: Column(
        children: [
          Container(
              transform: Matrix4.translationValues(0.0, 45.0, 20.0),
            child:
      CupertinoAlertDialog(
        content: new Container(
          child: new Container(
            child: new Padding(
                padding: new EdgeInsets.all(1.0),
                child: new Center(
                  child: new Column(
                    children: [
                      new Container(child: new Text(transcription)),
                    ],
                  ),
                )),
          ),
          height: height * 0.55,
        ),
        actions: <Widget>[
          visibilitystop?
          Center(
           child: Padding(
             padding: const EdgeInsets.only(bottom:35.0),
             child: Text('Listening...', style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Color(0XFFBCC4D1)),),
           ),
          ):Container()
        ],
      )),
      Container(
          child: Padding(
              padding: EdgeInsets.only(left: height*.07, bottom: 8.0),
              child: Container(
                child: Row(children: [
                  visibilitySelectOption
                      ? Container(
                        transform: Matrix4.translationValues(0.0, -20.0, 20.0),
                          child: FlatButton(
                            padding:
                                const EdgeInsets.fromLTRB(0.0, 4.5, 0.0, 0.0),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              flutterWebviewPlugin.show();
                              writeToFile().then((file) {
                                UploadAttachment.uploadAttachment(
                                    userToken, file.path, widget.meetingUuid);
                                utilities.showLongToast(
                                    'Transcription saved successfully..!');
                              });
                            },
                            child: new Image.asset(
                              'assets/tick.png',
                              fit: BoxFit.cover,
                              height: 100,
                              width: 80,
                            ),
                          ),
                        )
                      : Container(),
//                          height:
//                          width: 70,
//                      child:FlatButton(
//                          onPressed: () {
//                            Navigator.of(context, rootNavigator: true).pop();
//                            writeToFile().then((file) {
//                              UploadAttachment.uploadAttachment(
//                                  userToken, file.path, widget.meetingUuid);
//                              utilities.showLongToast(
//                                  'Transcription saved successfully..!');
//                            });
//                          },
//                          child: Padding(
//                            padding: const EdgeInsets.only(bottom: 60.0),
//                            child: new Icon(
//                              Icons.done,
//                              color: Colors.green,
//                            ),
//                          ))
                  visibilitystop
                      ? Padding(
                          padding:  EdgeInsets.only(left: height*.159),
                          child: Container(
//                            transform:
//                                Matrix4.translationValues(0.0, -45.0, 20.0),
//                            margin: EdgeInsets.only(bottom: 2000.0),
                            width: 60.0,
                            height: 60.0,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              border: new Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: Container(
                                child: FlatButton(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.0),
                              onPressed: stop,
                              child: new Image.asset(
                                'assets/stop.png',
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                              ),
                            )),
                          ),
                        )
                      : Container(),
                  visibilitylisten
                      ? Padding(
                          padding: EdgeInsets.only(left: height*.159),
                          child: Container(
//                            transform:
//                                Matrix4.translationValues(0.0, -45.0, 20.0),
//                            margin: EdgeInsets.only(bottom: 2000.0),
                            width: 60.0,
                            height: 60.0,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: new Border.all(
                                width: 1.0,
                                color: Colors.black,
                              ),
                            ),
                            child: Container(
                                child: FlatButton(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 4.5, 0.0, 0.0),
                              onPressed: start,
                              child: new Image.asset(
                                'assets/start.png',
                                fit: BoxFit.cover,
                                height: 70,
                                width: 70,
                              ),
                            )),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 110.0),
                    child: visibilitySelectOption
                        ? Container(
                      transform: Matrix4.translationValues(0.0, -20.0, 20.0),
                            child: FlatButton(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 4.5, 0.0, 0.0),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                flutterWebviewPlugin.show();
                              },
                              child: new Image.asset(
                                'assets/cross.png',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 70,
                              ),
                            ),
                          )
                        : Container(),
                  ),
//                      ? new FlatButton(
//                          onPressed: () {
//                            Navigator.of(context, rootNavigator: true).pop();
//                          },
//                          child: Padding(
//                            padding:
//                                const EdgeInsets.only(bottom: 55.0, left: 140),
//                            child: new Icon(
//                              Icons.close,
//                              color: Colors.red,
//                            ),
//                          ))
//                      : new Container()
                ]),
              ))),
    ]));
  }



  void start() => {
    print('inside start'),
        _changed(true, 'stop'),
        _changed(false, 'listen'),
        _changed(false, 'selectoption'),
        _speech
            .listen(locale: _currentLocale)

      };

  void stop() => {
  print('inside stop'),
  isstop = true,
  _changed(true, 'selectoption'),
        _changed(false, 'stop'),
        _changed(false, 'listen'),
        lastwordindex = 0,
        _speech.stop().then((result) => setState(() => _isListening = false)),
      };

  void onSpeechAvailability(bool result) =>
      {    print('inside onSpeechAvailability'),
      setState(() => _speechRecognitionAvailable = true)};

  void onCurrentLocale(String locale) =>
  {
  setState(() => _currentLocale = locale)
};
  void onRecognitionStarted() => {
  print('inside onRecognitionStarted'),

  lastwordindex = 0,
        setState(() => _isListening = true)
      };

  void onRecognitionResult(String text) => {
  print('inside onRecognitionResult'),

  lastWord = text.substring(lastwordindex, text.length),
        print(lastWord),
        setState(() => transcription += lastWord),
        lastwordindex = text.length,
      };

  void onRecognitionComplete() async=>
      {     await Future.delayed(const Duration(seconds: 6), (){}),
      isstop ?_speech.stop():
  _speech
      .listen(locale: _currentLocale),
      setState(() => _isListening = true)};
}

void requestPermission() async {
  final res = await SimplePermissions.requestPermission(Permission.RecordAudio);
}

Future<bool> checkPermission() async {
  bool res = await SimplePermissions.checkPermission(Permission.RecordAudio);
  return res;
}

void getPermissionStatus() async {
  final res =
      await SimplePermissions.getPermissionStatus(Permission.RecordAudio);
}
