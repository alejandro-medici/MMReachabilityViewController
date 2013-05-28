//
//  MainViewController.m
//  MMReachabilityViewController
//
//  Created by Manuele Maggi on 28/05/2013.
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//

#import "MainViewController.h"
#import "MMReachabilityViewController.h"
#import "PushViewController.h"
#import "PresentModalViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (IBAction)pushButtonPressed:(id)sender {
    
    PushViewController *reachabilityVC = [[[PushViewController alloc] initWithNibName:@"PushViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:reachabilityVC animated:YES];
}

- (IBAction)presentModalButtonPressed:(id)sender {
    
    PresentModalViewController *reachabilityVC = [[[PresentModalViewController alloc] initWithNibName:@"PresentModalViewController" bundle:nil] autorelease];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:reachabilityVC] autorelease];
    [self.navigationController presentViewController:navController animated:YES completion:NULL];
}


@end
