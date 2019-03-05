import 'package:flutter/material.dart';
import 'package:memob/homepage.dart';
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
  router.define('HomePage', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new HomePage();
  }));

  runApp(new MaterialApp(
      home:  SplashScreen(), onGenerateRoute: router.generator));
} 