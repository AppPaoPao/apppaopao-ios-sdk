//
//  APPFeedbackViewController.h
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPFeedbackViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
- (IBAction)sendFeedback:(id)sender;
- (IBAction)cancelFeedback:(id)sender;

@end
