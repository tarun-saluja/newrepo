import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import './constants.dart';

enum UniLinksType { string, uri }

class Login extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Login> with SingleTickerProviderStateMixin {
  String _latestLink = '$UNKNOWN';
  Uri _latestUri;

  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;

  String token;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double x = 20;
//    print(height);
//    print(width);

    final Shader linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end:Alignment.bottomRight,
      colors: <Color>[Color(0XFF2BE7FA), Color(0XFF6450f6)],
    ).createShader(Rect.fromLTWH(50.0, 50.0, 200.0, 10.0));

    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 34, 51, 1),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(
              "assets/signup_bg.png",
            ),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(screenWidth * 0.1,
                    screenHeight * 0.35, screenWidth * 0.15, 0),

                child: Text('$NAME',
                    style: TextStyle(
                      fontSize: screenHeight*.06,
                      fontFamily: 'Roboto Thin',
//                            color: Color.fromRGBO(255, 255, 255, 0.8),
                      foreground: Paint()..shader = linearGradient,
                    )),
              ),
              Container(
                height: screenHeight*0.075,
                margin: EdgeInsets.fromLTRB(
                    screenWidth * 0.1, screenHeight*.04, screenWidth * 0.183, 0),
                child: RaisedButton.icon(
                  color: Color(0XFFF6F8FB),
                  onPressed: _launchLoginUrl,
                  icon: Image.asset(
                    'assets/google.png',
                    height: 39,
                    width: 38,
                  ),
                  label: Text('$GOOGLE',
                      style: TextStyle(
                        fontSize: screenHeight*0.025,
                        fontFamily: 'Roboto',
                      )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    screenWidth * 0.1, screenHeight*.025, screenWidth * 0.183, 15),
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 1.0,
                      width: 72,
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'OR',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.2),
                              fontSize: 15.0,
                              fontFamily: 'Roboto'),
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 1.0,
                      width: 72,
                      color: Color.fromRGBO(255, 255, 255, 0.2),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(''),
                  ),
                ]),
              ),
              Container(
                  height: screenHeight*0.065,
                  margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.1, screenHeight*.001, screenWidth * 0.182, 0),
                  child: Row(children: [
                    Expanded(
                      flex: 8,
                      child: Container(
//                         height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(0.8, 0.0),
                            // 10% of the width, so there are ten blinds.
                            colors: [
                              Color(0XFF0099B5),
                              Color(0XFF00B55E)
                            ], // whitish to gray
//                          tileMode: TileMode.clamp, // repeats the gradient over the canvas
                          ),
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(30),
                            topRight: const Radius.circular(30.0),
                            bottomLeft: const Radius.circular(30),
                            bottomRight: const Radius.circular(30),
                          ),
                        ),
                        child: new RaisedButton.icon(
                            elevation: 0,
                            color: Colors.transparent,
                            onPressed: _launchLoginUrlSlack,
                            icon: new Image.asset(
                              'assets/slack.png',
                              height: 20,
                              width: 20,
                            ),
                            label: new Text('$SLACK',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                  fontSize: screenHeight*.022,
                                )),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(40))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(''),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
//                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment(0.8, 0.0),
                              // 10% of the width, so there are ten blinds.
                              colors: [
                                Color(0XFFE15029),
                                Color(0XFFD8384F),
                              ], // whitish to gray
//                          tileMode: TileMode.clamp, // repeats the gradient over the canvas
                            ),
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(30),
                              topRight: const Radius.circular(30.0),
                              bottomLeft: const Radius.circular(30),
                              bottomRight: const Radius.circular(30),
                            ),
                          ),
                          child: new RaisedButton.icon(
                              elevation: 0,
                              color: Colors.transparent,
                              onPressed: _launchLoginUrlOffice,
                              icon: new Image.asset(
                                'assets/office_365.png',
                                height: 20,
                                width: 20,
                              ),
                              label: new Text('$OFFICE',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight*.022,
                                      fontFamily: 'Roboto')),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(40))),
                        ),
                      ),
                    ),

                  ])),
              Container(
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('version 0.0.1', style:
                        TextStyle(color: Color(0XFF5A6278),fontSize:15,fontFamily: 'Roboto'),),
                      ),),
                  )
              )
            ],
          ),
        ),
      ),
    );
