//
//  AppPaoPao.m
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "AppPaoPao.h"
#import "APPFeedbackViewController.h"
#import "APPRate.h"

@implementation AppPaoPao

@synthesize apiKey;
@synthesize apiSecret;
@synthesize appName;
@synthesize appId;

static AppPaoPao *sharedConnection = nil;

+ (void)setApiKey:(NSString *)apiKey
{
    [self sharedConnection].apiKey = apiKey;
}

+ (void)setApiSecret:(NSString *)apiSecret
{
    [self sharedConnection].apiSecret = apiSecret;
}

+ (void)setAppName:(NSString *)appName
{
    [self sharedConnection].appName = appName;
}

+ (void)setAppId:(NSString *)appId
{
    [self sharedConnection].appId = appId;
}

+ (void)presentFeedbackFromViewController:(UIViewController *)viewController
{
    APPFeedbackViewController *vc = [[APPFeedbackViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [viewController presentViewController:vc animated:TRUE completion:nil];
}

+ (void)rateApp:(UIViewController *)viewController
{
    APPRate *rate = [[APPRate alloc] init];
    [rate popup:viewController];
}

+ (AppPaoPao *)sharedConnection
{
    @synchronized(self) {
		if (sharedConnection == nil) {
			sharedConnection = [[AppPaoPao alloc] init];
		}
	}
	return sharedConnection;
}
@end
