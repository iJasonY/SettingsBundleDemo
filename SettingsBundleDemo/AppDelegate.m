//
//  AppDelegate.m
//  SettingsBundleDemo
//
//  Created by JasonYan on 22/10/14.
//  Copyright (c) 2014 JasonYan. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugly/Bugly.h>
#import <JSPatch/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    [Bugly startWithAppId:kBuglyAppID];

    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)setUpJSPatch
{

    /* 用来检测回调的状态，是更新或者是执行脚本之类的，相关信息，会打印在你的控制台
    在 `+startWithAppKey:` 之前调用
   */
    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
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

    //这个是用来做条件下发的
    [JSPatch setupUserData:@{ @"userId" : @"10000" }];
    NSString *kJSPatchAppKey = @"c15ed4b765732ec0";
    [JSPatch startWithAppKey:kJSPatchAppKey];

#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif

    [JSPatch sync]; // 每调用一次 +sync
                    // 就会请求一次后台，请求下发最新补丁包，但是新的补丁包会在下次打开APP的时候生效。
}

- (void)readSettingValue
{
    BOOL switc = [[NSUserDefaults standardUserDefaults]
        boolForKey:@"innernetswitch_preference"];

    NSLog(@"--------%d", switc);
}

- (void)setDefultValue
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

    [self readSettingValue];
}

@end
