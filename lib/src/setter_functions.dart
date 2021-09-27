import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ringtone_set/ringtone_set.dart';

const MethodChannel _channel = const MethodChannel('ringtone_set');

/// Sets [action] from asset path.
///
/// [action] can be `"setRingtone"`, `"setNotification"`, `"setAlarm"`.
Future<bool> setFromAsset({
  required String asset,
  required String action,
  // TODO: remove
  required StorageDirectory storageDirectoryType,
}) async {
  final path = await getPath(
    src: asset,
    storageDirectoryType: storageDirectoryType,
  );

  // final path = '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';

  // print("PATH $path");

  final file = File(path);
  final loadedAsset = await rootBundle.load(asset);
  await file.writeAsBytes((loadedAsset).buffer.asUint8List());

  final bool result = await _channel.invokeMethod(action, {"path": file.path});
  return result;
}

/// Parses mimeType from the "content-type" header of [response].
Future<String?> parseMimeType(http.Response response) async {
  final headers = response.headers;
  final contentTypeHeader = headers["content-type"];
  String? mimeType;
  if (contentTypeHeader != null) {
    final contentType = ContentType.parse(contentTypeHeader);
    mimeType = contentType.mimeType;
  }
  return mimeType;
}

/// Sets [action] from network URL.
///
/// [action] can be `"setRingtone"`, `"setNotification"`, `"setAlarm"`.
Future<bool> setFromNetwork({
  required String url,
  required String action,
  // TODO: remove
  required StorageDirectory storageDirectoryType,
}) async {
  // final path = '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
  final path = await getPath(
    src: url,
    storageDirectoryType: storageDirectoryType,
  );
  final file = File(path);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);
    final mimeType = await parseMimeType(response);

    final bool result = await _channel.invokeMethod(
      action,
      {"path": file.path, "mimeType": mimeType},
    );

    return result;
  } else {
    throw Exception(
      "Network error. Code ${response.statusCode}, ${response.reasonPhrase}",
    );
  }
}

// TODO: refactor
Future<String> getPath({
  required String src,
  required StorageDirectory storageDirectoryType,
}) async {
  final int sdk = await RingtoneSet.platformSdk;

  if (sdk >= 29) {
    // Android 10 or newer
    return '${(await getTemporaryDirectory()).path}/${src.split('/').last}';
  } else {
    // Android 9 or older
    final ringtoneDirectories = await getExternalStorageDirectories(
      type: storageDirectoryType,
    );
    final directory = ringtoneDirectories!.first.path;
    return '$directory/${src.split('/').last}';
  }
}

// TODO: test for Android 9 or older
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