//                    ListView(
//                      children:[
//                     Container(
//                       padding:
//                       const EdgeInsets.fromLTRB(20.0, 450.0, 110.0, 0.0),
//                        height: 520,
//                        child: new RaisedButton.icon(
//                          color: Color(0XFFF6F8FB),
//                            onPressed: _launchLoginUrl,
//                            icon: new Image.asset(
//                              'assets/google.png',
//                              height: height * 0.06452802359,
//                              width: 50,
//                            ),
//                            label: new Text(GOOGLE,
//                                style: new TextStyle(
//                                  fontSize: 20.0,
//                                )),
//                            shape: new RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(
//                                    height * 0.05162241887))),
//                      ),
//
//                    Row(children: [
//                      Padding(
//                        padding:
//                            const EdgeInsets.fromLTRB(58.0, 20.0, 0.0, 00.0),
//                        child: Container(
//                          height: 1.0,
//                          width: 72,
//                          color: Color.fromRGBO(255, 255, 255, 0.2),
//                        ),
//                      ),
//                      Padding(
//                        padding:
//                        const EdgeInsets.fromLTRB(15.0, 20.0, 0.0, 00.0),
//                        child: Text(
//                          'OR',
//                          style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.2),fontSize: 15.0,fontFamily: 'Roboto'),
//                        ),
//                      ),
//                      Padding(
//                        padding:
//                        const EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 00.0),
//                        child: Container(
//                          height: 1.0,
//                          width: 72,
//                          color: Color.fromRGBO(255, 255, 255, 0.2),
//                        ),
//                      ),
//                    ]),
//
//                     Row(
//                       children:[
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,0.0),
//                       child: Container(
//                         height: 55,
//                         decoration: BoxDecoration(
//                            gradient: LinearGradient(
//                              begin: Alignment.topLeft,
//                              end: Alignment(0.8, 0.0),
//                              // 10% of the width, so there are ten blinds.
//                              colors: [
//                                Color(0XFF0099B5), Color(0XFF00B55E)
//                              ], // whitish to gray
////                          tileMode: TileMode.clamp, // repeats the gradient over the canvas
//                            ),
//                            borderRadius: new BorderRadius.only(
//                              topLeft: const Radius.circular(30),
//                              topRight: const Radius.circular(30.0),
//                              bottomLeft: const Radius.circular(30),
//                              bottomRight: const Radius.circular(30),
//                            ),
//                          ),
//                          child: new RaisedButton.icon(
//                              elevation: 0,
//                              color: Colors.transparent,
//                              onPressed: _launchLoginUrlSlack,
//                              icon: new Image.asset(
//                                'assets/slack.png',
//                                height: height * 0.02581120943 * 2,
//                                width: height * 0.03871681415,
//                              ),
//                              label: new Text('$SLACK',
//                                  style: new TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 18.0,
//                                  )),
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(
//                                      height * 0.05162241887))),
//                        ),
//                     ),
//
//                    Padding(
//                      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 0),
//                      child: Container(
//                        height: 55,
//                        child: Container(
//                          decoration: BoxDecoration(
//                            gradient: LinearGradient(
//                              begin: Alignment.topLeft,
//                              end: Alignment(0.8, 0.0),
//                              // 10% of the width, so there are ten blinds.
//                              colors: [
//                                Color(0XFFD8384F), Color(0XFFE15029)
//                              ], // whitish to gray
////                          tileMode: TileMode.clamp, // repeats the gradient over the canvas
//                            ),
//                            borderRadius: new BorderRadius.only(
//                              topLeft: const Radius.circular(30),
//                              topRight: const Radius.circular(30.0),
//                              bottomLeft: const Radius.circular(30),
//                              bottomRight: const Radius.circular(30),
//                            ),
//                          ),
//                          child: new RaisedButton.icon(
//                              elevation: 0,
//                              color: Colors.transparent,
//                              onPressed: _launchLoginUrlOffice,
//                              icon: new Image.asset(
//                                'assets/office_365.png',
//                                height: height * 0.05162241887,
//                                width: height * 0.03891681415,
//                              ),
//                              label: new Text('$OFFICE',
//                                  style: new TextStyle(
//                                      color: Colors.white,
//                                    fontSize: 18.0,
//                                    fontFamily: 'Roboto'
//                                  )),
//                              shape: new RoundedRectangleBorder(
//                                  borderRadius: new BorderRadius.circular(
//                                      height * 0.05162241887))),
//                        ),
//                      ),
//                    )]),
//                  ],
//                ),
//
//          ),
//        )
//    );
  }

  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        Uri uriLink = Uri.parse(link);
        // Get token from query parameter
        token = uriLink?.queryParameters['user'];
        // Store token data in shared preferences
        utilities.setTokenData(token).then((onValue) {
          Navigator.pushReplacementNamed(
            context,
            'Dashboard',
          );
        });
        _latestLink = link ?? '$UNKNOWN';
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      Uri uriLink = Uri.parse(link);

      // Get token from query parameter
      token = uriLink?.queryParameters['user'];
      // Store token data in shared preferences
      utilities.setTokenData(token).then((onValue) {
        Navigator.pushReplacementNamed(context, 'Dashboard');
      });
    }, onError: (err) {});

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? '$UNKNOWN';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {}, onError: (err) {});

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }

  _launchLoginUrl() async {
    const url = 'https://app.meetnotes.co/login/google-oauth2/?next=/mtoken/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchLoginUrlSlack() async {
    const url = 'https://app.meetnotes.co/login/slack/?next=/mtoken/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchLoginUrlOffice() async {
    const url = 'https://app.meetnotes.co/login/azuread-oauth2/?next=/mtoken/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
