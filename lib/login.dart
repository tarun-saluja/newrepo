import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:dio/dio.dart';
import 'dart:async';

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
        print('------------------------------------------------------------------------');
        print("hello");
      //  print(uriLink.userInfo.getSessionId());
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
      print('got link: $link');

      Uri uriLink = Uri.parse(link);

      // Get token from query parameter
      token = uriLink?.queryParameters['user'];
      // Store token data in shared preferences
      utilities.setTokenData(token).then((onValue) {
        Navigator.pushReplacementNamed(context, 'Dashboard');
      });
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
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
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(31, 47, 69, 1.0),
        body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "assets/signup_bg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      top: 560.0,
                      bottom:110.0,
                      left: 60.0,
                      right: 50.0,
                      child: new RaisedButton.icon(
                          onPressed: _launchLoginUrl,
                          icon: new Image.asset(
                            'assets/google.png',
                            height: 60,
                            width: 50,
                          ),
                          label: new Text('Sign up with Google',
                              style: new TextStyle(
                                fontSize: 20.0,
                              )),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0))),
                    ),
                  ],
                ),
          ),
          //  Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     new Center(
          //       child: new RaisedButton.icon(
          //          onPressed: _launchLoginUrl,
          //           icon: new Image.asset('assets/google.png',height: 60,width: 60,),
          //           label: new Text('Sign up with Google',
          //               style: new TextStyle(
          //                 fontSize: 15.0,
          //               )),
          //           shape: new RoundedRectangleBorder(
          //               borderRadius: new BorderRadius.circular(30.0))),
          //     ),
          //   ],
          // ),
        ));
  }
}
