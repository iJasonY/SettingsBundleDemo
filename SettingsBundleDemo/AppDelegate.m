//
//  AppDelegate.m
//  SettingsBundleDemo
//
//  Created by JasonYan on 22/10/14.
//  Copyright (c) 2014 JasonYan. All rights reserved.
//

#import "AppDelegate.h"
#import <JSPatch/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Version
  NSString *version = [[NSBundle mainBundle]
      objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  [[NSUserDefaults standardUserDefaults] setObject:version
                                            forKey:@"version_preference"];
  NSString *build =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
  [[NSUserDefaults standardUserDefaults] setObject:build
                                            forKey:@"build_preference"];
  NSString *githash =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GITHash"];
  [[NSUserDefaults standardUserDefaults] setObject:githash
                                            forKey:@"githash_preference"];

  [self setUpJSPatch];

  return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)setUpJSPatch {

  //这个是用来做条件下发的
  [JSPatch setupUserData:@{ @"userId" : @"10000" }];
  NSString *kJSPatchAppKey = @"c15ed4b765732ec0";
  [JSPatch startWithAppKey:kJSPatchAppKey];

  //用来检测回调的状态，是更新或者是执行脚本之类的，相关信息，会打印在你的控制台
  [JSPatch
      setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {

        NSLog(@"error-->%@", error);
        switch (type) {
        case JPCallbackTypeUpdate: {
          NSLog(@"更新脚本 %@ %@", data, error);
          break;
        }
        case JPCallbackTypeRunScript: {
          NSLog(@"执行脚本 %@ %@", data, error);
          break;
        }
        case JPCallbackTypeCondition: {
          NSLog(@"条件下发 %@ %@", data, error);
          break;
        }
        case JPCallbackTypeGray: {
          NSLog(@"灰度下发 %@ %@", data, error);
          break;
        }
        default:
          break;
        }
      }];

#ifdef DEBUG
  [JSPatch setupDevelopment];
#endif
  [JSPatch sync]; // 每调用一次 +sync 就会请求一次后
}

- (void)readSettingValue {
  BOOL switc = [[NSUserDefaults standardUserDefaults]
      boolForKey:@"innernetswitch_preference"];

  NSLog(@"--------%d", switc);
}

- (void)setDefultValue {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

  [self readSettingValue];
}

@end
