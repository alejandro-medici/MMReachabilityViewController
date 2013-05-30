//
//  ExampleViewController.m
//  MMReachabilityViewController
//
//  Created by Manuele Maggi on 30/05/2013.
//  Copyright (c) 2013 Manuele Maggi. All rights reserved.
//

#import "ExampleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ExampleViewController ()
@end

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setText:@"MMReachabilityViewController"];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.presentingViewController) {
        UIBarButtonItem *dismissButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)] autorelease];
        self.navigationItem.leftBarButtonItem = dismissButton;
    }
}

- (void)dealloc {
    
    [self onDealloc];
    [super dealloc];
}

- (void)cancelButtonPressed {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)bannerView {
    
    if (!_bannerView) {
        
        UIView *bannerView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, 38.0)];
        [bannerView setBackgroundColor:(self.mode == MMReachabilityModeOverlay ? [UIColor clearColor] : [UIColor whiteColor])];
        
        UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0.0, bannerView.frame.size.width, bannerView.frame.size.height)];
        [noConnectionLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [noConnectionLabel setTextColor:[UIColor whiteColor]];
        [noConnectionLabel setShadowColor:[UIColor blackColor]];
        [noConnectionLabel setText:@"No internet connection!"];
        [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [noConnectionLabel setBackgroundColor:[UIColor clearColor]];
        [noConnectionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = noConnectionLabel.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0.8 green:0 blue:0 alpha:0.8] CGColor],
                           (id)[[UIColor colorWithRed:0.4 green:0 blue:0 alpha:0.8] CGColor],
                           nil];
        [bannerView.layer insertSublayer:gradient atIndex:0];
        
        [bannerView addSubview:noConnectionLabel];
        [noConnectionLabel release];
        
        [self setBannerView:bannerView];
        [bannerView release];
    }
    
    return _bannerView;
}

@end
