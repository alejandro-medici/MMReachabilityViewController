//
//  MainViewController.m
//  MMReachabilityViewController
//
//  Version 1.0
//
//  Created by Manuele Maggi on 28/05/2013.
//  email: manuele.maggi@gmail.com
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//
//  MMReachabilityViewController is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  MMReachabilityViewController is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with MMReachabilityViewController.  If not, see <http://www.gnu.org/licenses/>.

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
