//
//  MainViewController.m
//  MMReachabilityViewController
//
//  Version 1.0
//
//  Created by Manuele Maggi on 28/05/2013.
//  email: manuele.maggi@gmail.com
//  Copyright (c) 2013-present Manuele Maggi. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "MainViewController.h"
#import "ExampleViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"MMReachabilityViewController";
}

- (IBAction)pushButtonPressed:(id)sender {
    
    ExampleViewController *reachabilityVC = [[[ExampleViewController alloc] initWithNibName:@"ExampleViewController" bundle:nil] autorelease];
    reachabilityVC.mode = MMReachabilityModeOverlay;
    reachabilityVC.visibilityTime = 3.0;
    [self.navigationController pushViewController:reachabilityVC animated:YES];
}

- (IBAction)presentModalButtonPressed:(id)sender {
    
    ExampleViewController *reachabilityVC = [[[ExampleViewController alloc] initWithNibName:@"ExampleViewController" bundle:nil] autorelease];
    reachabilityVC.mode = MMReachabilityModeResize;
    reachabilityVC.visibilityTime = 3.0;
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:reachabilityVC] autorelease];
    [self.navigationController presentViewController:navController animated:YES completion:NULL];
}


@end
