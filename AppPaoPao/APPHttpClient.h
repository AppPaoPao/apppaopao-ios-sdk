//
//  Authorization.h
//  AppPaoPao
//
//  Created by Richard Huang on 3/16/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface APPHttpClient : NSObject <MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

-(void) sync;
-(void) sendRate:(Boolean)like;
-(void) sendFeedback:(NSString *)title content:(NSString *)content userEmail:(NSString *)email userPhone:(NSString *)phone;
@end