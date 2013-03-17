//
//  AppPaoPao.h
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppPaoPao : NSObject

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSString *apiSecret;

+ (void) setApiKey:(NSString *)apiKey;
+ (void) setApiSecret:(NSString *)apiSecret;
+ (void) presentFeedbackFromViewController:(UIViewController *)controller;
+ (AppPaoPao *) sharedConnection;
@end
