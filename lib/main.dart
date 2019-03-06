
import 'package:flutter/material.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/login.dart';
import 'package:memob/splashscreen.dart';
import 'package:fluro/fluro.dart';

void main() {

  Router router = new Router();

  // Define our splash page.
  router.define('Login', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Login();
  }));

  // Define our home page.
  router.define('Dashboard', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Dashboard();
  }));

  runApp(new MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home:  SplashScreen(), onGenerateRoute: router.generator));
} 