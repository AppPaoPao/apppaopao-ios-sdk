//
//  APPSync.m
//  AppPaoPao
//
//  Created by Richard Huang on 4/20/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "APPSyncer.h"
#import "APPHttpClient.h"

@implementation APPSyncer

- (void) sync
{
    APPHttpClient *client = [[APPHttpClient alloc] init];
    [client sync];
}
@end
