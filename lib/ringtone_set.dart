import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ringtone_set/src/setter_functions.dart';

/// A class for setting ringtones, notifications, alarms.
class RingtoneSet {
  static const MethodChannel _channel = const MethodChannel('ringtone_set');

  /// Android SDK version code.
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Status of the `WRITE_SETTINGS` permission.
  ///
  /// Returns `true` if the permission has been granted.
  /// On Android 5.1(SDK 22) and older always returns `true`.
  static Future<bool> get isWriteSettingsGranted async {
    final bool granted = await _channel.invokeMethod('isWriteGranted');
    return granted;
  }

  /// Sets ringtone from asset.
  static Future<bool> setRingtone(String asset) async {
    return setFromAsset(asset: asset, action: 'setRingtone');
  }

  /// Sets ringtone from network URL.\
  static Future<bool> setRingtoneFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setRingtone');
  }

  /// Sets ringtone from file.
  static Future<bool> setRingtoneFromFile(File file) async {
    return setFromFile(file: file, action: 'setRingtone');
  }

  /// Sets notification from asset path.
  static Future<bool> setNotification(String asset) async {
    return setFromAsset(asset: asset, action: 'setNotification');
  }

  /// Sets notification from network URL.
  static Future<bool> setNotificationFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setNotification');
  }

  /// Sets notification from file.
  static Future<bool> setNotificationFromFile(File file) async {
    return setFromFile(file: file, action: 'setNotification');
  }

  /// Sets alarm from asset path.
  static Future<bool> setAlarm(String asset) async {
    return setFromAsset(asset: asset, action: 'setAlarm');
  }

  /// Sets alarm from network URL.
  static Future<bool> setAlarmFromNetwork(String url) async {
    return setFromNetwork(url: url, action: 'setAlarm');
  }

  /// Sets alarm from file.
  static Future<bool> setAlarmFromFile(File file) async {
    return setFromFile(file: file, action: 'setAlarm');
  }
}
