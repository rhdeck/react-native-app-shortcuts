#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>
@interface RCT_EXTERN_MODULE(react_native_app_shortcuts, RCTEventEmitter)
RCT_EXTERN_METHOD(addShortcut:(NSString *)key label:(NSString *)label icon:(NSString *)icon success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(removeShortcut:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(linkShortcut:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
RCT_EXTERN_METHOD(unlinkShortcut:(NSString *)key success:(RCTPromiseResolveBlock)success reject:(RCTPromiseRejectBlock)reject);
@end