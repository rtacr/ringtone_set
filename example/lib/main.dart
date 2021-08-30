import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ringtone_set/ringtone_set.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                    onPressed: () async {
                      bool success = false;
                      try {
                        success = await RingtoneSet.setRingtone("assets/h1.mp3");
                      } on PlatformException {
                        success = false;
                      }
                      var snackBar;
                      if (success) {
                        snackBar = SnackBar(content: Text("Ringtone set successfully!"));
                      } else {
                        snackBar = SnackBar(content: Text("Error"));
                      }
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Hey Ringtone")),
                FlatButton(
                    onPressed: () async {
                      bool success = false;
                      try {
                        success = await RingtoneSet.setNotification("assets/h1.mp3");
                      } on PlatformException {
                        success = false;
                      }
                      var snackBar;
                      if (success) {
                        snackBar = SnackBar(content: Text("Notification set successfully!"));
                      } else {
                        snackBar = SnackBar(content: Text("Error"));
                      }
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Hey Notification")),
                FlatButton(
                    onPressed: () async {
                      bool success = false;
                      try {
                        success = await RingtoneSet.setRingtone("assets/untitled.mp3");
                      } on PlatformException {
                        success = false;
                      }
                      var snackBar;
                      if (success) {
                        snackBar = SnackBar(content: Text("Ringtone set successfully!"));
                      } else {
                        snackBar = SnackBar(content: Text("Error"));
                      }
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Untitled Ringtone")),
                FlatButton(
                    onPressed: () async {
                      bool success = false;
                      try {
                        success =
                            await RingtoneSet.setNotification("assets/untitled.mp3");
                      } on PlatformException {
                        success = false;
                      }
                      var snackBar;
                      if (success) {
                        snackBar = SnackBar(content: Text("Notification set successfully!"));
                      } else {
                        snackBar = SnackBar(content: Text("Error"));
                      }
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Text("Untitled Notification")),
              ],
            ),
          );
        }),
      ),
    );
  }
}
