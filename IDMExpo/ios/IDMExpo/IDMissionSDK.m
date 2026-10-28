//
//  IDMissionSDK.m
//  idmission
//

#import "IDMissionSDK.h"
#import <React/RCTEventEmitter.h>
#import "IDMExpo-Swift.h"

@interface IDMissionSDK ()

@end

@implementation IDMissionSDK

// The app uses a UIScene lifecycle (Expo SDK 58), so the app delegate's window
// is nil. Find the root view controller from the active window scene instead.
static UIViewController *IDMRootViewController(void)
{
  for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
      continue;
    }
    for (UIWindow *window in ((UIWindowScene *)scene).windows) {
      if (window.isKeyWindow && window.rootViewController) {
        return window.rootViewController;
      }
    }
  }
  return UIApplication.sharedApplication.delegate.window.rootViewController;
}

static IDMissionSDK *gInstance = NULL;

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onSessionConnect",@"DataCallback"];

}

RCT_EXPORT_METHOD(initializeSDK:(NSString *)apiBaseUrl authUrl:(NSString *)authUrl debug:(NSString *)debug accessToken:(NSString *)accessToken)
{
  UIViewController *rootViewController = IDMRootViewController();
  gInstance = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [rootViewController viewDidLoad];
    id objects[] = { apiBaseUrl, authUrl, debug, accessToken };
    id keys[] = { @"apiBaseUrl", @"authUrl", @"debug", @"accessToken"};
    NSUInteger count = sizeof(objects) / sizeof(id);
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys
                                                             count:count];
    
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client initializeSDKWithData:dictionary instances:rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID20)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startIDValidationsWithInstances: rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID10)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startIDValidationAndMatchFacesWithInstances: rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID50:(NSString *)uniqueNumber)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startIDValidationAndCustomerEnrollsWithUniqueNumbers:uniqueNumber instances:rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID175:(NSString *)uniqueNumber)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startCustomerEnrollBiometricssWithUniqueNumbers:uniqueNumber instances:rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID105:(NSString *)uniqueNumber)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startCustomerVerificationsWithUniqueNumbers:uniqueNumber instances:rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID185)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startIdentifyCustomersWithInstances: rootViewController];
  });
}

RCT_EXPORT_METHOD(serviceID660)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client startLiveFaceChecksWithInstances: rootViewController];
  });
}

RCT_EXPORT_METHOD(submitResult)
{
  UIViewController *rootViewController = IDMRootViewController();
  
  dispatch_async(dispatch_get_main_queue(), ^{
    IDentitySDKHelper *client = [IDentitySDKHelper new];
    [client submitResultWithInstances:rootViewController];
  });
}

RCT_EXPORT_MODULE(IDMissionSDK);

+ (void)getEvent: (NSString*)type dict:(NSMutableDictionary*) dict
{
 
  [gInstance sendEventWithName:type body:dict];

}

- (void) getEvent2: (NSString*)type dict:(NSMutableDictionary*) dict
{
  [gInstance sendEventWithName:type body:dict];
}

@end
