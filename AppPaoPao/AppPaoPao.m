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

+ (void) presentFeedbackFromViewController:viewController
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *bundlePath = [path stringByAppendingPathComponent:@"AppPaoPaoResources.bundle"];
	NSBundle *bundle = [[NSBundle alloc] initWithPath:bundlePath];
    
    APPFeedbackViewController *vc = [[APPFeedbackViewController alloc] init];
    [viewController presentViewController:vc animated:TRUE completion:nil];
}
@end
