import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const MethodChannel _channel = const MethodChannel('ringtone_set');

Future<String> setFromAsset({
  @required String asset,
  @required String action,
}) async {
  final path =
      '${(await getTemporaryDirectory()).path}/${asset.split('/').last}';
  final file = File(path);
  final assetload = await rootBundle.load(asset);
  await file.writeAsBytes((assetload).buffer.asUint8List());

  final String result =
      await _channel.invokeMethod(action, {"path": file.path});
  return result;
}

Future<String> setFromNetwork({
  @required String url,
  @required String action,
}) async {
  final path = '${(await getTemporaryDirectory()).path}/${url.split('/').last}';
  final file = File(path);
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);

    final String result = await setFromFile(file: file, action: action);

    return result;
  } else {
    return "failure";
  }
}

Future<String> setFromFile({
  @required File file,
  @required String action,
}) async {
  final String result =
      await _channel.invokeMethod(action, {"path": file.path});

  return result;
}
