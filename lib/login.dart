import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:memob/utilities.dart' as utilities;
import 'dart:async';
import './constants.dart';

enum UniLinksType { string, uri }

class Login extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Login> with SingleTickerProviderStateMixin {
  String _latestLink = 'Unknown';
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double x = 20;
    return Scaffold(
        backgroundColor: Color.fromRGBO(35, 45, 71, 0.9),
        body: new Container(
          transform: Matrix4.translationValues(0.0, -180.0, 0.0),
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "assets/signup_bg.png",
              ),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(30.0, height * 0.6, 150.0, 00.0),
                      child: new Text('$name',
                          style: TextStyle(
                              fontSize: 35.0,
                              color: Color.fromRGBO(255, 255, 255, 0.8))),
                    ),
                    Positioned(
                      top: height * 0.8,
                      bottom: height * 0.118,
                      left: width * 0.05,
                      right: width * 0.22,
                      child: new RaisedButton.icon(
                          onPressed: _launchLoginUrl,
                          icon: new Image.asset(
                            'assets/google.png',
                            height: 50,
                            width: 50,
                          ),
                          label: new Text('$google',
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0))),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          20.0, height * 0.9, 250.0, height * 0.022),
                      child: new RaisedButton.icon(
                          color: Colors.red,
                          onPressed: _launchLoginUrlSlack,
                          icon: new Image.asset(
                            'assets/slack.png',
                            height: 40,
                            width: 30,
                          ),
                          label: new Text('$slack',
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0))),
                    ),
                    Positioned(
                      top: height * 0.9,
                      bottom: height * 0.022,
                      left: 180.0,
                      right: 94.0,
                      child: new RaisedButton.icon(
                          color: Colors.red,
                          onPressed: _launchLoginUrlOffice,
                          icon: new Image.asset(
                            'assets/office_365.png',
                            height: 40,
                            width: 30,
                          ),
                          label: new Text('$office',
                              style: new TextStyle(
                                fontSize: 15.0,
                              )),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0))),
                    ),
                  ],
                ),
          ),
        ));
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
        _latestLink = link ?? 'Unknown';
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
        _latestLink = uri?.toString() ?? 'Unknown';
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
