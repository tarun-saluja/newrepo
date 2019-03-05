import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memob/homepage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
       var _iconAnimationController;
       var _iconAnimation ;
  void handleTimeout() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  @override
  void initState() {
    super.initState();
     _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
     _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.easeIn);
   _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Scaffold(
        body: new Center(
            child: new Image(
          image: new AssetImage("assets/meetnotes_icon.png"),
          width: _iconAnimation.value * 100,
          height: _iconAnimation.value * 100,
        )),
      ),
    );
  }
}
