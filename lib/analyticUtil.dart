

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:meta/meta.dart';


class AnalyticUtil{

  static FirebaseAnalytics analytics = FirebaseAnalytics();

  static Future<void> sendScreenView({@required String screenName,
    String screenClassOverride = 'Flutter'}) async {
    await AnalyticUtil.analytics.setCurrentScreen(screenName: screenName,
        screenClassOverride: screenClassOverride);
  }

  static Future<void> sendEvent({@required String name,
    Map<String, dynamic> parameters}) async {
    await AnalyticUtil.analytics.logEvent(name: name, parameters: parameters);
  }



}
