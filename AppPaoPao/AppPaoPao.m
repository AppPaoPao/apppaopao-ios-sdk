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
