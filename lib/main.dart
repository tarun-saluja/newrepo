<<<<<<< HEAD

=======
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
>>>>>>> 04d1cde8a738f4495c2143e4f7106ae0d552394b

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