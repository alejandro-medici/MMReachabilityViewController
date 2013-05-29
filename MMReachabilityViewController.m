//
//  MMReachabilityViewController.m
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


#import "MMReachabilityViewController.h"
#import "Reachability.h"

#define MM_DefaultBannerHeight  44.0f
#define MM_AnimationDuration    0.5f

@interface MMView : UIView

@property (atomic, assign) BOOL animating;

- (id)initWithView:(UIView*)view;
@end

@implementation MMView

@synthesize animating;

- (id)initWithView:(UIView *)view {
    
    self = [super initWithFrame:view.frame];
    if (self) {
        
        self.alpha = view.alpha;
        self.autoresizesSubviews = view.autoresizesSubviews;
        self.autoresizingMask = view.autoresizingMask;
        self.backgroundColor = view.backgroundColor;
        self.clearsContextBeforeDrawing = view.clearsContextBeforeDrawing;
        self.clipsToBounds = view.clipsToBounds;
        self.contentMode = view.contentMode;
        self.contentScaleFactor = view.contentScaleFactor;
        self.exclusiveTouch = view.exclusiveTouch;
        self.hidden = view.hidden;
        self.multipleTouchEnabled = view.multipleTouchEnabled;
        self.opaque = view.opaque;
        self.restorationIdentifier = view.restorationIdentifier;
        self.tag = view.tag;
        self.transform = view.transform;
        self.userInteractionEnabled = view.userInteractionEnabled;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    if (!self.animating && self.frame.origin.y >= 0) {
        frame.origin.y = self.frame.origin.y;
    }
    
    [super setFrame:frame];
}

@end

static Reachability *_reachability = nil;
BOOL _reachabilityOn;

static inline Reachability* defaultReachability () {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reachability = [Reachability reachabilityForInternetConnection];
#if !__has_feature(objc_arc)
        [_reachability retain];
#endif
    });
    
    return _reachability;
}

@interface MMReachabilityViewController ()

- (void)startInternetReachability;
- (void)stopInternerReachability;
- (void)checkNetworkStatus;
@end

@implementation MMReachabilityViewController

@synthesize bannerView = _bannerView;

- (void)dealloc {
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif

    [self onDealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // replace the view controller view with an MMView
    MMView *view = [[MMView alloc] initWithView:self.view];
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews) {
        [view addSubview:subview];
    }
    
    [self setView:view];
    
#if !__has_feature(objc_arc)
    [view release];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view.superview addSubview:self.bannerView];
    [self.view.superview sendSubviewToBack:self.bannerView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self startInternetReachability];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

#pragma mark - Public interface

- (void)onDealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
    [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
}

#pragma mark - Properties overrides methods

- (UIView*)bannerView {
    
    if (!_bannerView) {
        
        UILabel *noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0.0, self.view.frame.size.width, MM_DefaultBannerHeight)];
        [noConnectionLabel setText:@"No internet connection!"];
        [noConnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [noConnectionLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [noConnectionLabel setBackgroundColor:[UIColor yellowColor]];
        [self setBannerView:noConnectionLabel];
        
#if !__has_feature(objc_arc)
        [noConnectionLabel release];
#endif
    }
    
    return _bannerView;
}

- (void)setBannerView:(UIView*)bannerView {
    
#if !__has_feature(objc_arc)
    [_bannerView release];
    [bannerView retain];
#endif
    
    _bannerView = bannerView;
    _bannerView.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - Private methods

- (void)startInternetReachability {
    
    if (!_reachabilityOn) {
        _reachabilityOn = TRUE;
        [defaultReachability() startNotifier];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus) name:kReachabilityChangedNotification object:nil];
    
    [self checkNetworkStatus];
}

- (void)stopInternerReachability {
    
    _reachabilityOn = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)showBanner {
    
    if (self.view.frame.origin.y == 0) {
        
        ((MMView*)self.view).animating = TRUE;
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += self.bannerView.frame.size.height;
        viewFrame.size.height -= self.bannerView.frame.size.height;
        
        [UIView animateWithDuration:MM_AnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view setFrame:viewFrame];
            
        } completion:^(BOOL finished) {
            ((MMView*)self.view).animating = FALSE;
        }];
    }
}

- (void)hideBanner {
    
    if (self.view.frame.origin.y > 0) {
        
        ((MMView*)self.view).animating = TRUE;
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= self.bannerView.frame.size.height;
        viewFrame.size.height += self.bannerView.frame.size.height;
        
        [UIView animateWithDuration:MM_AnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.view setFrame:viewFrame];
            
        } completion:^(BOOL finished) {
            ((MMView*)self.view).animating = FALSE;
        }];
    }
}

- (void)checkNetworkStatus {
    
    // called after network status changes
    NetworkStatus internetStatus = [defaultReachability() currentReachabilityStatus];
    switch (internetStatus) {
            
        case NotReachable: {
            
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
            [self performSelector:@selector(showBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        case ReachableViaWiFi:
        case ReachableViaWWAN: {
            
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(showBanner) object:nil];
            [MMReachabilityViewController cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBanner) object:nil];
            [self performSelector:@selector(hideBanner) withObject:nil afterDelay:0.1]; // performed with a small delay to avoid multiple notification causing stange jumping
            break;
        }
            
        default:
            break;
    }
}

@end
