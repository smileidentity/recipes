#import "SmileIDModule.h"
#import "RnWrapperRecipe-Swift.h"

@implementation SmileIDModule

RCT_EXPORT_MODULE(SmileID)

RCT_REMAP_METHOD(initialize,
  initializeWithUseSandbox:(BOOL)useSandbox
  enableCrashReporting:(BOOL)enableCrashReporting
  config:(nullable NSDictionary *)config
  apiKey:(nullable NSString *)apiKey
  resolver:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *configJson = nil;
  if (config != nil) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:config options:0 error:nil];
    if (data) configJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }

  [SmileIDBridge initializeSDK:useSandbox
         enableCrashReporting:enableCrashReporting
                    configJson:configJson
                        apiKey:apiKey];

  resolve(nil);
}

RCT_REMAP_METHOD(setCallbackUrl,
  setCallbackUrlWithUrl:(nullable NSString *)url
  resolver:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject)
{
  [SmileIDBridge setCallbackUrl:url];
  resolve(nil);
}

@end
