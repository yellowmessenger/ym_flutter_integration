#import "YmBotSdkPlugin.h"
#if __has_include(<ym_bot_sdk/ym_bot_sdk-Swift.h>)
#import <ym_bot_sdk/ym_bot_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ym_bot_sdk-Swift.h"
#endif

@implementation YmBotSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYmBotSdkPlugin registerWithRegistrar:registrar];
}
@end
