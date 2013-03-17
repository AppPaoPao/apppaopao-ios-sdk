//
//  APPFeedbackViewController.m
//  AppPaoPao
//
//  Created by Richard Huang on 3/14/13.
//  Copyright (c) 2013 AppPaoPao. All rights reserved.
//

#import "APPFeedbackViewController.h"
#import "APPHttpClient.h"

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
        [APPHttpClient sendFeedback];
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

@end
