#import "RingtoneSetPlugin.h"
#if __has_include(<ringtone_set/ringtone_set-Swift.h>)
#import <ringtone_set/ringtone_set-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ringtone_set-Swift.h"
#endif

@implementation RingtoneSetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRingtoneSetPlugin registerWithRegistrar:registrar];
}
@end
