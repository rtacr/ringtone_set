# ringtone_set

Flutter package for easily setting device's default ringtone, notification sound and alarm.

> [!IMPORTANT]
> Works only on Android

[![pub package](https://img.shields.io/pub/v/ringtone_set.svg)](
https://pub.dartlang.org/packages/ringtone_set)
</a>
<img src="https://img.shields.io/badge/platform-android%20-%23989898" />

## Getting Started

Add these lines to **AndroidManifest.xml**. 
```xml
<manifest>
...
    <uses-permission android:name="android.permission.WRITE_SETTINGS"
        tools:ignore="ProtectedPermissions" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
...
</manifest>
```

### Set from assets

Put your sounds into \<yourapp\>/assets/
add them to your **pubspec.yaml**
```yaml
flutter:
  assets:
    - assets/music.mp3
```


```yaml
dependencies:
  ringtone_set: ^0.0.2
```
Import the package
```Dart
import 'package:ringtone_set/ringtone_set.dart';
```
Call the function
```Dart
RingtoneSet.setRingtone("assets/music.mp3");
```
or
```Dart
RingtoneSet.setNotification("assets/music.mp3");
```
or
```Dart
RingtoneSet.setAlarm("assets/music.mp3");
```

### Set from Network
You can also set ringtone from network URL:

```Dart
RingtoneSet.setRingtoneFromNetwork("https://example.com/music.mp3");
```
or
```Dart
RingtoneSet.setNotificationFromNetwork("https://example.com/music.mp3");
```
or
```Dart
RingtoneSet.setAlarmFromNetwork("https://example.com/music.mp3");
```

### Set from File
Finally, you can set ringtone from a `File` object as well:

```Dart
final File ringtoneFile = File("music.mp3");

RingtoneSet.setRingtoneFromFile(ringtoneFile);

RingtoneSet.setNotificationFromFile(ringtoneFile);

RingtoneSet.setAlarmFromFile(ringtoneFile);
```
