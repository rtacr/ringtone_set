import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const MethodChannel _channel = const MethodChannel('ringtone_set');

/// Sets [action] from asset path.
///
/// [action] can be `"setRingtone"`, `"setNotification"`, `"setAlarm"`.
Future<bool> setFromAsset({
  required String asset,
  required String action,
}) async {
  final path =
      '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';
  final file = File(path);
  final loadedAsset = await rootBundle.load(asset);
  await file.writeAsBytes((loadedAsset).buffer.asUint8List());

  final bool result = await _channel.invokeMethod(action, {"path": file.path});
  return result;
}

/// Sets [action] from network URL.
///
/// [action] can be `"setRingtone"`, `"setNotification"`, `"setAlarm"`.
Future<bool> setFromNetwork({
  required String url,
  required String action,
}) async {
  final path = '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
  final file = File(path);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);

    final bool result = await setFromFile(file: file, action: action);

    return result;
  } else {
    throw Exception(
      "Network error. Code ${response.statusCode}, ${response.reasonPhrase}",
    );
  }
}

/// Sets [action] from file.
///
/// [action] can be `"setRingtone"`, `"setNotification"`, `"setAlarm"`.
Future<bool> setFromFile({
  required File file,
  required String action,
}) async {
  final bool result = await _channel.invokeMethod(action, {"path": file.path});

  return result;
}
