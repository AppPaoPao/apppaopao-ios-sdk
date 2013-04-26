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
@property (strong, nonatomic) NSString *appId;

+ (void) initWithApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret appId:(NSString *)appId;
+ (void) presentFeedbackFromViewController:(UIViewController *)controller;
+ (void) rateApp:(UIViewController *)controller;
+ (AppPaoPao *) sharedConnection;
@end
