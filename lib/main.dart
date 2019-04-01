import 'package:flutter/material.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/login.dart';
import 'package:memob/settings.dart';
import 'package:memob/splashscreen.dart';
import 'package:fluro/fluro.dart';
import './constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:memob/utilities.dart' as utilities;

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

  router.define('ActionItems', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new ActionItems();
  }));

  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        //brightness: Brightness.dark
      ),
      home: SplashScreen(),
      onGenerateRoute: router.generator));
}

Future<Null> initUniLink() async {
  try {
    String initialLink = await getInitialLink();

    if (initialLink != null) {
      List<String> link = initialLink.split("=");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', link[1]);
    }
  } on Exception {
    utilities.showLongToast("exception");
  }
}
