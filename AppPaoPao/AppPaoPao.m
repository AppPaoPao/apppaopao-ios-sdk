//
//  AppPaoPao.m
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "AppPaoPao.h"
#import "APPFeedbackViewController.h"

@implementation AppPaoPao

@synthesize apiKey;
@synthesize apiSecret;

static AppPaoPao *sharedConnection = nil;

+ (void)setApiKey:(NSString *)apiKey
{
    [self sharedConnection].apiKey = apiKey;
}

+ (void)setApiSecret:(NSString *)apiSecret
{
    [self sharedConnection].apiSecret = apiSecret;
}

+ (void)presentFeedbackFromViewController:(UIViewController *)viewController
{
    APPFeedbackViewController *vc = [[APPFeedbackViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    [viewController presentViewController:vc animated:TRUE completion:nil];
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
