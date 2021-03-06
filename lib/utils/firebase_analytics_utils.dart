import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info/package_info.dart';

class FA {
  static FirebaseAnalytics analytics;

  static Future<void> setCurrentScreen(
      String screenName, String screenClassOverride) async {
    await analytics?.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }

  static Future<void> setUserId(String id) async {
    await analytics?.setUserId(id);
    print('setUserId succeeded');
  }

  static Future<void> setUserProperty(String name, String value) async {
    await analytics?.setUserProperty(
      name: name,
      value: value,
    );
    print('setUserProperty succeeded');
  }

  static Future<void> logUserInfo(String department) async {
    await analytics?.logEvent(
      name: 'user_info',
      parameters: <String, dynamic>{
        'department': department,
        'platform': Platform.operatingSystem,
      },
    );
    print('setUserProperty succeeded');
  }

  static Future<void> logApiEvent(String type, int status,
      {String message = ''}) async {
    await analytics?.logEvent(
      name: 'ap_api',
      parameters: <String, dynamic>{
        'type': type,
        'status': status,
        'message': message,
      },
    );
    print('logEvent succeeded');
  }

  static Future<void> logCalculateUnits(double seconds) async {
    await analytics?.logEvent(
      name: 'calculate_units_time',
      parameters: <String, dynamic>{
        'time': seconds,
      },
    );
    print('log CalculateUnits succeeded');
  }

  static const String COURSE_HTML_PARSER = 'course_html_parser';
  static const String SCORE_HTML_PARSER = 'score_html_parser';

  static Future<void> logTimeEvent(String name, double seconds) async {
    await analytics?.logEvent(
      name: name,
      parameters: <String, dynamic>{
        'time': seconds,
      },
    );
    print('log TimeEvent succeeded');
  }

  static Future<void> logAction(String name, String action,
      {String message = ''}) async {
    await analytics?.logEvent(
      name: name ?? '',
      parameters: <String, dynamic>{
        'action': action ?? '',
        'message': message ?? '',
      },
    );
  }
}
