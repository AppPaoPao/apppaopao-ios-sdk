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
#import "APPSyncer.h"

@implementation AppPaoPao

@synthesize apiKey;
@synthesize apiSecret;
@synthesize appId;

static AppPaoPao *sharedConnection = nil;

+ (void) initWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret appId:(NSString *)appId
{
    [self sharedConnection].apiKey = apiKey;
    [self sharedConnection].apiSecret = apiSecret;
    [self sharedConnection].appId = appId;
    APPSyncer *syncer = [[APPSyncer alloc] init];
    [syncer sync];
}

+ (void)presentFeedback
{
    APPFeedbackViewController *vc = [[APPFeedbackViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    [topController presentViewController:vc animated:TRUE completion:nil];
}

+ (void)rateApp
{
    APPRate *rate = [[APPRate alloc] init];
    [rate popup];
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
