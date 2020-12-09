#import "YmFlutterIntegrationPlugin.h"
#if __has_include(<ym_flutter_integration/ym_flutter_integration-Swift.h>)
#import <ym_flutter_integration/ym_flutter_integration-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ym_flutter_integration-Swift.h"
#endif

@implementation YmFlutterIntegrationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYmFlutterIntegrationPlugin registerWithRegistrar:registrar];
}
@end
