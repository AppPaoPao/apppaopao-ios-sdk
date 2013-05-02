//
//  APPRate.m
//  AppPaoPao
//
//  Created by Richard Huang on 4/15/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "APPRate.h"
#import "AppPaoPao.h"
#import "APPHttpClient.h"

@implementation APPRate

- (void)popup
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评价"
                                                        message:[NSString stringWithFormat:@"你喜欢%@吗？", appName]
                                                     delegate:self
                                            cancelButtonTitle:@"喜欢"
                                            otherButtonTitles:@"不喜欢", nil];
	[alertView show];
    
    // bullshit, but it avoids accessing released object.
    NSRunLoop *rl = [NSRunLoop currentRunLoop];
    NSDate *d;
    d = (NSDate*)[d init];
    while ([alertView isVisible]) {
        [rl runUntilDate:d];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    APPHttpClient *client = [[APPHttpClient alloc] init];
    if (buttonIndex == 0) {
        [client sendRate:TRUE];
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                         [[AppPaoPao sharedConnection] appId]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else {
        [client sendRate:FALSE];
        [AppPaoPao presentFeedback];
    }
}
@end