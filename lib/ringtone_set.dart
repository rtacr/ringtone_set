import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

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

  static Future<String> setRingtone(String asset) async {
    
    final path = '${(await getTemporaryDirectory()).path}/$asset';
    final file = File(path);
    final assetload = await rootBundle.load(asset);
    await file.writeAsBytes((assetload).buffer.asUint8List());
    
    final String result = await _channel
        .invokeMethod('setRingtone', {"path":  path});
        
    return result;
  }

  static Future<String> setNotification(String asset) async {
    
    final path = '${(await getTemporaryDirectory()).path}/$asset';
    final file = File(path);
    final assetload = await rootBundle.load(asset);
    await file.writeAsBytes((assetload).buffer.asUint8List());

    final String result = await _channel
        .invokeMethod('setNotification', {"path":  path});
    return result;
  }
}
