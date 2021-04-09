import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class RingtoneSet {
  static const MethodChannel _channel = const MethodChannel('ringtone_set');

  Future<ByteData> loadAsset(String name) async {
    return await rootBundle.load('assets/$name');
  }

  Future<String> getPath(String asset) async {
    final path = '${(await getTemporaryDirectory()).path}/$asset';
    final file = File(path);
    await file.writeAsBytes((await loadAsset(asset)).buffer.asUint8List());
    return path;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> setRingtoneFromAsset(String asset) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';
    final file = File(path);
    final assetload = await rootBundle.load(asset);
    await file.writeAsBytes((assetload).buffer.asUint8List());

    final String result = await setRingtoneFromFile(file);

    return result;
  }

  static Future<String> setRingtoneFromNetwork(String url) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
    final file = File(path);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);

      final String result = await setRingtoneFromFile(file);

      return result;
    } else {
      return "failure";
    }
  }

  static Future<String> setRingtoneFromFile(File file) async {
    final String result =
        await _channel.invokeMethod('setRingtone', {"path": file.path});

    return result;
  }

  static Future<String> setNotificationFromAsset(String asset) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';
    final file = File(path);
    final assetload = await rootBundle.load(asset);
    await file.writeAsBytes((assetload).buffer.asUint8List());

    final String result = await setNotificationFromFile(file);
    return result;
  }

  static Future<String> setNotificationFromNetwork(String url) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
    final file = File(path);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);

      final String result = await setNotificationFromFile(file);

      return result;
    } else {
      return "failure";
    }
  }

  static Future<String> setNotificationFromFile(File file) async {
    final String result =
        await _channel.invokeMethod('setNotification', {"path": file.path});
    return result;
  }

  static Future<String> setAlarmFromAsset(String asset) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';
    final file = File(path);
    final assetload = await rootBundle.load(asset);
    await file.writeAsBytes((assetload).buffer.asUint8List());

    final String result = await setAlarmFromFile(file);
    return result;
  }

  static Future<String> setAlarmFromNetwork(String url) async {
    final path =
        '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
    final file = File(path);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);

      final String result = await setAlarmFromFile(file);

      return result;
    } else {
      return "failure";
    }
  }

  static Future<String> setAlarmFromFile(File file) async {
    final String result =
    await _channel.invokeMethod('setAlarm', {"path": file.path});
    return result;
  }
}
