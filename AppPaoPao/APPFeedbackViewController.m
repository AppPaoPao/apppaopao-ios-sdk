//
//  APPFeedbackViewController.m
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "APPFeedbackViewController.h"
#import "APPHttpClient.h"

#define APP_EMAIL @"APP_EMAIL"

@interface APPFeedbackViewController ()

@end

@implementation APPFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"AppPaoPaoResources" withExtension:@"bundle"]];
    self = [self initWithNibName:@"APPFeedbackViewController" bundle:bundle];
    
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 1.0;
        if ([[NSUserDefaults standardUserDefaults] valueForKey:APP_EMAIL]) {
            self.emailTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:APP_EMAIL];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendFeedback:(id)sender {
    if (self.emailTextField.text.length == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"请输入电子邮件地址！"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:APP_EMAIL];
    APPHttpClient *client = [[APPHttpClient alloc] init];
    [client sendFeedback:self.titleTextField.text content:self.contentTextView.text userEmail:self.emailTextField.text userPhone:self.phoneTextField.text];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cancelFeedback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.tag = 1;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length] == 0)
    {
        textView.text = @"反馈内容";
        textView.textColor = [UIColor lightGrayColor];
        textView.tag = 0;
    }
}

- (void)textViewDidBeginEditing:(UITextField *)textView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self animateTextView:textView up:YES];
    }
}


- (void)textViewDidEndEditing:(UITextField *)textView
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self animateTextView:textView up:NO];
    }
}


- (void)animateTextView:(UITextField*)textView up:(BOOL)up
{
    int animatedDistance;
    int moveUpValue = textView.frame.origin.y + textView.frame.size.height;
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        
        animatedDistance = 216-(460-moveUpValue-60);
    }
    else
    {
        animatedDistance = 162-(320-moveUpValue-60);
    }
    
    if(animatedDistance>0)
    {
        const int movementDistance = animatedDistance;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(BOOL)textViewShouldReturn:(UITextField *)textView
{    
    [textView resignFirstResponder];
    return YES;
}
@end
