//
//  BRNAppDelegate.m
//  Burn
//
//  Created by Adam Venturella on 7/14/13.
//  Copyright (c) 2013 HappyGravity. All rights reserved.
//

#import "BRNAppDelegate.h"
#import "NSData+AES256.h"
#import "NSData+Base64.h"
#import "NSData+Hex.h"
#import <GameKit/GameKit.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation BRNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //NSString * key = @"33c86029e4681c70fff004303173083a62219d95436f5bcb0f334dab836b2a83";
    NSString * plainData = @"p0g0spaws";
    NSString * password = @"m4Ry74d411++l3l4m13";
    NSString * salt = @"48c875f402b45bc7";
    NSString * outText;


    uint8_t key[kCCKeySizeAES256] = {0};
    
    CCKeyDerivationPBKDF(kCCPBKDF2,
                         [password UTF8String],
                         [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                         (const uint8_t*)[salt UTF8String],
                         [salt lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
                         kCCPRFHmacAlgSHA256,
                         100000,
                         key,
                         kCCKeySizeAES256);
    
    uint8_t hmac[CC_SHA256_DIGEST_LENGTH] = {0};
    
    CCHmac(kCCHmacAlgSHA256,
           key,
           kCCHmacAlgSHA256,
           [plainData UTF8String],
           [plainData lengthOfBytesUsingEncoding: NSUTF8StringEncoding],
           hmac);
    
    NSData *hmacData = [NSData dataWithBytes: hmac length: CC_SHA256_DIGEST_LENGTH];
    NSString * data = [hmacData hexadecimalString];
    NSLog(@"%@", data);
    // 24856dc171be96209c7cfc3f3b0f78e22faeeea3db616b7fa087dcbd846da5cb
    // 24856dc171be96209c7cfc3f3b0f78e22faeeea3db616b7fa087dcbd846da5cb
    // e61fffc16f57ddfe2206cca983d8653b3d6e0d1eaa1713eaa940077645e6226f

    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            NSLog(@"NEEDS AUTH");
            [self.window addSubview:viewController.view];
        }
        else if (localPlayer.isAuthenticated)
        {
            NSLog(@"PLAYER AUTHENTICATED");
            NSLog(@"%@", localPlayer.playerID);
            NSLog(@"%@", localPlayer.displayName);
            NSLog(@"%@", localPlayer.alias);
            //NSString * input = localPlayer.alias;
            //NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
            //NSString * b64 = [[data AES256EncryptWithKey:key] base64EncodedString];
            //NSLog(@"%@", b64);
        }
        else
        {
            NSLog(@"No GC");
            //[self disableGameCenter];
        }
    };
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
