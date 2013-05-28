//
//  PresentModalViewController.m
//  MMReachabilityViewController
//
//  Created by Manuele Maggi on 28/05/2013.
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//

#import "PresentModalViewController.h"
#import "PushViewController.h"

@interface PresentModalViewController ()

@end

@implementation PresentModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *dismissButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)] autorelease];
    self.navigationItem.leftBarButtonItem = dismissButton;
}

- (IBAction)pushButtonPressed:(id)sender {
    
    PushViewController *reachabilityVC = [[[PushViewController alloc] initWithNibName:@"PushViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:reachabilityVC animated:YES];
}

- (void)cancelButtonPressed {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
