import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Future<String> token = utilities.getTokenData();
    token.then((value) {
      if (value != null) {
        Navigator.pushReplacementNamed(
          context,
          'Dashboard',
        );
      } else {
        Navigator.pushReplacementNamed(context, 'Login');
      }
    });
  }


  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body:
        LayoutBuilder(
          builder: (context, constraints) =>
              Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: new Image.asset('assets/meetnotes_icon.png'),
                  ),
                ],
              ),
        ),
        );
  }
}

// Future<Null> initUniLink() async {
//   try {
//     String initialLink = await getInitialLink();

//     if (initialLink != null) {
//       List<String> link = initialLink.split("=");
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString('token', link[1]);
//     }
//   } on Exception {
//     utilities.showLongToast("exception");
//   }
// }