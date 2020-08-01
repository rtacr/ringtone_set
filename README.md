# ringtone_set

Flutter package for easily setting device's default ringtone or notification sound.

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
RingtoneSet.setRingtone("music.mp3");
```
or
```Dart
RingtoneSet.setNotification("music.mp3");
```