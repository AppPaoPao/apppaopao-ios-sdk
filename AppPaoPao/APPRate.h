//
//  APPRate.h
//  AppPaoPao
//
//  Created by Richard Huang on 4/15/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPRate : NSObject <UIAlertViewDelegate>

@property (nonatomic, retain) UIViewController *viewController;
- (void)popup:(UIViewController *)viewController;
@end
