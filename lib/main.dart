import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memob/actionItems.dart';
import 'package:memob/analyticUtil.dart';
import 'package:memob/dashboard.dart';
import 'package:memob/localization.dart';
import 'package:memob/notes.dart';
import 'package:memob/NotesClass.dart';
import 'package:memob/login.dart';
import 'package:memob/splashscreen.dart';
import 'package:memob/utilities.dart' as utilities;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import './recentlyUpdated.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Router router = new Router();

  List<NotesClass> _notes = new List();

  // Define our splash page.
  router.define('Splash', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new SplashScreen();
      }));

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

  router.define('RecentNotes', handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new RecentlyUpdated(_notes);
      }));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        initialRoute: 'Splash',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: AnalyticUtil.analytics),
        ],
        onGenerateRoute: router.generator,
        localizationsDelegates: [
          const LocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
        ]));

  });
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
