import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ringtone_set/src/setter_functions.dart';

class RingtoneSet {
  static const MethodChannel _channel = const MethodChannel('ringtone_set');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> setRingtone(String asset) async {
    return setFromAsset(asset: asset, action: 'setRingtone');
  }

  static Future<String> setRingtoneFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setRingtone');
  }

  static Future<String> setRingtoneFromFile(File file) async {
    return setFromFile(file: file, action: 'setRingtone');
  }

  static Future<String> setNotification(String asset) async {
    return setFromAsset(asset: asset, action: 'setNotification');
  }

  static Future<String> setNotificationFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setNotification');
  }

  static Future<String> setNotificationFromFile(File file) async {
    return setFromFile(file: file, action: 'setNotification');
  }

  static Future<String> setAlarm(String asset) async {
    return setFromAsset(asset: asset, action: 'setAlarm');
  }

  static Future<String> setAlarmFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setAlarm');
  }

  static Future<String> setAlarmFromFile(File file) async {
    return setFromFile(file: file, action: 'setAlarm');
  }
}
